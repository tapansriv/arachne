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

def get_tables_for_query(qry_ind):
    home = os.path.expanduser("~")

    print(f"-----{qry_key}-----")
    f = open(f"{home}/arachneDB/bq_queries/{qry_key}.sql")
    lines = [l.strip() for l in f.readlines()]

    table_names = []
    for l in lines:
        if "arachne-multicloud" not in l:
            continue
        xs = l.split("`")
        for x in xs:
            if "arachne-multicloud" not in x:
                continue
            ys = x.split(".") # always results in arachne-multicloud.tpcds.TBL_NAME            
            tbl_name = ys[2].strip()
            print(f"found; possible duplicate: {tbl_name}")
            if tbl_name not in table_names:
                print(f"adding tbl {tbl_name}")
                table_names.append(tbl_name)

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
    for i in range(1,100):
        qry_key = f"{i}"
        if i < 10:
            qry_key = "0" + qry_key
        table_names = get_tables_for_query(qry_key)
        bit_vec = create_bit_vec(table_names)
        vals[qry_key] = bit_vec

    print(vals)
    with open("query_bit_vec.json", "w") as fp:
        json.dump(vals, fp, indent=4)
