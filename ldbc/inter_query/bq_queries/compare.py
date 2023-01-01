import json
import math

BYTES_TO_TB = math.pow(2,40)

external = json.load(open("bigquery_ldbc_external.json"))
internal = json.load(open("bigquery_ldbc_internal.json"))

keys = external.keys()

for k in keys:
    if external[k]['bytes'] == internal[k]['bytes']:
        print(f"{k} is the same")
    else:
        ecost = (external[k]['bytes'] / BYTES_TO_TB) * 6.25
        icost = (internal[k]['bytes'] / BYTES_TO_TB) * 6.25
        if ecost < icost:
            etime = external[k]['time']
            itime = internal[k]['time']
            print(f"{k}: Ext: ${ecost}. Int: ${icost}, {icost - ecost}")
            if etime > itime: 
                print(f"INTERNAL FASTER {etime - itime}")
            else:
                print("EXTERNAL FASTER")
        else:
            print(f"{k}: Ext: ${ecost}. Int: ${icost}")

