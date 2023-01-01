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
        num_duck_qs = len(self.duck.keys() | self.duck_c.keys())
        self.duck_load_cost_amortized = self.duck_load_cost / num_duck_qs

        self.rs = json.load(open(f"rs_baseline.json"))
        self.rs_c = json.load(open(f"rs_c_baseline.json"))
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

    def get_profiling_stats(self, n, exclude_type=None, exclude=None, query_bit_vecs=None):
        # get total initial query set, add up times, add up costs, add in
        # movement costs, add in movement times. 
        keys = self.get_key_set_final(exclude_type=exclude_type, exclude=exclude,
                query_bit_vecs=query_bit_vecs)

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
        mvmt_runtime = self.get_size_of_table_set(table_set) / self.transfer_thruput
        mvmt_runtime_vm_cost = 1.38 * (mvmt_runtime/3600)
        mvmt_cost += mvmt_runtime_vm_cost
        total_runtime += mvmt_runtime
        total_cost += mvmt_cost

        # add load time costs
        for t in table_set:
            tname = self.table_indices[t]
            api_cost = baselineManager.api_call_cost(t)
            total_cost += api_cost

            runtime, cost = self.get_load_time_and_cost(tname)
            storage_runtime += runtime
            total_runtime += runtime
            total_cost += cost

        storage_cost = 0 
        for tbl in table_set:
            tname = baselineManager.table_indices[tbl]
            tbl_size_gb = baselineManager.table_size_gb[tname]
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

    def get_baseline_totals(self, exclude_type=None, exclude=None, query_bit_vecs=None):
        keys = self.get_key_set_final(exclude_type=exclude_type, exclude=exclude, query_bit_vecs=query_bit_vecs)
        rs_total = 0
        rs_c_total = 0
        duck_total = 0
        duck_c_total = 0
        bq_total = 0
        bq_baseline_runtime = 0

        duck_total += 0.5 * self.duck_cost # load times
        duck_c_total += 0.5 * self.duck_cost # load times
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
            bq_baseline_runtime += self.bq[k]["time"]
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
            return bq_baseline_runtime, min(duck_total, duck_c_total, bq_total)
        else:
            print(f"Redshift Total: ${rs_total}, Redshift-Calcite Total: ${rs_c_total}, BigQuery Total: ${bq_total}")
            return bq_baseline_runtime, bq_total

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

def compute_savings(baselineManager, queries):
    vals = {}
    for q in queries:
        savings = baselineManager.get_gcp_cost(q) - baselineManager.get_rs_cost(q)
        vals[q] = savings
    return vals

def assign_values(baselineManager, tables, queries, egress_cost):
    values = {t: 0 for t in [baselineManager.table_indices[i] for i in tables]}
    num_dependencies  = {t: 0 for t in [baselineManager.table_indices[i] for i in tables]}
    storage_runtime = 0
    for q in queries:
        v = queries[q]
        for tbl in tables:
            t = (v >> tbl) & 0x1
            rstime = baselineManager.get_rs_runtime(q)
            storage_runtime += rstime
            if t == 1:
                savings = baselineManager.get_gcp_cost(q) - baselineManager.get_rs_cost(q) # a priori made positive
                values[baselineManager.table_indices[tbl]] += savings
                num_dependencies[baselineManager.table_indices[tbl]] += 1

    for tbl in tables:
        tname = baselineManager.table_indices[tbl]
        tbl_size_gb = baselineManager.table_size_gb[tname]
        # cost = tbl_size_gb * egress_cost 
        load_time, load_cost = baselineManager.get_load_time_and_cost(tname)
        storage_runtime += load_time
        storage_cost = ((storage_runtime / 3600) / 730) * tbl_size_gb * 0.023
        api_cost = baselineManager.api_call_cost(tbl)

        cost = tbl_size_gb * egress_cost + load_cost + storage_cost
        val = values[tname]
        values[tname] = values[tname] - cost
        print(f"{tname}: {tbl_size_gb}, {val}, {cost}, {values[tname]}")
        if tname == "store_returns":
            values[tname] = 0.1
        if num_dependencies[tname] == 0:
            print(f"{tname} had no query dependencies")
    return values, num_dependencies

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

