# from inter_query import BaselineManager, compute_plan_stats, Location, BYTES_TO_GB, BYTES_TO_TB, create_bit_string_from_list
from inter_query import *
import json
from enum import Enum
import math
from argparse import ArgumentParser
import sys
import csv
import os
from table_names import *
from typing import List, Dict

def process_subset(bm, table_set, query_bit_vecs, n, use_duck=False, exclude_type=None, exclude=None):

    baseline_runtime, baseline_cost = bm.get_baseline_totals(exclude_type=exclude_type,
            exclude=exclude, query_bit_vecs=query_bit_vecs)

    best_table_set = table_set
    best_subset = create_bit_string_from_list(best_table_set)
    best_query_set = get_covered_queries(query_bit_vecs, best_subset, bm,
                                         exclude_type=exclude_type,
                                         exclude=exclude)

    print(best_table_set)
    print(best_query_set.keys())
    print(len(best_table_set))
    print(f"Optimal Subset: {bin(best_subset)}")
    print(best_query_set.keys())

    # ensure that no duplicates exist
    assert not any(best_table_set.count(x) > 1 for x in best_table_set)

    all_keys = bm.get_key_set(exclude_type=exclude_type,
            exclude=exclude, query_bit_vecs=query_bit_vecs)

    stayed_queries = []
    for k in all_keys: 
        if k not in best_query_set:
            stayed_queries.append(k)

    # ensure all queries are assigned to a backend and no queries are assigned
    # to both
    assert len(stayed_queries) + len(best_query_set.keys()) == len(all_keys)
    assert len(stayed_queries & best_query_set.keys()) == 0

    all_tables = [i for i in range(n)]
    if exclude_type == "t":
        i = bm.table_indices.index(exclude)
        all_tables.remove(i) # remove table from consideration

    num_dependencies = {t: 0 for t in all_tables}
    query_savings = bm.compute_savings_for_all_queries(all_keys)
    total_query_set = {k: query_bit_vecs[k] for k in all_keys if query_savings[k] > 0}
    for k in total_query_set:
        v = total_query_set[k]
        for tbl in all_tables:
            t = (v >> tbl) & 0x1
            if t == 1:
                num_dependencies[tbl] += 1

    removed_table_with_dep = False
    removed_tables = [i for i in all_tables if i not in best_table_set]
    assert len(removed_tables + best_table_set) == len(all_tables)
    for t in removed_tables:
        if num_dependencies[t] > 0:
            removed_table_with_dep = True
            break

    plan_type = ""
    if removed_table_with_dep and len(best_table_set) > 0 and len(best_table_set) < len(all_tables):
        # truly multi cloud
        plan_type = "multi"
    elif len(best_table_set) == 0:
        # stayed in start loc 
        plan_type = "stay"
    elif len(best_table_set) == len(all_tables):
        # all tables are moved
        plan_type = "move"
    elif not removed_table_with_dep and len(best_table_set) > 0:
        # all tables are moved except those without any deps => # removed_table_with_dep false
        plan_type = "move"
    else:
        plan_type = "wtf"

    tbl_names = [bm.table_indices[i] for i in best_table_set]
    stayed_tbl_names = [bm.table_indices[i] for i in all_tables if i not in best_table_set]

    # compute_plan_stats(bm, best_query_set, best_table_set, keys, {}, [])

    mvmt_cost = bm.movement_cost(best_table_set)
    # just for workload metadata
    covered_runtime = 0
    uncovered_runtime = 0

    covered_costs = 0
    num_covered = 0
    uncovered_costs = 0
    num_uncovered = 0
    rs_total_load_time = 0
    rs_total_load_cost = 0

    total_runtime = 0
    total_runtime_stay = 0
    total_runtime_move = 0

    storage_runtime = 0
    for q in all_keys:
        if q in best_query_set:
            covered_costs += bm.get_alt_cost(q)
            covered_runtime += bm.get_alt_runtime(q)

            total_runtime_move += bm.get_alt_runtime(q)
            total_runtime += bm.get_alt_runtime(q)
            storage_runtime += bm.get_alt_runtime(q) 
            num_covered += 1
        else:
            uncovered_costs += bm.get_baseline_cost(q)
            uncovered_runtime += bm.get_baseline_runtime(q)
            total_runtime_stay += bm.get_baseline_runtime(q)
            total_runtime += bm.get_baseline_runtime(q)
            num_uncovered += 1
    
    # load time, cost
    extra_storage_size_gb = 0
    for tname in tbl_names:
        load_time, load_cost = bm.get_load_time_and_cost(tname)
        rs_total_load_time += load_time
        storage_runtime += load_time
        rs_total_load_cost += load_cost

        size_gb = bm.table_size_gb[tname]
        extra_storage_size_gb += size_gb

    storage_cost = ((storage_runtime / 3600) / 730) * extra_storage_size_gb * 0.023
    mvmt_runtime = bm.get_size_of_table_set(best_table_set) / bm.transfer_thruput # size in GB times GBps
    mvmt_runtime_vm_cost = 1.38 * (mvmt_runtime / 3600)
    mvmt_cost += mvmt_runtime_vm_cost

    # api cost
    api_cost = 0
    for tbl in best_table_set:
        api_cost += bm.api_call_cost(tbl)

    migration_cost = mvmt_cost + rs_total_load_cost + storage_cost + api_cost

    total_runtime += mvmt_runtime
    total_runtime += rs_total_load_time

    total_runtime_move += mvmt_runtime
    total_runtime_move += rs_total_load_time
    arachne_runtime = max(total_runtime_move, total_runtime_stay)

    final_cost = (covered_costs + uncovered_costs + mvmt_cost + rs_total_load_cost + storage_cost + api_cost) # all dollars
    print(f"Real: {final_cost}, {covered_costs}, {uncovered_costs}, {mvmt_cost}, {rs_total_load_cost}, {storage_cost}, {api_cost}")

    diff = baseline_cost - final_cost
    percent_diff = (diff / baseline_cost) * 100
    profiling_runtime, profiling_cost = bm.get_profiling_stats(n,
            exclude_type=exclude_type, exclude=exclude, query_bit_vecs=query_bit_vecs)

    breakdown = {}
    breakdown["moved_cost"] = covered_costs
    breakdown["moved_runtime"] = covered_runtime
    breakdown["stayed_cost"] = uncovered_costs
    breakdown["stayed_runtime"] = uncovered_runtime
    breakdown["mvmt_cost"] = mvmt_cost
    breakdown["mvmt_runtime"] = mvmt_runtime
    breakdown["load_cost"] = rs_total_load_cost
    breakdown["load_runtime"] = rs_total_load_time
    breakdown["storage_cost"] = storage_cost
    breakdown["storage_runtime"] = storage_runtime
    breakdown["api_cost"] = api_cost
    breakdown["moved_queries"] = sorted(list(best_query_set.keys()))
    breakdown["stayed_queries"] = sorted(stayed_queries)
    breakdown["moved_tables"] = sorted(list(tbl_names))
    breakdown["stayed_tables"] = sorted(list(stayed_tbl_names))

    data = {}
    data["arachne"] = final_cost
    data["arachne_runtime"] = arachne_runtime # seconds
    data["baseline_cost"] = baseline_cost
    data["baseline_runtime"] = baseline_runtime # seconds
    data["percent_diff"] = percent_diff
    data["multi_cloud_plan"] = plan_type
    data["profiling_runtime"] = profiling_runtime
    data["profiling_cost"] = profiling_cost
    data["exec_details"] = breakdown

    total = None
    add = f"{bm.egress_cost}_{bm.rs_cost}_{bm.bq_cost}"
    fname = f"outputs_NOPROFILE_noduck_{bm.start_loc.name}_{add}.json"
    print(fname)
    if use_duck:
        add = f"{bm.egress_cost}_{bm.rs_cost}_{bm.bq_cost}_{bm.duck_cost}"
        fname = f"outputs_NOPROFILE_duck_{add}.json"

    if bm.no_calcite:
        if use_duck:
            add = f"{bm.egress_cost}_{bm.rs_cost}_{bm.bq_cost}_{bm.duck_cost}"
            fname = f"outputs_NOPROFILE_NOCALCITE_duck_{add}.json"
        else:
            add = f"{bm.egress_cost}_{bm.rs_cost}_{bm.bq_cost}"
            fname = f"outputs_NOPROFILE_NOCALCITE_noduck_{bm.start_loc.name}_{add}.json"

    try:
        with open(fname, "r") as fp:
            total = json.load(fp)
    except Exception as e:
        total = {}
    
    if exclude is None:
        total['all'] = data
    else:
        total[exclude] = data
    with open(fname, "w") as fp:
        json.dump(total, fp, indent=4, sort_keys=True)

    start = ""
    dest = ""
    if bm.start_loc.name == "gcp":
        start = "GCP"
        dest = "Redshift"
    else:
        start = "Redshift"
        dest = "GCP"

    print(f"Num {dest} Qs: {num_covered}; Num {start} Qs: {num_uncovered}")
    print(f"PLAN TYPE IS: {plan_type}")
    print(f"Moved Qs: ${covered_costs}; Stayed Qs: ${uncovered_costs}; Migration Cost: ${migration_cost}")
    print(f"Movement Cost: ${mvmt_cost}, Load Cost: ${rs_total_load_cost}, Storage Cost: ${storage_cost}, API Cost: ${api_cost}")
    print(f"Final cost: ${final_cost}, Baseline: ${baseline_cost}, Diff: ${diff}, %: {percent_diff}%")
    # return best_table_set, best_query_set



