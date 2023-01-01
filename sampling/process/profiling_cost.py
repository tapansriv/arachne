import json
import math
from argparse import ArgumentParser
import sys
import os
from table_names import *

class BaselineManager:
    def __init__(self, sample_ratio, cluster_size,
            use_duck=False, table_indices=None, table_size_gb=None,
            bq_cost=6.25, duck_cost=1.48, rs_cost=1.086, duck_load_cost=0.0,
                 no_calcite: bool = False):

        home = os.path.expanduser("~")
        self.use_duck = use_duck
        self.no_calcite = no_calcite
        self.table_indices = table_indices
        self.table_size_gb = table_size_gb
        self.egress_cost = 0.12
        self.bytes_to_gb = math.pow(2,30)
        self.bytes_to_tb = math.pow(2,40)

        self.transfer_thruput = 0.4 # GBps
        self.put_price = 0.05 / 10000 # $/request
        self.get_price = 0.004 / 10000 # $/request 
         
        self.bq_cost = bq_cost
        self.duck_cost = duck_cost
        self.rs_cost = rs_cost

        self.sr = sample_ratio
        self.cs = cluster_size

        if self.use_duck:
            self.duck = json.load(open(f"duck_baseline.json"))
            self.duck_c = json.load(open(f"duck_c_baseline.json"))
            self.duck_load_cost = duck_load_cost
            num_duck_qs = len(self.duck.keys() | self.duck_c.keys())
            self.duck_load_cost_amortized = self.duck_load_cost / num_duck_qs

        self.rs = json.load(open(f"rs_baseline_{self.sr}.json"))

        self.rs_c = None
        if no_calcite:
            self.rs_c = {}
        else:
            self.rs_c = json.load(open(f"rs_c_baseline_{self.sr}.json"))
        self.bq = json.load(open(f"bigquery_{self.sr}.json"))

        # load times for Redshift (seconds)
        self.rs_load_times = json.load(open(f"rs{self.cs}_load_times_1tb_{self.sr}.json"))

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

    def get_profiling_stats(self, n, exclude_type=None, exclude=None, query_bit_vecs=None):
        # get total initial query set, add up times, add up costs, add in
        # movement costs, add in movement times. 
        keys = self.get_key_set_final(exclude_type=exclude_type, exclude=exclude,
                query_bit_vecs=query_bit_vecs)
        print(len(keys))

        table_set = [i for i in range(n)]
        if exclude_type == 't':
            i = self.table_indices.index(exclude)
            table_set.remove(i)

        total_cost = 0
        total_runtime = 0
        storage_runtime = 0
        for k in keys:
            if k in self.rs:
                rsr = self.rs[k]
                crs = (rsr / 3600) * self.rs_cost
                storage_runtime += rsr
                total_runtime += rsr
                total_cost += crs
            if k in self.rs_c:
                rsr = self.rs_c[k]
                crs = (rsr / 3600) * self.rs_cost
                storage_runtime += rsr
                total_runtime += rsr
                total_cost += crs

            # require that query be in BQ. May be in either rs/rs_c
            s = self.bq[k]["bytes"] / self.bytes_to_tb
            cs = s * self.bq_cost
            total_runtime += self.bq[k]["time"]
            total_cost += cs

        # add movement costs
        mvmt_cost = self.movement_cost(table_set)
        # mvmt_runtime = self.rs_load_times["transfer"]
        mvmt_runtime = self.get_size_of_table_set(table_set) / self.transfer_thruput
        mvmt_runtime_vm_cost = 1.38 * (mvmt_runtime/3600)
        mvmt_cost += mvmt_runtime_vm_cost
        total_runtime += mvmt_runtime
        total_cost += mvmt_cost

        # add load time costs
        for t in table_set:
            tname = self.table_indices[t]
            api_cost = self.api_call_cost(t)
            total_cost += api_cost

            runtime, cost = self.get_load_time_and_cost(tname)
            storage_runtime += runtime
            total_runtime += runtime
            total_cost += cost

        storage_cost = 0 
        for tbl in table_set:
            tname = self.table_indices[tbl]
            tbl_size_gb = self.table_size_gb[tname]
            storage_cost += ((storage_runtime / 3600) / 730) * tbl_size_gb * 0.023
        
        total_cost += storage_cost
        return total_runtime, total_cost

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

