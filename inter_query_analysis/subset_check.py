import json
import math
import sys
import os
from table_names import *

def create_bit_string_from_list(curr_table_set):
    res = 0
    for i in curr_table_set:
        v = 1 << i
        res = res | v
    return res


x = json.load(open("parquet_1000/real_data_rs1/query_bit_vec.json"))
query_bit_vecs = {k: v for k, v in sorted(x.items(), key = lambda item: item[1])}

check = ["date_dim", "item", "web_returns", "web_sales"]
indices = []
for tbl in check:
    i = tpcds_names.index(tbl)
    indices.append(i)

subset = create_bit_string_from_list(indices)
print(bin(subset))
print(subset)

covered = []
uncovered = []
for k in query_bit_vecs:
    vec = query_bit_vecs[k]
    res = vec & subset
    if res == vec:
        covered.append(k)
    else:
        uncovered.append(k)
# return covered, uncovered
print(covered)

