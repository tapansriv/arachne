# impl steps:
# 1. build graph with edge capacities
# 2. implement min-cut
# 3. print results etc.
import json
import math
from argparse import ArgumentParser
import sys
import os
from typing import List, Dict
from table_names import *


class BaselineManager:
    def __init__(self, egress_cost, bytes_to_gb, bytes_to_tb, use_duck=False,
                 no_calcite=False, table_indices=None, table_size_gb=None,
                 bq_cost=6.25, duck_cost=1.48, rs_cost=1.086, duck_load_cost=0.0):
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
        num_duck_qs = len(self.duck.keys() | self.duck_c.keys())
        self.duck_load_cost_amortized = self.duck_load_cost / num_duck_qs

        self.rs = json.load(open(f"rs_baseline.json"))
        self.rs_c = None
        self.no_calcite = no_calcite
        if no_calcite: 
            self.rs_c = {}
        else:
            self.rs_c = json.load(open(f"rs_c_baseline.json"))
        # self.rs_c = json.load(open(f"rs_c_baseline.json"))
        self.bq = json.load(open(f"bigquery_baseline.json"))

        # load times for Redshift (seconds)
        self.rs_load_times = json.load(open(f"rs_load_times.json"))

        # remove keys for which we have biquery data but the query failed to run
        remove = [k for k in self.bq if self.bq[k]['bytes'] is None]
        for k in remove: del self.bq[k]

    def api_call_cost(self, table):
        chunk_size_gb = 64 / 1024 # 64mb per chunk
        tbl_name = self.table_indices[table]
        size_gb = self.table_size_gb[tbl_name]
        num_chunks = min(size_gb / chunk_size_gb, 9990)
        get_cost = num_chunks * self.get_price # do num_chunks gets
        # do same num of uploads, plus one compete_multipart_upload request
        # (classified as a post), plus 1 COPY request per table per table
        put_cost = (num_chunks + 1 + 1) * self.put_price 
        return get_cost + put_cost

    def get_load_time_and_cost(self, tname):
        if tname not in self.rs_load_times:
            raise Exception(f"no load time for table name: {tname}")

        t = self.rs_load_times[tname]
        cost = (t/3600) * self.rs_cost
        return t, cost

    def get_key_set_final(self, exclude_type=None, exclude=None, query_bit_vecs=None):
        keys = (self.rs.keys() | self.rs_c.keys()) 
        if self.use_duck:
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

    def get_rs_runtime(self, k):
        vals = []
        if k in self.rs:
            rsr1 = self.rs[k]
            vals.append(rsr1)
        if k in self.rs_c:
            rsr2 = self.rs_c[k]
            vals.append(rsr2)
        return min(vals)

    def get_gcp_runtime(self, k):
        if self.use_duck:
            duck_cost = -1
            bq_cost = -1
            if k in self.duck or k in self.duck_c:
                duck_cost = self.get_duck_cost(k)
            if k in self.bq:
                s = self.bq[k]["bytes"] / self.bytes_to_tb
                cs = s * self.bq_cost

            if duck_cost < bq_cost: 
                return self.get_duck_runtime(k)
            elif duck_cost > bq_cost:
                return self.bq[k]["time"]
            else: 
                return min(self.get_duck_runtime(k), self.bq[k]["time"])
        else:
            s = self.bq[k]["bytes"] / self.bytes_to_tb
            cs = s * self.bq_cost
            return self.bq[k]["time"]

    def get_duck_runtime(self, k):
        vals = []
        if k in self.duck:
            dr1 = self.duck[k]
            vals.append(dr1)
        if k in self.duck_c:
            dr1 = self.duck_c[k]
            vals.append(dr1)
        return min(vals)

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
        min_value += self.duck_load_cost_amortized
        return min_value

    def gcp_bq_cheaper(self, k):
        if self.use_duck:
            vals = []
            duck_cost = self.get_duck_cost(k)
            s = self.bq[k]["bytes"] / self.bytes_to_tb
            cs = s * self.bq_cost
            return (cs < duck_cost)
        return True

    def get_gcp_cost(self, k):
        if self.use_duck:
            vals = []
            if k in self.duck or k in self.duck_c:
                duck_cost = self.get_duck_cost(k)
                vals.append(duck_cost)
            if k in self.bq:
                s = self.bq[k]["bytes"] / self.bytes_to_tb
                cs = s * self.bq_cost
                vals.append(cs)
            return min(vals)
        else:
            s = self.bq[k]["bytes"] / self.bytes_to_tb
            cs = s * self.bq_cost
            return cs

    def get_size_of_table_set(self, tables):
        # print(bin(subset))
        size = 0
        for i in tables:
            tbl_name = table_indices[i]
            size_gb = self.table_size_gb[tbl_name]
            # print(f"{tbl_name}, {size_gb}")
            size += size_gb
        return size

    def movement_cost(self, tables):
        # print(bin(subset))
        size = 0
        for i in tables:
            tbl_name = table_indices[i]
            size_gb = self.table_size_gb[tbl_name]
            # print(f"{tbl_name}, {size_gb}")
            size += size_gb
        return size * self.egress_cost

    def compute_table_cost(self, t, queries, tables):
        storage_runtime = 0
        for q in queries:
            storage_runtime += baselineManager.get_rs_runtime(q)
        for tbl in tables:
            tname = baselineManager.table_indices[int(tbl)]
            tbl_size_gb = baselineManager.table_size_gb[tname]
            load_time, _ = baselineManager.get_load_time_and_cost(tname)
            storage_runtime += load_time
        # print(f"storage_runtime: {storage_runtime}")
        # storage_runtime = 7402.34575009346

        tname = self.table_indices[int(t)]
        tbl_size_gb = self.table_size_gb[tname]
        load_time, load_cost = self.get_load_time_and_cost(tname)
        # ~730 hours/month, 3600 sec/hour, $0.023/GB/month
        storage_cost = ((storage_runtime / 3600) / 730) * tbl_size_gb * 0.023 
        api_cost = self.api_call_cost(int(t))
        mvmt_runtime = tbl_size_gb / self.transfer_thruput
        mvmt_vm_cost = 1.38 * (mvmt_runtime / 3600)
        cost = (tbl_size_gb * self.egress_cost) + load_cost + storage_cost + api_cost + mvmt_vm_cost
        # print(f"{tname}: {load_cost}, {storage_cost}, {api_cost}, {tbl_size_gb * self.egress_cost}")
        # print(f"{tname}: {cost}")
        return cost

    def compute_query_savings(self, q):
        savings = self.get_gcp_cost(q) - self.get_rs_cost(q)
        return savings

