import json
import math
from argparse import ArgumentParser
import sys
import os
from table_names import *

class BaselineManager:
    def __init__(self, egress_cost, bytes_to_gb, bytes_to_tb, use_duck=False,
            table_indices=None, table_size_gb=None, bq_cost=5, duck_cost=1.48,
            rs_cost=1.086, duck_load_cost=0.0):
        home = os.path.expanduser("~")
        self.use_duck = use_duck
        self.table_indices = table_indices
        self.table_size_gb = table_size_gb
        self.egress_cost = egress_cost
        self.bytes_to_gb = bytes_to_gb
        self.bytes_to_tb = bytes_to_tb
        self.transfer_thruput = 0.4 # GBps
        self.put_price = 0.05 / 10000 # $/request
        self.get_price = 0.004 / 10000 # $/request 

        self.bq_cost = bq_cost
        self.duck_cost = duck_cost
        self.rs_cost = rs_cost

        self.duck = json.load(open(f"duck_baseline.json"))
        self.duck_c = json.load(open(f"duck_c_baseline.json"))
        self.duck_load_cost = duck_load_cost

        self.rs = json.load(open(f"rs_baseline.json"))
        self.rs_c = json.load(open(f"rs_c_baseline.json"))
        self.bq = json.load(open(f"bigquery_baseline.json"))

        # load times for Redshift (seconds)
        self.rs_load_times = json.load(open(f"rs_load_times.json"))

        # remove keys for which we have biquery data but the query failed to run
        remove = [k for k in self.bq if self.bq[k]['bytes'] is None]
        for k in remove: del self.bq[k]

    def api_call_cost(self, subset):
        get_cost = 0
        put_cost = 0
        n = len(self.table_indices) 
        for i in range(n):
            v = (subset >> i) & 0x1
            if v == 1:
                chunk_size_gb = 64 / 1024 # 64mb per chunk
                tbl_name = table_indices[i]
                size_gb = self.table_size_gb[tbl_name]
                num_chunks = min(size_gb / chunk_size_gb, 9990)
                get_cost += num_chunks * self.get_price # do num_chunks gets
                # do same num of uploads, plus one compete_multipart_upload request
                # (classified as a post), plus 1 COPY request per table per table
                put_cost += (num_chunks + 1 + 1) * self.put_price 
        return get_cost + put_cost

    def get_load_time_and_cost(self, tname):
        if tname not in self.rs_load_times:
            raise Exception(f"no load time for table name: {tname}")

        t = self.rs_load_times[tname]
        cost = (t/3600) * self.rs_cost
        return t, cost

    def get_storage_cost(self, subset, rs_runtime):
        n = len(self.table_indices) 
        storage_size = 0
        storage_time = rs_runtime

        for i in range(n):
            v = (subset >> i) & 0x1
            if v == 1:
                tname = table_indices[i]
                storage_size += self.table_size_gb[tname]
                t = self.rs_load_times[tname]
                storage_time += t

        storage_cost = ((storage_time / 3600) / 730) * storage_size * 0.023
        return storage_cost

    def get_load_costs(self, subset):
        n = len(self.table_indices) 
        load_cost = 0
        for i in range(n):
            v = (subset >> i) & 0x1
            if v == 1:
                tname = table_indices[i]
                t = self.rs_load_times[tname]
                cost = (t/3600) * self.rs_cost
                load_cost += cost
        return load_cost

    def get_key_set_final(self, exclude_type=None, exclude=None, query_bit_vecs=None):
        keys = (self.rs.keys() | self.rs_c.keys()) 
        if self.use_duck:
            # keys = keys & (self.bq.keys() | self.duck.keys() | self.duck_c.keys())
            keys = keys & self.bq.keys()
            keys = keys & (self.duck.keys() | self.duck_c.keys())
        else:
            keys = keys & self.bq.keys()

        if exclude_type == 't':
            i = self.table_indices.index(exclude)
            to_remove = []
            for q in query_bit_vecs:
                v = query_bit_vecs[q]
                t = (v >> i) & 0x1
                if t == 1:
                    to_remove.append(q)

            # remove queries from consideration 
            for q in to_remove: 
                if q in keys:
                    keys.remove(q)
        elif exclude_type == 'q':
            keys.remove(exclude)
        return keys

    def get_rs_time(self, k):
        min_time = -1
        if k in self.rs:
            rsr1 = self.rs[k]
            min_time = rsr1
        if k in self.rs_c:
            rsr2 = self.rs_c[k]
            if min_time == -1 or rsr2 < min_time:
                min_time = rsr2
        return min_time

    def get_rs_cost(self, k):
        min_value = -1
        if k in self.rs:
            rsr1 = self.rs[k]
            crs1 = (rsr1 / 3600) * self.rs_cost
            min_value = crs1
        if k in self.rs_c:
            rsr2 = self.rs_c[k]
            crs2 = (rsr2 / 3600) * self.rs_cost
            if min_value == -1 or crs2 < min_value:
                min_value = crs2
        return min_value

    def get_duck_cost(self, k):
        min_value = -1
        if k == "67":
            return 1.8621060588
        if k in self.duck:
            dr1 = self.duck[k]
            cd1 = (dr1 / 3600) * self.duck_cost
            min_value = cd1
        if k in self.duck_c:
            dr2 = self.duck_c[k]
            cd2 = (dr2 / 3600) * self.duck_cost
            if min_value == -1 or cd2 < min_value:
                min_value = cd2
        return min_value

    def is_duck_cheaper(self, k):
        assert self.use_duck == True
        s = self.bq[k]["bytes"] / self.bytes_to_tb
        cs = s * self.bq_cost
        duck_cost = self.get_duck_cost(k)
        return (duck_cost < cs)

    def get_gcp_cost(self, k):
        s = self.bq[k]["bytes"] / self.bytes_to_tb
        cs = s * self.bq_cost

        if self.use_duck:
            duck_cost = self.get_duck_cost(k)
            return min(cs, duck_cost)
        else:
            return cs

    def gcp_bq_cheaper(self, k):
        if self.use_duck:
            vals = []
            duck_cost = self.get_duck_cost(k)
            s = self.bq[k]["bytes"] / self.bytes_to_tb
            cs = s * self.bq_cost
            return (cs < duck_cost)
        return True

    def get_baseline_totals(self, exclude_type=None, exclude=None, query_bit_vecs=None):
        keys = self.get_key_set_final(exclude_type=exclude_type, exclude=exclude, query_bit_vecs=query_bit_vecs)
        rs_total = 0
        rs_c_total = 0
        duck_total = 0
        duck_c_total = 0
        bq_total = 0

        duck_total += 0.5 * self.duck_cost
        duck_c_total += 0.5 * self.duck_cost
        for k in keys:
            if k in self.rs:
                rsr1 = self.rs[k]
                crs1 = (rsr1 / 3600) * self.rs_cost
                rs_total += crs1
            else:
                rsr2 = self.rs_c[k]
                crs2 = (rsr2 / 3600) * self.rs_cost
                rs_total += crs2

            if k in self.rs_c:
                rsr2 = self.rs_c[k]
                crs2 = (rsr2 / 3600) * self.rs_cost
                rs_c_total += crs2
            else:
                rsr1 = self.rs[k]
                crs1 = (rsr1 / 3600) * self.rs_cost
                rs_c_total += crs1

            s = self.bq[k]["bytes"] / self.bytes_to_tb
            cs = s * self.bq_cost
            bq_total += cs
            if self.use_duck:
                if k in self.duck:
                    dr1 = self.duck[k]
                    cd1 = (dr1 / 3600) * self.duck_cost
                    duck_total += cd1
                else: 
                    dr2 = self.duck_c[k]
                    cd2 = (dr2 / 3600) * self.duck_cost
                    duck_total += cd2

                if k in self.duck_c:
                    dr2 = self.duck_c[k]
                    cd2 = (dr2 / 3600) * self.duck_cost
                    duck_c_total += cd2
                else:
                    dr1 = self.duck[k]
                    cd1 = (dr1 / 3600) * self.duck_cost
                    duck_c_total += cd1
                # dr1 = self.duck[k]
                # dr2 = self.duck_c[k]
                # cd1 = (dr1 / 3600) * self.duck_cost
                # cd2 = (dr2 / 3600) * self.duck_cost
                # duck_total += cd1
                # duck_c_total += cd2

        if self.use_duck:
            print(f"Duck Total: ${duck_total}, Duck-Calcite Total: ${duck_c_total}, Redshift Total: ${rs_total}, Redshift-Calcite Total: ${rs_c_total}, BigQuery Total: ${bq_total}")
            return min(duck_total, duck_c_total, bq_total)
        else:
            print(f"Redshift Total: ${rs_total}, Redshift-Calcite Total: ${rs_c_total}, BigQuery Total: ${bq_total}")
            return bq_total

