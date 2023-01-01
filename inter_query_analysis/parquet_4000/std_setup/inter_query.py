import json
import sys
import os

table_indices = ["call_center", "catalog_page", "catalog_returns",
        "catalog_sales", "customer", "customer_address",
        "customer_demographics", "date_dim", "household_demographics",
        "income_band", "inventory", "item", "promotion", "reason", "ship_mode",
        "store", "store_returns", "store_sales", "time_dim", "warehouse",
        "web_page", "web_returns", "web_sales", "web_site"]

# tsize_file = open("table_sizes.json")
# table_sizes_bytes = json.load(tsize_file)
card = json.load(open("tpcds_card.json"))
rs = json.load(open("tpcds_row_sizes.json"))
table_sizes_bytes = {}

for tbl in table_indices:
    table_sizes_bytes[tbl] = rs[tbl] * card[tbl]

table_size_gb = {}
for t in table_sizes_bytes:
    table_size_gb[t] = table_sizes_bytes[t] / 1_000_000_000


egress_cost = 0.12

class BaselineManager:
    def __init__(self, egress_cost, use_duck=False):
        home = os.path.expanduser("~")
        # self.use_duck = use_duck
        self.use_duck = False
        # self.duck = json.load(open(f"{home}/arachneDB/baseline/duck_baseline.json"))
        # self.duck_c = json.load(open(f"{home}/arachneDB/baseline/duck_c_baseline.json"))

        # self.rs = json.load(open(f"duckdb_baseline_2000.json"))
        self.rs = json.load(open(f"duck_baseline_4000.json"))
        self.rs_c = json.load(open(f"duckdb_c_baseline.json"))
        self.bq = json.load(open(f"bigquery_baseline.json"))
        self.egress_cost = egress_cost

    def get_common_keys(self):
        keys = self.rs.keys() & self.rs_c.keys() & self.bq.keys()
        if self.use_duck:
            keys = keys & self.duck.keys() & self.duck_c.keys()
        return keys

    def get_union_keys(self):
        keys = (self.rs.keys() | self.rs_c.keys()) & self.bq.keys()
        if self.use_duck:
            keys = keys & (self.duck.keys() | self.duck_c.keys())
        return keys


    def get_key_set_final(self):
        keys = (self.rs.keys() | self.rs_c.keys()) 
        if self.use_duck:
            # keys = keys & (self.bq.keys() | self.duck.keys() | self.duck_c.keys())
            keys = keys & self.bq.keys()
            keys = keys & (self.duck.keys() | self.duck_c.keys())
        else:
            keys = keys & self.bq.keys()
        return keys

    def get_rs_cost(self, k):
        min_value = -1
        if k in self.rs:
            rsr1 = self.rs[k]
            crs1 = (rsr1 / 3600) * 1.086
            min_value = crs1
        if k in self.rs_c:
            rsr2 = self.rs_c[k]
            crs2 = (rsr2 / 3600) * 1.086
            if min_value == -1 or crs2 < min_value:
                min_value = crs2
        return min_value

    def get_duck_cost(self, k):
        min_value = -1
        if k == "67":
            return 1.8621060588
        if k in self.duck:
            dr1 = self.duck[k]
            cd1 = (dr1 / 3600) * 1.48
            min_value = cd1
        if k in self.duck_c:
            dr2 = self.duck_c[k]
            cd2 = (dr2 / 3600) * 1.48
            if min_value == -1 or cd2 < min_value:
                min_value = cd2
        return min_value

    def get_gcp_cost(self, k):
        if self.use_duck:
            vals = []
            if k in self.duck or k in self.duck_c:
                duck_cost = self.get_duck_cost(k)
                vals.append(duck_cost)
            if k in self.bq:
                s = self.bq[k]["bytes"] / 1_000_000_000_000
                cs = s * 5
                vals.append(cs)
            return min(vals)
        else:
            s = self.bq[k]["bytes"] / 1_000_000_000_000
            cs = s * 5
            return cs

    def get_total_common_set(self):
        keys = self.get_key_set_final()
        print(len(keys))
        rs_total = 0
        rs_c_total = 0
        duck_total = 0
        duck_c_total = 0
        bq_total = 0
        for k in keys:
            rsr1 = self.rs[k]
            # rsr2 = self.rs_c[k]
            crs1 = (rsr1 / 3600) * 1.086
            # crs2 = (rsr2 / 3600) * 1.086

            s = self.bq[k]["bytes"] / 1_000_000_000_000
            cs = s * 5
            if self.use_duck:
                dr1 = self.duck[k]
                dr2 = self.duck_c[k]
                cd1 = (dr1 / 3600) * 1.48
                cd2 = (dr2 / 3600) * 1.48
                duck_total += cd1
                duck_c_total += cd2

            rs_total += crs1
            rs_c_total += 0 # crs2
            bq_total += cs

        if self.use_duck:
            print(f"Duck Total: ${duck_total}, Duck-Calcite Total: ${duck_c_total}, Redshift Total: ${rs_total}, Redshift-Calcite Total: ${rs_c_total}, BigQuery Total: ${bq_total}")
            return min(duck_total, duck_c_total, bq_total)
        else:
            print(f"Redshift Total: ${rs_total}, Redshift-Calcite Total: ${rs_c_total}, BigQuery Total: ${bq_total}")
            return bq_total

    '''
    This gets the "union keys", which means that the key is present in one of rs
    or rs calcite, or it ran in Redshift in some manner, perhaps both. If DuckDB
    is being used, the same logic applies. If a Calcite query ran, we use that
    cost, otherwise we use the original cost, and vice versa (although I believe
    there's one DuckDB query which only runs in calcite, so this is an edge case)

    get_total_common_set is the same logic but only on queries for which we have
    raw and calcite query runtimes across all systems. We use the union set to
    expand the set of queries considered to nearly all.
    '''
    def get_totals_on_union_set(self):
        keys = self.get_union_keys()
        rs_total = 0
        rs_c_total = 0
        rs_opt_total = 0
        duck_total = 0
        duck_c_total = 0
        duck_opt_total = 0
        bq_total = 0
        for k in keys:
            crs1 = None
            crs2 = None
            if k in self.rs:
                rsr1 = self.rs[k]
                crs1 = (rsr1 / 3600) * 1.086
            if k in self.rs_c:
                rsr2 = self.rs_c[k]
                crs2 = (rsr2 / 3600) * 1.086

            if k not in self.rs: # crs1 None, crs2 value
                crs1 = crs2
            if k not in self.rs_c: # crs2 None, crs1 value
                crs2 = crs1
            rs_cost = self.get_rs_cost(k)
            s = self.bq[k]["bytes"] / 1_000_000_000_000
            cs = s * 5
            if self.use_duck:
                cd1 = None
                cd2 = None
                if k in self.duck:
                    dr1 = self.duck[k]
                    cd1 = (dr1 / 3600) * 1.086
                if k in self.duck_c:
                    dr2 = self.duck_c[k]
                    cd2 = (dr2 / 3600) * 1.086
                if k not in self.duck: # cd1 None, cd2 value
                    cd1 = cd2
                if k not in self.duck_c: # cd2 None, cd1 value
                    cd2 = cd1
                duck_total += cd1
                duck_c_total += cd2
                duck_opt_total += min(cd1, cd2)

            rs_total += crs1
            rs_c_total += crs2
            rs_opt_total += rs_cost
            bq_total += cs

        if self.use_duck:
            print(f"Duck Total: ${duck_total}, Duck-Calcite Total: ${duck_c_total}, Redshift Total: ${rs_total}, Redshift-Calcite Total: ${rs_c_total}, BigQuery Total: ${bq_total}")
            print(f"Duck Opt Total: ${duck_opt_total}, Redshift Opt Total: ${rs_opt_total}")
            return min(duck_total, bq_total)
        else:
            print(f"Redshift Total: ${rs_total}, Redshift-Calcite Total: ${rs_c_total}, BigQuery Total: ${bq_total}")
            print(f"Redshift Opt Total: ${rs_opt_total}")
            return bq_total