def compute_cost_of_plan(baselineManager, curr_query_set, curr_table_set, keys):
    # print("----- FUNCTION-----")
    # print(len(keys))
    # print(curr_query_set.keys())
    mvmt_cost = baselineManager.movement_cost(curr_table_set) # cost in $; $0.12/GB egress from GCP
    mvmt_runtime = baselineManager.get_size_of_table_set(curr_table_set) / baselineManager.transfer_thruput # size in GB times GBps
    mvmt_runtime_vm_cost = 1.38 * (mvmt_runtime / 3600)
    mvmt_cost += mvmt_runtime_vm_cost

    covered_costs = 0
    uncovered_costs = 0
    rs_total_load_cost = 0
    total_runtime = 0

    storage_runtime = 0
    for q in keys:
        if q in curr_query_set:
            covered_costs += baselineManager.get_rs_cost(q)
            storage_runtime += baselineManager.get_rs_runtime(q) 
        else:
            uncovered_costs += baselineManager.get_gcp_cost(q)
    
    # load time, cost
    extra_storage_size_gb = 0
    tbl_names = [baselineManager.table_indices[i] for i in curr_table_set]
    for tname in tbl_names:
        load_time, load_cost = baselineManager.get_load_time_and_cost(tname)
        storage_runtime += load_time
        rs_total_load_cost += load_cost
        size_gb = baselineManager.table_size_gb[tname]
        extra_storage_size_gb += size_gb

    # api cost
    api_cost = 0
    for tbl in curr_table_set:
        api_cost += baselineManager.api_call_cost(tbl)

    storage_cost = ((storage_runtime / 3600) / 730) * extra_storage_size_gb * 0.023
    final_cost = (covered_costs + uncovered_costs + mvmt_cost + rs_total_load_cost + storage_cost + api_cost) # all dollars
    print(f"Function: {final_cost}, {covered_costs}, {uncovered_costs}, {mvmt_cost}, {rs_total_load_cost}, {storage_cost}, {api_cost}")
    return final_cost

# exclude_table should be an int; tables should be a list of ints, subset of
# {1..n}. queries should be subset of query_bit_vec
def remove_table_and_reduce(baselineManager, queries, tables, exclude_table,
        egress_cost, keys):
    # remove table from tables, proceed with repeated process, return final
    # set of queries and tables

    curr_table_set = list(tables) 
    curr_table_set.remove(exclude_table)

    # remove queries associated with this table
    # prune_queries takes a list of tables
    curr_query_set = prune_queries(dict(queries), [exclude_table]) 

    removed_table_with_dep = False # not doing anything with this rn; leaving in case it becomes useful later 
    rnd = 0
    while len(curr_table_set) > 0:
        print("")
        print(f"Round {rnd}")
        values, num_dependencies = assign_values(baselineManager, curr_table_set, curr_query_set, egress_cost)

        working_set = [k for k in values if values[k] > 0]
        to_remove = [k for k in values if values[k] <= 0]
        to_remove_tables = [baselineManager.table_indices.index(t) for t in to_remove]
        if len(to_remove) == 0:
            break
        for t in to_remove:
            if num_dependencies[t] > 0:
                removed_table_with_dep = True

        pruned_tables = [baselineManager.table_indices.index(t) for t in working_set]
        pruned_queries = prune_queries(curr_query_set, to_remove_tables)

        curr_table_set = pruned_tables
        curr_query_set = pruned_queries
        rnd += 1

    final_cost = compute_cost_of_plan(baselineManager, curr_query_set, curr_table_set, keys)
    return final_cost, curr_table_set