'''
What queries are covered by this subset and will hence move to Redshift
Exclude those queries which either depend on an excluded table, are excluded
explicitly, or are cheaper in GCP to start with
'''
def get_covered_queries(query_bit_vecs, subset, baselineManager,
        exclude_type=None, exclude=None):
    covered = []
    uncovered = []
    keys = baselineManager.get_key_set_final(exclude_type=exclude_type, exclude=exclude, query_bit_vecs=query_bit_vecs)
    for k in keys:
        vec = query_bit_vecs[k]
        res = vec & subset
        rs_cost = baselineManager.get_rs_cost(k)
        gcp_cost = baselineManager.get_gcp_cost(k)
        cheaper_in_rs = (rs_cost < gcp_cost)
        if res == vec and cheaper_in_rs:
            covered.append(k)
        else:
            uncovered.append(k)

    return covered, uncovered

'''
We skip over any subset containing the excluded table;
hence, we need not consider that here, and can assume the subset is properly
filtered, and can instead just get the movement cost of the subset without other
checks
'''
def movement_cost(subset, mvmt_cost, baselineManager):
    # despite exclusion, the index of the table matters a lot to the bit
    # strings, hence we do not remove it from even bit string consideration, but
    # rather assume that its bit will always be set to 0 in these subsets
    n = len(baselineManager.table_indices) 
    size = 0
    for i in range(n):
        v = (subset >> i) & 0x1
        if v == 1:
            tbl_name = table_indices[i]
            size_gb = table_size_gb[tbl_name]
            # print(f"{tbl_name}, {size_gb}")
            size += size_gb

    mvmt_runtime = size / baselineManager.transfer_thruput 
    mvmt_runtime_vm_cost = 1.38 * (mvmt_runtime / 3600)
    ret = (size * mvmt_cost) + mvmt_runtime_vm_cost
    return ret

