'''
Parse SQL for each query to figure out what tables are used
Use that to construct a bit vector for every query representing what tables are referenced
Using bigquery SQL because the backtick provides easy to find/split delimiter
'''

import os
import json

table_indices = ['Message', 'Person_knows_Person', 'Person', 'City', 'Country',
        'Message_hasTag_Tag', 'Tag', 'TagClass', 'Person_likes_Message',
        'Forum', 'Forum_hasMember_Person', 'Person_hasInterest_Tag',
        'Person_knows_person', 'Post_View']

def get_tables_for_query(qry_key, ds):
    home = os.path.expanduser("~")
    dep_key = None
    if qry_key.isdigit():
        dep_key = f"bi-{qry_key}"
    else:
        dep_key = f"bi-{qry_key[:-1]}"

    print(f"-----{dep_key}-----")
    table_names = ds[dep_key]
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
    ds = json.load(open("dependencies.json"))
    bq = json.load(open("bigquery_baseline.json"))
    keys = bq.keys()
    for qry_key in keys:
        table_names = get_tables_for_query(qry_key, ds)
        bit_vec = create_bit_vec(table_names)
        vals[qry_key] = bit_vec

    print(vals)
    with open("query_bit_vec.json", "w") as fp:
        json.dump(vals, fp, indent=4)
