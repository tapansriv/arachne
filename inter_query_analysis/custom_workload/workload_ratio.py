import json
import os
import math
import sys

path = sys.argv[1]

BYTES_TO_TB = math.pow(2,40)
S_TO_H = 3600
RS_COST = 4 * 1.086
BQ_COST = 6.25

bq = json.load(open(os.path.join(path, "bigquery_baseline.json")))
rs = json.load(open(os.path.join(path, "rs_baseline.json")))

keys = bq.keys() & rs.keys()
print(len(keys))

rs_baseline = 0
bq_baseline = 0

num_bq_cheaper = 0
num_rs_cheaper = 0
rs_save = 0
bq_save = 0
for k in keys:
    rs_cost = RS_COST * (rs[k] / S_TO_H)
    bq_cost = BQ_COST * (bq[k]['bytes'] / BYTES_TO_TB)

    rs_baseline += rs_cost
    bq_baseline += bq_cost
    
    if rs_cost < bq_cost:
        num_rs_cheaper += 1
        rs_save += bq_cost - rs_cost
    elif bq_cost < rs_cost:
        num_bq_cheaper += 1
        bq_save += rs_cost - bq_cost
    else:
        print(f"somehow {k} exactly the same")


print(f"RS Savings: ${rs_save}; BQ Savings: ${bq_save}")
print(f"Ratio: {rs_save / bq_save}")

print(f"RS: ${rs_baseline}.      BQ: ${bq_baseline}")
print(f"NUM RS: {num_rs_cheaper}; NUM BQ: {num_bq_cheaper}")