if __name__ == '__main__':
    parser = ArgumentParser(description="Grab Pricing Details for Specific Subset")

    parser.add_argument("--no_calcite", action="store_true", help="Don't use calcite profiles")
    parser.add_argument("--duck", action="store_true", help="Use DuckDB in Analysis")
    parser.add_argument("--egress", type=float, help="Egress cost")
    parser.add_argument("--duck_cost", type=float, default=1.48, help="DuckDB Hourly Cost in dollars")
    parser.add_argument("--rs_cost", type=float, default=1.086, help="Redshift Hourly Cost in dollars")
    parser.add_argument("--bq_cost", type=float, default=6.25, help="BigQuery Per TB Cost in dollars")
    parser.add_argument("--exclude_table", type=str, default=None, help="Table to exclude (must be in list of tables based on benchmark_name)")
    parser.add_argument("--exclude_qry", type=str, default=None, help="Query num to exclude")
    parser.add_argument("--cluster_size", type=int, default=1, help="Number of Redshift nodes in cluster")

    parser.add_argument("benchmark_name", choices=['tpcds', 'tpch', 'ldbc'], help="Name of benchark")
    parser.add_argument("start_loc", choices=['aws', 'gcp'], help="Where data begins")
    parser.add_argument("path", help="Path with data for analysis")
    args = parser.parse_args()

    cluster_rs_cost = args.rs_cost * args.cluster_size

    egress = -1
    if args.egress == None:
        if args.start_loc == "aws":
            egress = 0.09
        elif args.start_loc == "gcp":
            egress = 0.12
    else:
        egress = args.egress


    print(f"Data Starting In: {args.start_loc}")
    print(f"Egress: ${egress}/GB")
    print(f"Benchmark: {args.benchmark_name}")
    print(f"Data Path: {args.path}")
    print(f"BigQuery Cost: ${args.bq_cost}/TB; DuckDB Cost: ${args.duck_cost}/hr; Redshift Cost: ${cluster_rs_cost}/hr")
    print(f"Use Duck: {args.duck}")
    print(f"Using calcite profiles: {not args.no_calcite}")
    print(f"Excluded Table: {args.exclude_table}")
    print(f"Excluded Query: {args.exclude_qry}")
    print("")

    start_loc: Location = None
    if args.start_loc == "aws":
        start_loc = Location.AWS
    elif args.start_loc == "gcp":
        start_loc = Location.GCP
    else:
        raise RuntimeError("Invalid starting location provided")

    if args.duck:
        assert start_loc == Location.GCP, "Only support DuckDB when data starts in BigQuery"

    # duckdb load costs
    duck_load_cost = 0
    if "parquet_1000" in args.path:
        # total_dataset_size_parquet = 420.4
        duck_load_time = 1074.556
        duck_load_cost = (duck_load_time / 3600) * args.duck_cost
    elif "parquet_2000":
        # total_dataset_size_parquet = 688.0
        duck_load_time = 1847.364
        duck_load_cost = (duck_load_time / 3600) * args.duck_cost


    initial_profile = json.load(open("time_series/100/outputs_NOCALCITE_noduck_GCP_0.12_4.344_6.25.json"))

    os.chdir(args.path)
    table_indices = None
    if args.benchmark_name == "tpcds":
        table_indices = tpcds_names
    elif args.benchmark_name == "tpch":
        table_indices = tpch_names
    else: 
        if "postgres" in args.path:
            table_indices = ldbc_psql_names
        else:
            table_indices = ldbc_names
    
    tsize_file = open("table_sizes.json")
    table_sizes_bytes = json.load(tsize_file)

    # this MUST be the file size being moved in parquet--this is used to calc
    # egress cost
    table_size_gb = {}
    for t in table_sizes_bytes:
        table_size_gb[t] = table_sizes_bytes[t] / BYTES_TO_GB

    fp = open("query_bit_vec.json")
    x = json.load(fp)
    query_bit_vecs = {k: v for k, v in sorted(x.items(), key = lambda item: item[1])}

    exclude_type = None
    exclude = None
    if args.exclude_table and args.exclude_qry:
        raise Exception(f"Invalid: cannot exclude query and table in the same run; may only specify either exclude_qry or exclude_table, not both")

    if args.exclude_table is not None:
        if args.exclude_table not in table_indices:
            raise Exception(f"Table {args.exclude_table} not in list of table names for benchmark {args.benchmark_name}")
        exclude_type = 't'
        exclude = args.exclude_table
    if args.exclude_qry is not None:
        if args.exclude_qry not in query_bit_vecs:
            raise Exception(f"Query {args.exclude_qry} not in list of queries with bit vecs")
        exclude_type = 'q'
        exclude = args.exclude_qry

    table_names = None
    if exclude:
        table_names = initial_profile[exclude]["exec_details"]["moved_tables"]
    else:
        table_names = initial_profile['all']["exec_details"]["moved_tables"]


    bm = BaselineManager(egress_cost = egress, start_loc = start_loc,
            use_duck=args.duck, table_indices=table_indices,
            table_size_gb=table_size_gb, bq_cost=args.bq_cost,
            duck_cost=args.duck_cost, rs_cost = cluster_rs_cost,
            duck_load_cost=duck_load_cost, no_calcite = args.no_calcite)

    table_set = [bm.table_indices.index(t) for t in table_names]

    process_subset(bm, table_set, query_bit_vecs, len(table_indices),
                   use_duck=args.duck, exclude_type=exclude_type,
                   exclude=exclude)