def evaluate_subset(query_bit_vecs, subset, baselineManager, exclude_type=None,
        exclude=None):
    covered_qs, uncovered_qs = get_covered_queries(query_bit_vecs, subset,
            baselineManager, exclude_type=exclude_type, exclude=exclude)
    mvmt_cost = movement_cost(subset, baselineManager.egress_cost,
            baselineManager) # cost in $
    load_cost = baselineManager.get_load_costs(subset)

    covered_costs = 0
    uncovered_costs = 0
    rs_runtime = 0
    for q in covered_qs:
        covered_costs += baselineManager.get_rs_cost(q)
        rs_runtime += baselineManager.get_rs_time(q)

    query_in_duck = False
    for q in uncovered_qs:
        uncovered_costs += baselineManager.get_gcp_cost(q)
        if baselineManager.use_duck:
            if baselineManager.is_duck_cheaper(q):
                query_in_duck = True

    duck_load_cost = 0
    if query_in_duck == True:
        duck_load_cost = baselineManager.duck_load_cost

    if not baselineManager.use_duck:
        assert duck_load_cost == 0

    api_cost = baselineManager.api_call_cost(subset) 
    storage_cost = baselineManager.get_storage_cost(subset, rs_runtime)
    print(f"{covered_costs} {uncovered_costs} {duck_load_cost} {mvmt_cost} {load_cost} {storage_cost} {api_cost}")
    return (covered_costs + uncovered_costs + duck_load_cost + mvmt_cost + load_cost + storage_cost + api_cost) # all dollars