def phase_two(baselineManager, queries, tables, egress_cost, keys):
    # while the set of tables is nonempty, choose one, run
    # `remove_table_and_reduce` with it, and get final set along with cost
    # then choose the best subset and repeat, replacing the curr query set and
    # curr table set with those; go till we get to 0, and then choose the cached
    # plan with the best savings
    print('----')
    print(tables)
    curr_table_set = list(tables)
    curr_query_set = dict(queries)

    plan_cache = {}
    cost = compute_cost_of_plan(baselineManager, curr_query_set, curr_table_set, keys)
    # plan_cache['base'] = {"cost": cost, "tables": list(curr_table_set)}
    plan_cache[cost] = list(curr_table_set)
    while len(curr_table_set) > 0:
        vals = {}
        for t in curr_table_set:
            plan_info = {}
            cost, table_set = remove_table_and_reduce(baselineManager, curr_query_set,
                    curr_table_set, t, egress_cost, keys)
            vals[cost] = list(table_set)
            # plan_info["cost"] = cost
            # plan_info["tables"] = list(table_set)
            subset = create_bit_string_from_list(list(table_set))
            print(f"hiya: {bin(subset)}, {cost}")
            # vals[t] = plan_info

        # best_table = min(vals, key=lambda k: vals[k]["cost"])
        print(vals)
        best_cost = min(vals.keys())
        new_table_set = list(vals[best_cost])
        subse = create_bit_string_from_list(new_table_set)
        print(f"NEW ENTRY: {best_cost}, {bin(subset)}")
        to_remove = [i for i in curr_table_set if i not in new_table_set] # TODO iffy
        # foo = {}
        # foo["cost"] = vals[best_table]["cost"]
        # foo["tables"] = list(vals[best_table]["tables"])
        # plan_cache[best_table] = foo
        plan_cache[best_cost] = list(vals[best_cost])

        curr_query_set = prune_queries(curr_query_set, to_remove)
        curr_table_set = new_table_set

    print(plan_cache)
    # best_table = min(plan_cache, key=lambda k: plan_cache[k]["cost"])
    # best_table_set = plan_cache[best_table]["tables"]
    # best_cost = plan_cache[best_table]["cost"]
    
    best_cost = min(plan_cache.keys())
    best_table_set = plan_cache[best_cost]
    print(tables)
    print('----')
    to_remove = [i for i in tables if i not in best_table_set]
    best_query_set = prune_queries(queries, to_remove)
    print(f"Best Cost: ${best_cost};")
    print(best_table_set)
    return best_query_set, best_table_set