def prune_queries(queries, tables):
    to_remove = []
    for q in queries:
        v = queries[q]
        for tbl in tables:
            t = (v >> tbl) & 0x1
            if t == 1:
                to_remove.append(q)
                break
    
    ret = {}
    for q in queries:
        if q in to_remove:
            continue
        ret[q] = queries[q]

    return ret


class Graph:
    def __init__(self, bm: BaselineManager, table_ids: List[str], 
            query_ids: List[str], query_deps: Dict[str, int]):
        # table_ids = ['0', '1', ..., '20', '22'...]
        # query_ids = ['01', '02'...]
        self.bm = bm
        self.source_id = 'source'
        self.sink_id = 'sink'
        # prefix by "00" so int-convertible & distinguishable from qs
        self.table_ids = ["00" + t for t in table_ids] 
        self.query_ids = sorted(query_ids)
        # print(self.query_ids)
        # print(self.table_ids)
        self.query_deps = query_deps
        self.vertices = [self.source_id] + [self.sink_id] + self.table_ids + self.query_ids
        self.edges = {k : {} for k in self.vertices}
        self.baseline_savings = 0

    def create_bit_string_from_list(self, table_set):
        res = 0
        for i in table_set:
            v = 1 << i
            res = res | v
        return res

    def build_graph(self):
        for t in self.table_ids:
            cost = self.bm.compute_table_cost(t, self.query_ids, self.table_ids)
            self.edges[self.source_id][t] = cost
            self.edges[t][self.source_id] = 0 # reverse edge

        for q in self.query_ids:
            cost = self.bm.compute_query_savings(q)
            self.baseline_savings += cost
            self.edges[q][self.sink_id] = cost
            self.edges[self.sink_id][q] = 0 # reverse edge

        # build table -> query edges 
        for k in self.query_deps:
            val = self.query_deps[k]
            for tid in self.table_ids:
                tbl = int(tid)
                t = (val >> tbl) & 0x1
                if t == 1:
                    self.edges[tid][k] = float("Inf") # infinity
                    self.edges[k][tid] = 0 # reverse edge
                elif t == 0:
                    self.edges[tid][k] = 0
                    self.edges[k][tid] = 0 # reverse edge
                else:
                    print("WEIRD AF LOL") # what are you doing fool
        # print(self.edges)

    def dfs(self, s, visited):
        visited[s] = True
        neighbors = self.edges[s]
        for k in neighbors:
            if neighbors[k] > 0 and not visited[k]:
                self.dfs(k, visited)

    def bfs(self):
        visited = {k: False for k in self.vertices}
        parent = {}
        queue = []
        s = self.source_id
        queue.append(s)
        visited[s] = True

        while queue:
            u = queue.pop(0)
            # neighbors = dict(sorted(self.edges[u].items()))
            neighbors = self.edges[u]
            for k in neighbors:
                if not visited[k] and neighbors[k] > 0:
                    queue.append(k)
                    visited[k] = True
                    parent[k] = u

        found = visited[self.sink_id]
        return found, parent

    def check_cut(self, subset):
        # get tables \in T
        # get queries \in T, get queries \in S
        # sum of query savings + sum of table costs is cut capacity
        tables = []
        removed = []
        for i in range(24):
            v = (subset >> i) & 0x1
            if v == 1:
                tables.append(i)
            else: 
                removed.append(i)

        moved_queries = prune_queries(self.query_deps, removed) 
        kept_query_keys = [k for k in self.query_deps if k not in moved_queries]

        tot = 0
        for tbl in tables:
            cost = self.bm.compute_table_cost(tbl, self.query_ids, self.table_ids)
            tot += cost

        for q in kept_query_keys:
            cost = self.bm.compute_query_savings(q)
            tot += cost
        print(tot)

    def inter_query(self, exclude=None, keys=None):
        self.build_graph()
        max_flow = 0
        found, parent = self.bfs()
        while found:
            path_flow = float("Inf")
            s = self.sink_id
            while (s != self.source_id):
                edge_flow = self.edges[parent[s]][s]
                # print(f"{parent[s]}, {s}, {edge_flow}")
                path_flow = min(path_flow, edge_flow)
                s = parent[s]
            max_flow += path_flow

            v = self.sink_id
            while (v != self.source_id):
                u = parent[v]
                self.edges[u][v] -= path_flow
                self.edges[v][u] += path_flow
                v = parent[v]
            found, parent = self.bfs()

        print(max_flow)
        print(self.baseline_savings)
        print(self.baseline_savings - max_flow)
        visited = {k: False for k in self.vertices}
        self.dfs(self.source_id, visited)

        reachable_table_ids = []
        reachable_query_ids = []
        for k in visited:
            if not visited[k]:
                continue
            if k.startswith("00"):
                reachable_table_ids.append(k)
            else:
                reachable_query_ids.append(k)
        print(reachable_table_ids)
        print(reachable_query_ids)
            
        final_table_ids = [int(k) for k in self.table_ids if k not in reachable_table_ids]
        final_table_names = [self.bm.table_indices[k] for k in final_table_ids]
        print(final_table_names)
        final_query_ids = [k for k in self.query_ids if k not in reachable_query_ids]

        cost, runtime = self.compute_plan_stats(final_query_ids, final_table_ids, keys)
        min_subset = self.create_bit_string_from_list(final_table_ids)

        # outputs_NOCALCITE_noduck_GCP_0.12_1.086_7.75.json
        bm = self.bm
        fname = "optimal_"
        if bm.no_calcite:
            fname += "NOCALCITE_"
        if bm.use_duck:
            add = f"{bm.egress_cost}_{bm.rs_cost}_{bm.bq_cost}_{bm.duck_cost}"
            fname += f"duck_GCP_{add}.json"
        else:
            add = f"{bm.egress_cost}_{bm.rs_cost}_{bm.bq_cost}"
            fname += f"noduck_GCP_{add}.json"

        data = {'moved_tables': final_table_names,
                'optimal_cost': cost, 
                'optimal_runtime': runtime
               }

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


        print(f"Optimal Subset: {bin(min_subset)}")
        self.check_cut(min_subset)

    def compute_plan_stats(self, query_set, tables, keys):
        bm = self.bm
        total_runtime_move = 0
        total_runtime_stay = 0

        mvmt_cost = bm.movement_cost(tables)
        # size in GB times GBps
        mvmt_runtime = bm.get_size_of_table_set(tables) / bm.transfer_thruput 
        mvmt_runtime_vm_cost = 1.38 * (mvmt_runtime / 3600)
        mvmt_cost += mvmt_runtime_vm_cost

        total_runtime_move += mvmt_runtime

        covered_costs = 0
        uncovered_costs = 0
        rs_total_load_cost = 0

        storage_runtime = 0
        # queries to move are either in passed in or final query set
        for q in keys:
            if q in query_set:
                covered_costs += bm.get_rs_cost(q)
                total_runtime_move += bm.get_rs_runtime(q)
                storage_runtime += bm.get_rs_runtime(q) 
            else:
                uncovered_costs += bm.get_gcp_cost(q)
                total_runtime_stay += bm.get_gcp_runtime(q)
        
        # load time, cost
        extra_storage_size_gb = 0
        tbl_names = [bm.table_indices[i] for i in tables]
        for tname in tbl_names:
            load_time, load_cost = bm.get_load_time_and_cost(tname)
            storage_runtime += load_time
            rs_total_load_cost += load_cost
            size_gb = bm.table_size_gb[tname]
            extra_storage_size_gb += size_gb

            total_runtime_move += load_time

        # api cost
        api_cost = 0
        for tbl in tables:
            api_cost += bm.api_call_cost(tbl)

        storage_cost = ((storage_runtime / 3600) / 730) * extra_storage_size_gb * 0.023
        # all costs in USD
        final_cost = (covered_costs + uncovered_costs + mvmt_cost + \
                      rs_total_load_cost + storage_cost + api_cost) 
        final_runtime = max(total_runtime_move, total_runtime_stay)
        print(f"Costs: {final_cost}, {covered_costs}, {uncovered_costs}, {mvmt_cost}, {rs_total_load_cost}, {storage_cost}, {api_cost}")
        print(f"Runtime: {final_runtime}")
        return final_cost, final_runtime

