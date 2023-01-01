import json

def get_tables_for_query(queries, tables, q):
    val = queries[q]
    ret = []
    for tbl in tables:
        t = (val >> tbl) & 0x1
        if t == 1:
            ret.append(tbl)
    return ret


fp = open("query_bit_vec.json")
queries = json.load(fp)
tables = [i for i in range(24)]

pos_queries = ['01', '02']
tables_to_move = []
for q in pos_queries:
    tables_to_move.extend(get_tables_for_query(queries, tables, q))
# multiple queries could move same table. ensure we de-dup the (very short) list
print(tables_to_move)
removed_duplicates = list(set(tables_to_move))
print(removed_duplicates)

