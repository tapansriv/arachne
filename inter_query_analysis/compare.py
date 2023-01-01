import json
import math

BYTES_TO_TB = math.pow(2,40)

external = json.load(open("parquet_1000/batch_rs1/bigquery_baseline.json"))
internal = json.load(open("parquet_1000/internal2024_rs1/bigquery_baseline.json"))

keys = external.keys()

for k in keys:
    if external[k]['bytes'] == internal[k]['bytes']:
        print(f"{k} is the same")
    else:
        bdiff = external[k]['bytes'] - internal[k]['bytes']
        print(f"{k}: {bdiff}")

        ecost = (external[k]['bytes'] / BYTES_TO_TB) * 6.25
        icost = (internal[k]['bytes'] / BYTES_TO_TB) * 6.25
        if ecost < icost:
            print(f"{k}: Ext: ${ecost}. Int: ${icost}, {icost - ecost}")
        else:
            print(f"{k}: Ext: ${ecost}. Int: ${icost}")