def compute_savings(baselineManager, queries):
    vals = {}
    for q in queries:
        savings = baselineManager.get_gcp_cost(q) - baselineManager.get_rs_cost(q)
        vals[q] = savings
    return vals

def find_best_subset(baselineManager, query_bit_vecs, n, egress_cost,
        use_duck=False, exclude_type=None, exclude=None):
    if use_duck:
        print("Starting analysis using DuckDB")
    else:
        print("Starting analysis without using DuckDB")

    num_keys_init = len(baselineManager.get_key_set_final(exclude_type=exclude_type,
        exclude=exclude, query_bit_vecs=query_bit_vecs))

    # filters down keys to only those without excluded table dependencies or
    # without excluded query
    keys = baselineManager.get_key_set_final(exclude_type=exclude_type,
            exclude=exclude, query_bit_vecs=query_bit_vecs)
    query_savings = compute_savings(baselineManager, keys)

    curr_query_set = {k: query_bit_vecs[k] for k in keys if query_savings[k] > 0}
    curr_table_set = [i for i in range(n)]

    if exclude_type == "q":
        # this case was handled by get_key_set_final taking exclusion params
        # just here for debugging prints
        print(f"Excluding query {exclude}")
    elif exclude_type == "t":
        # queries were pruned by get_key_set final; this is removing table and
        # debugging prints
        print(f"Excluding table {exclude} and any queries that depend on it")
        i = baselineManager.table_indices.index(exclude)
        curr_table_set.remove(i) # remove table from consideration
    
    query_ids = [k for k in curr_query_set]
    query_deps = curr_query_set
    table_ids = [str(k) for k in curr_table_set]
    print(len(query_ids))
    print(len(table_ids))
    
    num_keys_start = len(curr_query_set)
    num_tables_start = len(curr_table_set)
    print(f"Total Keys: {num_keys_init}, Keys Considered: {num_keys_start}")

    graph = Graph(baselineManager, table_ids=table_ids, query_ids=query_ids,
            query_deps=query_deps) 
    graph.inter_query(exclude=exclude, keys=keys)


