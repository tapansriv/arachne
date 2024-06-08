'''
`opt_test_tables` from `table_names.py` in top level `inter-query-processing`
dir loads from `opt_test.txt` for table names so now that's configurable

Script would then increase number of tables in JSON file (with names like
table1,…tableN), increase number of queries in mock baseline files, update
table_sizes.json with appropriate number of table entries, and update
query_bit_vecs have have every query require every table maybe 
(this could backfire if it makes the analysis super easy)
'''

import sys
import os
import json
import random
from argparse import ArgumentParser

parser = ArgumentParser(description="Resize fake instance")
parser.add_argument("--num_queries", type=int, default=100, help="Number of Queries")
parser.add_argument("--num_tables", type=int, default=24, help="Number of tables")
# parser.add_argument("--complexity", type=float, default=1.0, 
#                     help="How many tables queries depend on")
args = parser.parse_args()

home = os.path.expanduser("~")
os.chdir(f"{home}/arachneDB/inter_query_analysis/parquet_1000/opt_test")

# assert args.complexity <= 1.0 and args.complexity >= 0.0, "Complexity must be float between 0 and 1"

table_names = [f"table{i}" for i in range(args.num_tables)]
query_names = [f"query{i}" if i > 10  else f"query0{i}" for i in range(args.num_queries)]

real_times = json.load(open("rs_baseline_true.json"))
bq_real = json.load(open("bigquery_baseline_true.json"))
real_keys = list(real_times.keys() & bq_real.keys())
n_qs_true = len(real_keys)

real_sizes = json.load(open("table_sizes_true.json"))
real_loads = json.load(open("rs_load_times_true.json"))
tbl_keys = list(real_sizes.keys())
n_tbls_true = len(real_sizes)


rs_query_times = {name: real_times[real_keys[i % n_qs_true]] for i, name in enumerate(query_names)}
bq_query_times = {name: bq_real[real_keys[i % n_qs_true]] for i, name in enumerate(query_names)}
table_sizes = {name: real_sizes[tbl_keys[i % n_tbls_true]] for i, name in enumerate(table_names)}
load_times  = {name: real_loads[tbl_keys[i % n_tbls_true]] for i, name in enumerate(table_names)}


# num_dependencies = int(args.num_tables * args.complexity)
# if num_dependencies == 0:
#     num_dependencies = 1

query_bit_vecs = {qkey: 0 for qkey in query_names}
for qkey in query_names:
    num_dependencies = random.randint(2, 7)
    q_tbls_indices = random.sample(range(args.num_tables), num_dependencies)
    res = 0
    for i in q_tbls_indices:
        v = 1 << i
        res = res | v
    query_bit_vecs[qkey] = res

with open(f"{home}/arachneDB/inter_query_analysis/opt_test.txt", 'w') as fp:
    fp.write("\n".join(table_names))

with open('rs_baseline.json', 'w') as fp:
    json.dump(rs_query_times, fp, indent=4, sort_keys=True)

with open('bigquery_baseline.json', 'w') as fp:
    json.dump(bq_query_times, fp, indent=4, sort_keys=True)

with open('query_bit_vec.json', 'w') as fp:
    json.dump(query_bit_vecs, fp, indent=4, sort_keys=True)

with open('rs_load_times.json', 'w') as fp:
    json.dump(load_times, fp, indent=4, sort_keys=True)

with open('table_sizes.json', 'w') as fp:
    json.dump(table_sizes, fp, indent=4, sort_keys=True)


