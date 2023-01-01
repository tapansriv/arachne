import json
import math
import sys
import os

table_indices = ["call_center", "catalog_page", "catalog_returns",
        "catalog_sales", "customer", "customer_address",
        "customer_demographics", "date_dim", "household_demographics",
        "income_band", "inventory", "item", "promotion", "reason", "ship_mode",
        "store", "store_returns", "store_sales", "time_dim", "warehouse",
        "web_page", "web_returns", "web_sales", "web_site"]

card = json.load(open("tpcds_card.json"))
rs = json.load(open("tpcds_row_sizes.json"))
table_sizes_bytes = {}

for tbl in table_indices:
    table_sizes_bytes[tbl] = rs[tbl] * card[tbl]

table_size_gb = {}
for t in table_sizes_bytes:
    table_size_gb[t] = table_sizes_bytes[t] / math.pow(2,30)



egress_cost = 0.12

class BaselineManager:
    def __init__(self, egress_cost, use_duck=False):
        home = os.path.expanduser("~")
        # self.use_duck = use_duck
        self.use_duck = False
        # self.duck = json.load(open(f"{home}/arachneDB/baseline/duck_baseline.json"))
        # self.duck_c = json.load(open(f"{home}/arachneDB/baseline/duck_c_baseline.json"))

        # self.rs = json.load(open(f"duckdb_baseline_2000.json"))
        self.rs = json.load(open(f"duckdb_baseline.json"))
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
        s = self.bq[k]["bytes"] / math.pow(2,40)
        cs = s * 5

        if self.use_duck:
            duck_cost = self.get_duck_cost(k)
            return min(cs, duck_cost)
        else:
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

            s = self.bq[k]["bytes"] / math.pow(2,40)
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
            s = self.bq[k]["bytes"] / math.pow(2,40)
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

def get_covered_queries(query_bit_vecs, subset, baselineManager):
    covered = []
    uncovered = []
    keys = baselineManager.get_union_keys()
    for k in keys:
        vec = query_bit_vecs[k]
        res = vec & subset
        if res == vec:
            covered.append(k)
        else:
            uncovered.append(k)

    return covered, uncovered

def movement_cost(subset, mvmt_cost):
    # print(bin(subset))
    size = 0
    for i in range(24):
        v = (subset >> i) & 0x1
        if v == 1:
            tbl_name = table_indices[i]
            size_gb = table_size_gb[tbl_name]
            # print(f"{tbl_name}, {size_gb}")
            size += size_gb
    return size * mvmt_cost

def evaluate_subset(query_bit_vecs, subset, baselineManager):
    covered_qs, uncovered_qs = get_covered_queries(query_bit_vecs, subset, baselineManager)
    mvmt_cost = movement_cost(subset, baselineManager.egress_cost) # cost in $; $0.12/GB egress from GCP

    covered_costs = 0
    uncovered_costs = 0
    for q in covered_qs:
        covered_costs += baselineManager.get_rs_cost(q)

    for q in uncovered_qs:
        uncovered_costs += baselineManager.get_gcp_cost(q)
    
    return (covered_costs + uncovered_costs + mvmt_cost) # all dollars

def find_best_subset(query_bit_vecs, n, egress_cost, use_duck=False):
    if use_duck:
        print("Starting analysis using DuckDB")
    else:
        print("Starting analysis without using DuckDB")

    baselineManager = BaselineManager(egress_cost, use_duck)
    max_val = (1 << n)
    print(max_val)

    tot = baselineManager.get_totals_on_union_set()
    print(len(baselineManager.get_union_keys()))
    min_cost = 0
    min_subset = None

    second_min_cost = 0
    second_min_subset = None

    third_min_cost = 0
    third_min_subset = None

    counter = 0
    for i in range(max_val):
        cost = evaluate_subset(query_bit_vecs, i, baselineManager)
        if cost < tot:
            counter += 1
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

    print(min_subset)
    print(f"Cost of new plan by subset ({min_subset}, {bin(min_subset)}): ${min_cost}")
    print(f"found {counter} plans cheaper than baseline")

    print(f"Cost of Second Cheapest plan by subset ({second_min_subset}, {bin(second_min_subset)}): ${second_min_cost}")
    print(f"Cost of Third Cheapest plan by subset ({third_min_subset}, {bin(third_min_subset)}): ${third_min_cost}")

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
    find_best_subset(query_bit_vecs, 24, egress_cost, use_duck=use_duck)


