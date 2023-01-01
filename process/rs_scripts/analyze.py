import json
import os
import sys

dir_ = sys.argv[1]

home = os.path.expanduser("~")
bq = open(f"{home}/arachneDB/baseline/bigquery_baseline.json")
d = open(f"{home}/arachneDB/baseline/rs_baseline.json")
dc = open(f"{home}/arachneDB/baseline/rs_c_baseline.json")
os.chdir(f"{home}/arachneDB/{dir_}/worked")
bq_baseline = json.load(bq)
rs_baseline = json.load(d)
rs_c_baseline = json.load(dc)

f = open("summary.txt")
lines = f.readlines()

output = {}
for l in lines:
    split = l.split(",")
    key = split[0]
    index = int(key)
    val = split[1]
    line_out = {}
    rs_val = (rs_baseline[key] / 3600) * 1.45
    if "FAILED" in val:
        bq_val = bq_baseline[key]["bytes"]
        bq_val = (bq_val / 1000000000) * 0.005
        rs_c_cost = (rs_c_baseline[key] / 3600) * 1.45
        line_out["arachne_cost"] = -1
        line_out["bq_cost"] = bq_val
        line_out["rs_cost"] = rs_val
        line_out["rs_c_cost"] = rs_c_cost
        line_out["rs_cut_no_hybrid"] = -1
    else:
        arachne = float(split[1])
        bq_val = float(split[2])
        rs_c_cost = (rs_c_baseline[key] / 3600) * 1.45
        rs_cut_no_hybrid = float(split[4])
        line_out["arachne_cost"] = arachne
        line_out["bq_cost"] = bq_val
        line_out["rs_cost"] = rs_val
        line_out["rs_c_cost"] = rs_c_cost
        line_out["rs_cut_no_hybrid"] = rs_cut_no_hybrid

    output[key] = line_out

with open("processed_data.json", "w") as fp:
    json.dump(output, fp, indent=4)

