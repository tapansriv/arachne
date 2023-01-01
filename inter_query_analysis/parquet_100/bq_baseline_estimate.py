import json
import sys
import os

table_indices = ["call_center", "catalog_page", "catalog_returns",
        "catalog_sales", "customer", "customer_address",
        "customer_demographics", "date_dim", "household_demographics",
        "income_band", "inventory", "item", "promotion", "reason", "ship_mode",
        "store", "store_returns", "store_sales", "time_dim", "warehouse",
        "web_page", "web_returns", "web_sales", "web_site"]

egress_cost = 0.12
tsize_file = open("table_sizes.json")
table_sizes_bytes = json.load(tsize_file)

fp = open("query_bit_vec.json")
x = json.load(fp)
query_bit_vecs = {k: v for k, v in sorted(x.items(), key = lambda item: item[1])}

bigquery_estimation = {}
for q in query_bit_vecs:
    v = query_bit_vecs[q]
    size = 0
    for t in range(24):
        present = (v >> t) & 0x1
        if present == 1:
            t_size = table_sizes_bytes[table_indices[t]]
            size += t_size

    info = {"bytes": size}
    bigquery_estimation[q] = info

with open("bigquery_baseline.json", "w") as fp:
    json.dump(bigquery_estimation, fp, indent=4, sort_keys=True)