def movement_cost(tables, mvmt_cost):
    # print(bin(subset))
    size = 0
    for i in tables:
        tbl_name = table_indices[i]
        size_gb = table_size_gb[tbl_name]
        # print(f"{tbl_name}, {size_gb}")
        size += size_gb
    return size * mvmt_cost

def compute_savings(baselineManager, queries):
    vals = {}
    for q in queries:
        savings = baselineManager.get_gcp_cost(q) - baselineManager.get_rs_cost(q)
        vals[q] = savings
    return vals

def assign_values(baselineManager, tables, queries, mvmt_cost):
    values = {t: 0 for t in [table_indices[i] for i in tables]}
    for q in queries:
        v = queries[q]
        for tbl in tables:
            t = (v >> tbl) & 0x1
            if t == 1:
                savings = baselineManager.get_gcp_cost(q) - baselineManager.get_rs_cost(q) # a priori made positive
                tbl_name = table_indices[tbl]
                if tbl_name == "store_sales":
                    print(f"{q}: ${savings}")
                values[table_indices[tbl]] += savings

    for tbl in tables:
        tname = table_indices[tbl]
        cost = table_size_gb[tname] * mvmt_cost
        values[tname] = values[tname] - cost
        print(f"{tname}: {values[tname]}, {cost}, {table_size_gb[tname]}")
    return values

