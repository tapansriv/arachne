import json
import math 

BYTES_TO_TB = math.pow(2,40)

rs = json.load(open("ldbc.json"))
bq = json.load(open("../bq_queries/bigquery_ldbc_baseline.json"))

keys = rs.keys() & bq.keys()
print(len(rs.keys()))
print(len(bq.keys()))
print(len(keys))

for k in keys:
    rcost = 4 * 1.086 * (rs[k] / 3600)
    scost = (bq[k]['bytes']/BYTES_TO_TB) * 6.25

    if scost < rcost: 
        diff = rcost - scost
        pdiff = 100 * diff / rcost 
        print(f"!!!!!   {k}: {diff}; {pdiff}")

    print(f"{k}: RS ${rcost:.2f} ------ BQ: ${scost:.2f}")