def find_best_subset(baselineManager, query_bit_vecs, n, egress_cost,
        use_duck=False, exclude_type=None, exclude=None):
    if use_duck:
        print("Starting analysis using DuckDB")
    else:
        print("Starting analysis without using DuckDB")

    bq_baseline_runtime, bq_baseline_cost = baselineManager.get_baseline_totals(exclude_type=exclude_type,
            exclude=exclude, query_bit_vecs=query_bit_vecs)
    num_keys_init = len(baselineManager.get_key_set_final(exclude_type=exclude_type,
        exclude=exclude, query_bit_vecs=query_bit_vecs))

    # filters down keys to only those without excluded table dependencies or
    # without excluded query
    keys = baselineManager.get_key_set_final(exclude_type=exclude_type,
            exclude=exclude, query_bit_vecs=query_bit_vecs)
    query_savings = compute_savings(baselineManager, keys)

    # curr_query_set = [k for k in keys if query_savings[k] > 0]
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
    
    num_keys_start = len(curr_query_set)
    num_tables_start = len(curr_table_set)
    print(f"Total Keys: {num_keys_init}, Keys Considered: {num_keys_start}")

    rnd = 0
    removed_table_with_dep = False
    # prune away tables with negative values: looking for singleton sets of
    # negative value
    while len(curr_table_set) > 0:
        print("")
        print(f"Round {rnd}")
        values, num_dependencies = assign_values(baselineManager, curr_table_set, curr_query_set, egress_cost)

        working_set = [k for k in values if values[k] > 0]
        to_remove = [k for k in values if values[k] <= 0]
        to_remove_tables = [baselineManager.table_indices.index(t) for t in to_remove]
        if len(to_remove) == 0:
            # return curr_table_set, curr_query_set
            break
        for t in to_remove:
            if num_dependencies[t] > 0:
                removed_table_with_dep = True

        pruned_tables = [baselineManager.table_indices.index(t) for t in working_set]
        pruned_queries = prune_queries(curr_query_set, to_remove_tables)

        curr_table_set = pruned_tables
        curr_query_set = pruned_queries
        rnd += 1
    
    # greedy approach to find sets of tables of size larger than one with
    # negative value. algorithm works by iterating over each node, removing a
    # table and seeing what the result would be. at each round we chose the
    # node-induced subset of tables that results in the largest total workload
    # savings. we then recurse on the chosen subset of tables, and repeat till
    # we've reached a size of 0. Then we look at the every enumerated subset and
    # pick the subset with the largest savings; this could be the empty set or
    # the whole set.
    
    # I'm not convinced yet that choosing the node with the best plan will
    # necessarily lead to the optimal set. Eventually, its possible we chose to
    # remove a node that is in the optimal set, ensuring that in our enumeration
    # we do not identify the true optimal set. I'm not sure that this is the
    # case either, but I havent been able to prove that this doesn't happen.
    # precisely because removing a table in the optimal set could in turn impact
    # multiple non-optimal table nodes, resulting in a larger removal of
    # non-optimal tables than could be achieved by removing a single non-optimal
    # node. Then any loss incurred by removing an optimal node could be
    # termporarily offset by the larger savings achieved by effectively removing
    # multiple non-optimal nodes, even though in the long run this would work
    # out behind. the issue is only that we cannot immediately generate that the
    # non-optimal set minus the optimal table using only a single non-optimal
    # table removal (i think). If we can, then this proof is complete.

    # equivalently: if we can show that the greatest increase in savings (or least
    # decrease) is caused by removing a non-optimal table, then we're also done.
    subset = create_bit_string_from_list(curr_table_set)
    print(f"STARTING PHASE 2: {bin(subset)}")
    best_query_set, best_table_set = phase_two(baselineManager, curr_query_set,
            curr_table_set, egress_cost, keys)

    all_tables = [i for i in range(n)]
    if exclude_type == "t":
        i = baselineManager.table_indices.index(exclude)
        all_tables.remove(i) # remove table from consideration

    num_dependencies = {t: 0 for t in all_tables}
    assert len(keys) == num_keys_init
    total_query_set = {k: query_bit_vecs[k] for k in keys if query_savings[k] > 0}
    for k in total_query_set:
        v = total_query_set[k]
        for tbl in all_tables:
            t = (v >> tbl) & 0x1
            if t == 1:
                num_dependencies[tbl] += 1

    removed_tables = [i for i in all_tables if i not in best_table_set]
    assert len(removed_tables + best_table_set) == len(all_tables)
    for t in removed_tables:
        if num_dependencies[t] > 0:
            removed_table_with_dep = True
            break

    plan_type = ""
    if removed_table_with_dep and len(best_table_set) > 0 and len(best_table_set) < num_tables_start:
        # truly multi cloud
        plan_type = "multi"
    elif len(best_table_set) == 0:
        # gcp only
        plan_type = "gcp"
    elif len(best_table_set) == num_tables_start:
        # aws only; we remove no tables
        plan_type = "aws"
    elif not removed_table_with_dep and len(best_table_set) > 0:
        # aws only; we removed tables; no table had any deps => # removed_table_with_dep false
        plan_type = "aws"
    else:
        plan_type = "wtf"

    tbl_names = [baselineManager.table_indices[i] for i in best_table_set]
    print(best_table_set)
    print(len(best_table_set))
    min_subset = create_bit_string_from_list(best_table_set)
    print(f"Optimal Subset: {bin(min_subset)}")
    print(compute_cost_of_plan(baselineManager, best_query_set, best_table_set,
            keys))

    mvmt_cost = baselineManager.movement_cost(best_table_set) # cost in $; $0.12/GB egress from GCP
    covered_costs = 0
    num_covered = 0
    uncovered_costs = 0
    num_uncovered = 0
    rs_total_load_time = 0
    rs_total_load_cost = 0
    total_runtime = 0

    storage_runtime = 0
    for q in keys:
        if q in best_query_set:
            covered_costs += baselineManager.get_rs_cost(q)
            total_runtime += baselineManager.get_rs_runtime(q)
            storage_runtime += baselineManager.get_rs_runtime(q) 
            num_covered += 1
        else:
            uncovered_costs += baselineManager.get_gcp_cost(q)
            total_runtime += baselineManager.get_gcp_runtime(q)
            num_uncovered += 1
    
    # load time, cost
    extra_storage_size_gb = 0
    for tname in tbl_names:
        load_time, load_cost = baselineManager.get_load_time_and_cost(tname)
        rs_total_load_time += load_time
        storage_runtime += load_time
        rs_total_load_cost += load_cost

        size_gb = baselineManager.table_size_gb[tname]
        extra_storage_size_gb += size_gb

    storage_cost = ((storage_runtime / 3600) / 730) * extra_storage_size_gb * 0.023
    mvmt_runtime = baselineManager.get_size_of_table_set(best_table_set) / baselineManager.transfer_thruput # size in GB times GBps
    mvmt_runtime_vm_cost = 1.38 * (mvmt_runtime / 3600)
    mvmt_cost += mvmt_runtime_vm_cost

    # api cost
    api_cost = 0
    for tbl in best_table_set:
        api_cost += baselineManager.api_call_cost(tbl)

    total_runtime += mvmt_runtime
    total_runtime += rs_total_load_time
    final_cost = (covered_costs + uncovered_costs + mvmt_cost + rs_total_load_cost + storage_cost + api_cost) # all dollars
    print(f"Real: {final_cost}, {covered_costs}, {uncovered_costs}, {mvmt_cost}, {rs_total_load_cost}, {storage_cost}, {api_cost}")
    diff = bq_baseline_cost - final_cost
    percent_diff = (diff / bq_baseline_cost) * 100
    profiling_runtime, profiling_cost = baselineManager.get_profiling_stats(n,
            exclude_type=exclude_type, exclude=exclude, query_bit_vecs=query_bit_vecs)
    data = {}
    data["arachne"] = final_cost
    data["arachne_runtime"] = total_runtime # seconds
    data["bq"] = bq_baseline_cost
    data["bq_baseline_runtime"] = bq_baseline_runtime # seconds
    data["percent_diff"] = percent_diff
    data["multi_cloud_plan"] = plan_type
    data["profiling_runtime"] = profiling_runtime
    data["profiling_cost"] = profiling_cost

    total = None
    add = f"{egress_cost}_{baselineManager.rs_cost}_{baselineManager.bq_cost}"
    fname = f"outputs_noduck_{add}.json"
    if use_duck:
        add = f"{egress_cost}_{baselineManager.rs_cost}_{baselineManager.bq_cost}_{baselineManager.duck_cost}"
        fname = f"outputs_duck_{add}.json"
    try:
        with open(fname, "r") as fp:
            total = json.load(fp)
    except Exception as e:
        total = {}
    
    total[exclude] = data
    with open(fname, "w") as fp:
        json.dump(total, fp, indent=4, sort_keys=True)

    print(f"Num Redshift Qs: {num_covered}; Num GCP Qs: {num_uncovered}")
    if use_duck:
        num_gcp_bq_qs = 0
        for q in keys: 
            if q not in best_query_set:
                if baselineManager.gcp_bq_cheaper(q): 
                    num_gcp_bq_qs += 1
        
        print(f"Num BigQuery Qs: {num_gcp_bq_qs}; Num DuckDB Qs: {num_uncovered - num_gcp_bq_qs}")

    print(f"Redshift Qs: ${covered_costs}; GCP Qs: ${uncovered_costs}; Movement Cost: ${mvmt_cost}")
    print(f"Load Cost: ${rs_total_load_cost}, Storage Cost: ${storage_cost}, API Cost: ${api_cost}")
    print(f"Final cost: ${final_cost}, BQ Baseline: ${bq_baseline_cost}, Diff: ${diff}, %: {percent_diff}%")
    return best_table_set, best_query_set

def create_bit_string_from_list(curr_table_set):
    res = 0
    for i in curr_table_set:
        v = 1 << i
        res = res | v
    return res

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
    
    bytes_to_gb = 1_000_000_000
    bytes_to_tb = 1_000_000_000_000
    if args.base_two:
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
            duck_load_cost=duck_load_cost)

    # n = len(table_indices)
    # profiling_runtime, profiling_cost = baselineManager.get_profiling_stats(n,
    #         exclude_type=None, exclude=None, query_bit_vecs=query_bit_vecs)
    # print(f"{profiling_runtime}s, ${profiling_cost}")

    curr_table_set, curr_query_set = find_best_subset(baselineManager,
            query_bit_vecs, len(table_indices), args.egress, use_duck=args.duck,
            exclude_type=exclude_type, exclude=exclude)