'''
queries: set of queries we want to remove the failures frolm

tables: the set of tables we aren't going to include. remove any query that
touches one of these tables
'''
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



def find_best_subset(baselineManager, query_bit_vecs, n, egress_cost, use_duck=False):
    if use_duck:
        print("Starting analysis using DuckDB")
    else:
        print("Starting analysis without using DuckDB")

    keys = baselineManager.get_key_set_final()
    print(keys)
    query_savings = compute_savings(baselineManager, keys)

    # curr_query_set = [k for k in keys if query_savings[k] > 0]
    curr_query_set = {k: query_bit_vecs[k] for k in keys if query_savings[k] > 0}
    curr_table_set = [i for i in range(24)]
    print(len(curr_query_set))

    rnd = 0
    while len(curr_table_set) > 0:
        print("")
        print(f"Round {rnd}")
        values = assign_values(baselineManager, curr_table_set, curr_query_set, egress_cost)

        working_set = [k for k in values if values[k] > 0]
        to_remove = [k for k in values if values[k] <= 0]
        to_remove_tables = [table_indices.index(t) for t in to_remove]
        if len(to_remove) == 0:
            # return curr_table_set, curr_query_set
            break

        pruned_tables = [table_indices.index(t) for t in working_set]
        pruned_queries = prune_queries(curr_query_set, to_remove_tables)

        curr_table_set = pruned_tables
        curr_query_set = pruned_queries
        rnd += 1
    

    tbl_names = [table_indices[i] for i in curr_table_set]
    print(curr_table_set)
    print(len(curr_table_set))

    mvmt_cost = movement_cost(curr_table_set, baselineManager.egress_cost) # cost in $; $0.12/GB egress from GCP
    covered_costs = 0
    uncovered_costs = 0
    for q in keys:
        if q in curr_query_set:
            covered_costs += baselineManager.get_rs_cost(q)
        else:
            uncovered_costs += baselineManager.get_gcp_cost(q)
        
    final_cost = (covered_costs + uncovered_costs + mvmt_cost) # all dollars
    print(f"Final cost: ${final_cost}")
    baselineManager.get_total_common_set()
    return curr_table_set, curr_query_set


if __name__ == '__main__':
    if len(sys.argv) < 2:
        exit("not enough arguments")

    use_duck = False
    if sys.argv[1] == "duck":
        use_duck = True

    egress_cost = 0.12
    if len(sys.argv) > 2:
        egress_cost = float(sys.argv[2])

    print(f"Egress cost: ${egress_cost}")
    fp = open("query_bit_vec.json")
    x = json.load(fp)
    query_bit_vecs = {k: v for k, v in sorted(x.items(), key = lambda item: item[1])}
    baselineManager = BaselineManager(egress_cost, use_duck)

    curr_table_set, curr_query_set = find_best_subset(baselineManager, query_bit_vecs, 24, egress_cost, use_duck=use_duck)




