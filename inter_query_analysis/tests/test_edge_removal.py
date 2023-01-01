import json

def create_mask(tbl):
    mask = 1 << tbl
    mask = ~mask
    return mask 

fp = open("query_bit_vec.json")
curr_query_set = json.load(fp)

to_test = ['01']
pos_tbls = [1, 4, 7]

for q in to_test:
    old = curr_query_set[q]
    v = curr_query_set[q]
    for tbl in pos_tbls:
        mask = create_mask(tbl)
        v = (v & mask)
    print(f"Old: {bin(old)}, New: {bin(v)}")