if __name__ == '__main__':
    parser = ArgumentParser(description="Compute profiling costs for randomly sampled data")

    parser.add_argument("--duck", action="store_true", help="Use DuckDB in Analysis")
    parser.add_argument("--no_calcite", action="store_true", help="Don't use Calcite queries in profile costs ")
    parser.add_argument("--egress", type=float, default=0.12, help="Egress cost")
    parser.add_argument("--duck_cost", type=float, default=1.48, help="DuckDB Hourly Cost in dollars")
    parser.add_argument("--rs_cost", type=float, default=1.086, help="Redshift Hourly Cost in dollars")
    parser.add_argument("--bq_cost", type=float, default=6.25, help="BigQuery Per TB Cost in dollars")
    parser.add_argument("--exclude_table", type=str, default=None, help="Table to exclude (must be in list of tables based on benchmark_name)")
    parser.add_argument("--exclude_qry", type=str, default=None, help="Query num to exclude")
    parser.add_argument("--cluster_size", type=int, default=1, help="Number of Redshift nodes in cluster")
    parser.add_argument("sample_ratio", type=float, help="Sample size being evaluated")
    parser.add_argument("path", help="Path with data for analysis")
    args = parser.parse_args()

    cluster_rs_cost = args.rs_cost * args.cluster_size
    print(f"Egress: ${args.egress}/GB")
    print(f"Data Path: {args.path}; Sample Ratio: {args.sample_ratio}")
    print(f"BigQuery Cost: ${args.bq_cost}/TB; DuckDB Cost: ${args.duck_cost}/hr; Redshift Cost: ${cluster_rs_cost}/hr")
    print(f"Use Duck: {args.duck}")
    print(f"Excluded Table: {args.exclude_table}")
    print(f"Excluded Query: {args.exclude_qry}")
    print("")

    # sf1000
    duck_load_cost = 0
    # duck_load_time = 1074.556
    # duck_load_cost = (duck_load_time / 3600) * args.duck_cost

    fp = open("query_bit_vec.json")
    x = json.load(fp)
    query_bit_vecs = {k: v for k, v in sorted(x.items(), key = lambda item: item[1])}

    os.chdir("../" + args.path)
    table_indices = None
    table_indices = tpcds_names

    tsize_file = open(f"table_sizes_{args.sample_ratio}.json")
    table_sizes_bytes = json.load(tsize_file)

    # this MUST be the file size being moved in parquet--this is used to calc
    # egress cost
    bytes_to_gb = math.pow(2,30)
    bytes_to_tb = math.pow(2,40)
    table_size_gb = {}
    for t in table_sizes_bytes:
        table_size_gb[t] = table_sizes_bytes[t] / bytes_to_gb


    exclude_type = None
    exclude = None
    if args.exclude_table and args.exclude_qry:
        raise Exception(f"Invalid: cannot exclude query and table in the same run; may only specify either exclude_qry or exclude_table, not both")

    if args.exclude_table is not None:
        if args.exclude_table not in table_indices:
            raise Exception(f"Table {args.exclude_table} not in list of table names for benchmark tpcds")
        exclude_type = 't'
        exclude = args.exclude_table
    if args.exclude_qry is not None:
        if args.exclude_qry not in query_bit_vecs:
            raise Exception(f"Query {args.exclude_qry} not in list of queries with bit vecs")
        exclude_type = 'q'
        exclude = args.exclude_qry

    baselineManager = BaselineManager(args.sample_ratio, args.cluster_size,
            use_duck=args.duck, table_indices=table_indices,
            table_size_gb=table_size_gb, bq_cost=args.bq_cost,
            duck_cost=args.duck_cost, rs_cost = cluster_rs_cost,
            duck_load_cost=duck_load_cost, no_calcite = args.no_calcite)

    n = len(table_indices)
    profiling_runtime, profiling_cost = baselineManager.get_profiling_stats(n,
            exclude_type=exclude_type, exclude=exclude, query_bit_vecs=query_bit_vecs)
    data = {}
    data["profiling_runtime"] = profiling_runtime
    data["profiling_cost"] = profiling_cost

    total = None
    add = f"0.12_{baselineManager.rs_cost}_{baselineManager.bq_cost}"
    fname = f"outputs_noduck_{add}.json"
    if baselineManager.use_duck:
        add = f"0.12_{baselineManager.rs_cost}_{baselineManager.bq_cost}_{baselineManager.duck_cost}"
        fname = f"outputs_duck_{add}.json"

    if baselineManager.no_calcite:
        if baselineManager.use_duck:
            add = f"0.12_{baselineManager.rs_cost}_{baselineManager.bq_cost}_{baselineManager.duck_cost}"
            fname = f"outputs_NOCALCITE_duck_{add}.json"
        else: 
            add = f"0.12_{baselineManager.rs_cost}_{baselineManager.bq_cost}"
            fname = f"outputs_NOCALCITE_noduck_{add}.json"




    try:
        with open(fname, "r") as fp:
            total = json.load(fp)
    except Exception as e:
        total = {}
    total[exclude] = data
    with open(fname, "w") as fp:
        json.dump(total, fp, indent=4, sort_keys=True)

    # print(f"{profiling_runtime}s, ${profiling_cost}")
