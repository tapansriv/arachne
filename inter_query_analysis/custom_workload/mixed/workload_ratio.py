import json
import math

BYTES_TO_TB = math.pow(2,40)
S_TO_H = 3600
RS_COST = 4 * 1.086
BQ_COST = 6.25

bq = json.load(open("bigquery_baseline.json"))
rs = json.load(open("rs_baseline.json"))

keys = bq.keys() & rs.keys()
print(len(keys))
rs_save = 0
bq_save = 0
for k in keys:
    rs_cost = RS_COST * (rs[k] / S_TO_H)
    bq_cost = BQ_COST * (bq[k]['bytes'] / BYTES_TO_TB)
    
    if rs_cost < bq_cost:
        rs_save += bq_cost - rs_cost
    elif bq_cost < rs_cost:
        bq_save += rs_cost - bq_cost
    else:
        print(f"somehow {k} exactly the same")


print(f"RS Savings: ${rs_save}; BQ Savings: ${bq_save}")
print(f"Ratio: {rs_save / bq_save}")