def subset_metadata(query_bit_vecs, subset, baselineManager, bq_baseline_cost,
        exclude_type=None, exclude=None):
    covered_qs, uncovered_qs = get_covered_queries(query_bit_vecs, subset,
            baselineManager, exclude_type=exclude_type, exclude=exclude)
    mvmt_cost = movement_cost(subset, baselineManager.egress_cost,
            baselineManager) # cost in $
    load_cost = baselineManager.get_load_costs(subset)

    covered_costs = 0
    num_covered = 0
    uncovered_costs = 0
    num_uncovered = 0
    rs_runtime = 0
    for q in covered_qs:
        covered_costs += baselineManager.get_rs_cost(q)
        rs_runtime += baselineManager.get_rs_time(q)
        num_covered += 1

    for q in uncovered_qs:
        uncovered_costs += baselineManager.get_gcp_cost(q)
        num_uncovered += 1  
    storage_cost = baselineManager.get_storage_cost(subset, rs_runtime)

    # final cost computation
    final_cost =  (covered_costs + uncovered_costs + mvmt_cost + load_cost + storage_cost) # all dollars
    diff = bq_baseline_cost - final_cost
    percent_diff = (diff / bq_baseline_cost) * 100

    # print table names being moved
    for tbl in range(len(baselineManager.table_indices)):
        t = (subset >> tbl) & 0x1
        if t == 1:
            print(baselineManager.table_indices[tbl])

    print(f"Num Redshift Qs: {num_covered}; Num GCP Qs: {num_uncovered}")
    print(f"Redshift Qs: ${covered_costs}; GCP Qs: ${uncovered_costs}; Movement Cost: ${mvmt_cost}")
    print(f"Final cost: ${final_cost}, BQ Baseline: ${bq_baseline_cost}, Diff: ${diff}, %: {percent_diff}%")


def find_best_subset(baselineManager, query_bit_vecs, n, egress_cost,
        use_duck=False, exclude_type=None, exclude=None):
    if use_duck:
        print("Starting analysis using DuckDB")
    else:
        print("Starting analysis without using DuckDB")

    max_val = (1 << n)
    bq_baseline_cost = baselineManager.get_baseline_totals(exclude_type=exclude_type, exclude=exclude, query_bit_vecs=query_bit_vecs)
    print(f"Number of keys: {len(baselineManager.get_key_set_final(exclude_type=exclude_type, exclude=exclude, query_bit_vecs=query_bit_vecs))}")
    exclude_ind = None
    if exclude_type == "q":
        # this case was handled by get_key_set_final taking exclusion params
        # just here for debugging prints
        print(f"Excluding query {exclude}")
    elif exclude_type == "t":
        # queries were pruned by get_key_set final; tables will be handled by
        # excluding subsets that include this table
        print(f"Excluding table {exclude} and any queries that depend on it")
        exclude_ind = baselineManager.table_indices.index(exclude)

    print(f"{exclude}; {exclude_ind}")
    min_cost = 0
    min_subset = None

    second_min_cost = 0
    second_min_subset = None

    third_min_cost = 0
    third_min_subset = None

    counter = 0
    num_cheaper_plans = 0
    for i in range(max_val):
        if exclude_ind is not None:
            t = (i >> exclude_ind) & 0x1
            if t == 1:
                continue

        counter += 1
        cost = evaluate_subset(query_bit_vecs, i, baselineManager,
                exclude_type=exclude_type, exclude=exclude)
        if cost < bq_baseline_cost:
            num_cheaper_plans += 1
        if min_subset is None or cost < min_cost:
            third_min_cost = second_min_cost
            third_min_subset = second_min_subset

            second_min_cost = min_cost
            second_min_subset = min_subset

            min_subset = i
            min_cost = cost
        elif second_min_subset is None or cost < second_min_cost:
            third_min_cost = second_min_cost
            third_min_subset = second_min_subset

            second_min_cost = cost
            second_min_subset = i
        elif third_min_subset is None or cost < third_min_cost:
            third_min_cost = cost
            third_min_subset = i

    print(f"Optimal Subset: {bin(min_subset)}")
    print(f"Cost of new plan by subset ({min_subset}, {bin(min_subset)}): ${min_cost}")
    print(f"found {num_cheaper_plans} plans cheaper than baseline over {counter} total plans considered")
    subset_metadata(query_bit_vecs, min_subset, baselineManager,
            bq_baseline_cost, exclude_type=exclude_type, exclude=exclude)
    # if use_duck:
    #     num_gcp_bq_qs = 0
    #     keys = baselineManager.get_key_set_final(
    #             exclude_type=exclude_type, 
    #             exclude=exclude, 
    #             query_bit_vecs=query_bit_vecs)
    #     for q in keys: 
    #         if q not in curr_query_set:
    #             if baselineManager.gcp_bq_cheaper(q): 
    #                 num_gcp_bq_qs += 1
    #     
    #     print(f"Num BigQuery Qs: {num_gcp_bq_qs}; Num DuckDB Qs: {num_uncovered - num_gcp_bq_qs}")
    
    print(f"Cost of Second Cheapest plan by subset ({second_min_subset}, {bin(second_min_subset)}): ${second_min_cost}")
    print(f"Cost of Third Cheapest plan by subset ({third_min_subset}, {bin(third_min_subset)}): ${third_min_cost}")

