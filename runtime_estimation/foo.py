import json
import shutil

pth = "/Users/tapansriv/arachneDB/inter_query_analysis/custom_workload/mixed"
prefix = "/home/cc/arachneDB/custom_workload/redshift_queries"

custom = json.load(open("baselines/custom_all_sf100.json"))
mixed = json.load(open("baselines/test_runtimes.json"))

keys = custom.keys() - mixed.keys()

out = {}
for k in keys:
    ckey = f"{k}"
    if ckey in custom:
        out[k] = custom[ckey]
    else:
        print(f"{k} didn't run in custom 100GB")

with open("baselines/custom_train_sf100.json", 'w') as fp:
    json.dump(out, fp, indent=4, sort_keys=True)




