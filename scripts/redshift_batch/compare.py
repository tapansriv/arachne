import json
import math
import os

BYTES_TO_TB = math.pow(2,40)

bq = json.load(open("bq_queries/bigquery_custom.json"))

for k in bq:
    data_path = f"custom_workload/{k}.out" 
    if not os.path.exists(data_path):
        continue

    f = open(data_path)
    
    runtime = float(f.readlines()[0].strip())
    rcost = (runtime / 3600) * 4 * 1.086
    scost = (bq[k]['bytes'] / BYTES_TO_TB) * 6.25
    
    if rcost > scost:
        print(f"BQ {k}: {rcost}, {scost}, {rcost - scost}")
    else:
        print(f"RS {k}: {rcost}, {scost}, {rcost - scost}")
        #print(f"{k} cheaper in rs")

