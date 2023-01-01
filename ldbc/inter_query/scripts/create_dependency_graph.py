'''
Parse SQL for each query to figure out what tables are used
Use that to construct a bit vector for every query representing what tables are referenced
Using bigquery SQL because the backtick provides easy to find/split delimiter
'''

import os
import json

table_indices = ["organisation", "place", "tag", "tagclass", "message",
                 "message_tag", "forum", "forum_person", "forum_tag", "person",
                 "person_tag", "knows", "likes", "person_university",
                 "person_company"]

def get_tables_for_query(qry_key):
    home = os.path.expanduser("~")

    print(f"-----{qry_key}-----")
    f = open(f"../bq_queries/{qry_key}.sql")
    lines = [l.strip() for l in f.readlines()]

    table_names = set()
    for l in lines:
        if "ldbc" not in l:
            continue
        for tbl in table_indices:
            match = f"ldbc.{tbl}"
            if match in l:
                table_names.add(tbl)
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
    files = os.listdir("../bq_queries")
    keys = [f[:-4] for f in files if f.endswith(".sql")]
    check = {}
    for k in keys:
        table_names = get_tables_for_query(k)
        bit_vec = create_bit_vec(table_names)
        vals[k] = bit_vec
        check[k] = list(table_names)

    print(vals)
    with open("query_bit_vec.json", "w") as fp:
        json.dump(vals, fp, indent=4)
    
    print(json.dumps(check, indent=4, sort_keys=True))