if __name__ == '__main__':
    parser = ArgumentParser(description="Run inter-query analysis")

    parser.add_argument("--no_calcite", action="store_true", help="Don't use calcite profiles")
    parser.add_argument("--duck", action="store_true", help="Use DuckDB in Analysis")
    parser.add_argument("--egress", type=float, default=0.12, help="Egress cost")
    parser.add_argument("--duck_cost", type=float, default=1.48, help="DuckDB Hourly Cost in dollars")
    parser.add_argument("--rs_cost", type=float, default=1.086, help="Redshift Hourly Cost in dollars")
    parser.add_argument("--bq_cost", type=float, default=6.25, help="BigQuery Per TB Cost in dollars")
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
    print(f"Using calcite profiles: {not args.no_calcite}")
    print(f"Excluded Table: {args.exclude_table}")
    print(f"Excluded Query: {args.exclude_qry}")
    print("")

    # duckdb load costs
    duck_load_cost = 0
    if "parquet_1000" in args.path:
        total_dataset_size_parquet = 420.4
        duck_load_time = 1074.556
        duck_load_cost = (duck_load_time / 3600) * args.duck_cost
    elif "parquet_2000":
        total_dataset_size_parquet = 688.0
        duck_load_time = 1847.364
        duck_load_cost = (duck_load_time / 3600) * args.duck_cost

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
    
    bytes_to_gb = math.pow(2,30)
    bytes_to_tb = math.pow(2,40)

    tsize_file = open("table_sizes.json")
    table_sizes_bytes = json.load(tsize_file)

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
            duck_load_cost=duck_load_cost, no_calcite = args.no_calcite)

    find_best_subset(baselineManager, query_bit_vecs, len(table_indices),
            args.egress, use_duck=args.duck, exclude_type=exclude_type,
            exclude=exclude)