if __name__ == '__main__':
    parser = ArgumentParser(description="Run inter-query analysis")

    parser.add_argument("--duck", action="store_true", help="Use DuckDB in Analysis")
    parser.add_argument("--egress", type=float, default=0.12, help="Egress cost")
    parser.add_argument("--duck_cost", type=float, default=1.48, help="DuckDB Hourly Cost in dollars")
    parser.add_argument("--rs_cost", type=float, default=1.086, help="Redshift Hourly Cost in dollars")
    parser.add_argument("--bq_cost", type=float, default=5, help="BigQuery Per TB Cost in dollars")
    parser.add_argument("--base_two", action="store_true", help="Determine how GB conversion should work")
    parser.add_argument("--exclude_table", type=str, default=None, help="Table to exclude (must be in list of tables based on benchmark_name)")
    parser.add_argument("--exclude_qry", type=str, default=None, help="Query num to exclude")
    parser.add_argument("--cluster_size", type=int, default=1, help="Number of Redshift nodes in cluster")
    parser.add_argument("benchmark_name", choices=['tpcds', 'tpch', 'ldbc'], help="Name of benchark")
    parser.add_argument("path", help="Path with data for analysis")
    args = parser.parse_args()

    cluster_rs_cost = args.rs_cost * args.cluster_size
    print(f"Egress: ${args.egress}/GB")
    print(f"Benchmark: {args.benchmark_name}")
    print(f"Data Path: {args.path}")
    print(f"BigQuery Cost: ${args.bq_cost}/TB; DuckDB Cost: ${args.duck_cost}/hr; Redshift Cost: ${cluster_rs_cost}/hr")
    print(f"Use Duck: {args.duck}") 
    print(f"Excluded Table: {args.exclude_table}")
    print(f"Excluded Query: {args.exclude_qry}")
    print("")

    os.chdir(args.path)
    table_indices = None
    if args.benchmark_name == "tpcds":
        table_indices = tpcds_names
    elif args.benchmark_name == "tpch":
        table_indices = tpch_names
    else: 
        table_indices = ldbc_names
    
    bytes_to_gb = 1_000_000_000
    bytes_to_tb = 1_000_000_000_000
    if args.base_two:
        bytes_to_gb = math.pow(2,30)
        bytes_to_tb = math.pow(2,40)

    tsize_file = open("table_sizes.json")
    table_sizes_bytes = json.load(tsize_file)

    # sf1000
    duck_load_cost = 0
    if "parquet_1000" in args.path:
        total_dataset_size_parquet = 420.4
        duck_load_time = 1074.556
        duck_load_cost = (duck_load_time / 3600) * args.duck_cost
    elif "parquet_2000":
        total_dataset_size_parquet = 688.0
        duck_load_time = 1847.364
        duck_load_cost = (duck_load_time / 3600) * args.duck_cost

    # this MUST be the file size being moved in parquet--this is used to calc
    # egress cost
    table_size_gb = {}
    for t in table_sizes_bytes:
        table_size_gb[t] = table_sizes_bytes[t] / bytes_to_gb

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

    baselineManager = BaselineManager(args.egress, bytes_to_gb,
            bytes_to_tb, use_duck=args.duck, table_indices=table_indices,
            table_size_gb=table_size_gb, bq_cost=args.bq_cost,
            duck_cost=args.duck_cost, rs_cost = cluster_rs_cost,
            duck_load_cost=duck_load_cost)

    find_best_subset(baselineManager, query_bit_vecs, len(table_indices),
            args.egress, use_duck=args.duck, exclude_type=exclude_type,
            exclude=exclude)


