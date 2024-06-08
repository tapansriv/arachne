'''
Parse SQL for each query to figure out what tables are used
Use that to construct a bit vector for every query representing what tables are referenced
Using bigquery SQL because the backtick provides easy to find/split delimiter
'''

import os
import json

table_indices = ["call_center", "catalog_page", "catalog_returns",
        "catalog_sales", "customer", "customer_address",
        "customer_demographics", "date_dim", "household_demographics",
        "income_band", "inventory", "item", "promotion", "reason", "ship_mode",
        "store", "store_returns", "store_sales", "time_dim", "warehouse",
        "web_page", "web_returns", "web_sales", "web_site"]

def get_tables_for_query(qry_key):
    home = os.path.expanduser("~")

    print(f"-----{qry_key}-----")
    f = open(f"{qry_key}.sql")
    lines = [l.strip() for l in f.readlines()]

    table_names = set()
    for l in lines:
        vals = l.split(" ")
        for v in vals:
            if "tpcds" not in v:
                continue
            tbl = v.split(".")[1].strip()
            if tbl[-1] == ',':
                tbl = tbl[:-1]
            if tbl in table_indices:
                table_names.add(tbl)
            else:
                print("WEIRD WEIRD WEIRD WEIRD")
                print(tbl)
                print(l)
    return table_names

def create_bit_vec(table_names):
    bit_vec = 0
    for tbl in table_names:
        ind = table_indices.index(tbl)
        tbl_vec = 1 << ind
        bit_vec = bit_vec | tbl_vec

    print(bin(bit_vec))
    return bit_vec

if __name__ == '__main__':
    vals = {}
    files = os.listdir(".")
    keys = [f[:-4] for f in files if f.endswith(".sql")]
    check = {}
    for k in keys:
        table_names = get_tables_for_query(k)
        bit_vec = create_bit_vec(table_names)
        vals[k] = bit_vec
        check[k] = list(table_names)

    print(vals)
    with open("query_bit_vec.json", "w") as fp:
        json.dump(vals, fp, indent=4, sort_keys=True)
    
    print(json.dumps(check, indent=4, sort_keys=True))
