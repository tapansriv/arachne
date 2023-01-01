import json
import sys
import os

table_indices = ['forum_person', 'organisation', 'forum_tag', 'message', 'post',
        'person_company', 'tag', 'tagclass', 'person_tag', 'comment', 'likes',
        'message_tag', 'person', 'knows', 'forum', 'place', 'person_university']

egress_cost = 0.12
card = json.load(open("ldbc_card.json"))
rs = json.load(open("ldbc_row_sizes.json"))
table_sizes_bytes = {}

for tbl in table_indices:
    table_sizes_bytes[tbl] = rs[tbl] * card[tbl]

fp = open("query_bit_vec.json")
x = json.load(fp)
query_bit_vecs = x

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
    json.dump(bigquery_estimation, fp, indent=4)


