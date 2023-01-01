'''
Parse SQL for each query to figure out what tables are used
Use that to construct a bit vector for every query representing what tables are referenced
Using bigquery SQL because the backtick provides easy to find/split delimiter
'''

import os
import json

table_indices = ['forum_person', 'organisation', 'forum_tag', 'message', 'post', 'person_company', 'tag', 'tagclass', 'person_tag', 'comment', 'likes', 'message_tag', 'person', 'knows', 'forum', 'place', 'person_university']

def get_tables_for_query(qry_key):
    home = os.path.expanduser("~")

    print(f"-----{qry_key}-----")
    ds = json.load(open("dependencies.json"))
    table_names = ds[qry_key]
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
    keys = [str(i) for i in range(1, 10)]
    keys.append("10-shortestpath")
    keys = keys + ["11", "13", "14"]
    for i in keys:
        qry_key = f"{i}"
        table_names = get_tables_for_query(qry_key)
        bit_vec = create_bit_vec(table_names)
        vals[qry_key] = bit_vec

    print(vals)
    with open("query_bit_vec.json", "w") as fp:
        json.dump(vals, fp, indent=4)
