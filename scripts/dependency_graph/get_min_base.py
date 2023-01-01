import json
import os

home = os.path.expanduser("~")

duck = json.load(open(f"{home}/arachneDB/baseline/duck_baseline.json"))
duck_c = json.load(open(f"{home}/arachneDB/baseline/duck_c_baseline.json"))
rs = json.load(open(f"{home}/arachneDB/baseline/rs_baseline.json"))
rs_c = json.load(open(f"{home}/arachneDB/baseline/rs_c_baseline.json"))
bq = json.load(open(f"{home}/arachneDB/baseline/bigquery_baseline.json"))

keys = rs.keys() & rs_c.keys() & bq.keys()
print(len(keys))

rs_total = 0
rs_c_total = 0
bq_total = 0
for k in keys:
    rsr1 = rs[k]
    rsr2 = rs_c[k]
    crs1 = (rsr1 / 3600) * 1.086
    crs2 = (rsr2 / 3600) * 1.086
    s = bq[k]["bytes"] / 1_000_000_000_000
    cs = s * 5

    rs_total += crs1
    rs_c_total += crs2
    bq_total += cs

print(f"{rs_total}, {rs_c_total}, {bq_total}")

keys = rs.keys() & rs_c.keys() & bq.keys()
keys = keys & duck.keys() & duck_c.keys()
print(len(keys))

rs_total = 0
rs_c_total = 0
duck_total = 0
duck_c_total = 0
bq_total = 0
for k in keys:
    rsr1 = rs[k]
    rsr2 = rs_c[k]
    crs1 = (rsr1 / 3600) * 1.086
    crs2 = (rsr2 / 3600) * 1.086
    s = bq[k]["bytes"] / 1_000_000_000_000
    cs = s * 5

    dr1 = duck[k]
    dr2 = duck_c[k]
    cd1 = (dr1 / 3600) * 1.48
    cd2 = (dr2 / 3600) * 1.48

    duck_total += cd1
    duck_c_total += cd2
    rs_total += crs1
    rs_c_total += crs2
    bq_total += cs

print(f"{duck_total}, {duck_c_total}, {rs_total}, {rs_c_total}, {bq_total}")

