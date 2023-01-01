import json

duck = json.load(open("duck_baseline.json"))
duck_c = json.load(open("duck_c_baseline.json"))
rs = json.load(open("rs_baseline.json"))
rs_c = json.load(open("rs_c_baseline.json"))
bq = json.load(open("bigquery_baseline.json"))



keys = ["0" + str(x) if x < 10 else str(x) for x in range(1,100)]


duck_total = 0
duck_c_total = 0
bq_total = 0
min_total = 0

for k in keys:
    if k == "32" or k == "64" or k == "72" or k == "78" or k == "85" or k == "95":
        continue
    r1 = duck[k]
    # r2 = duck_c[k]
    cd1 = (r1 / 3600) * 1.48
    #jcd2 = (r2 / 3600) * 1.48

    s = bq[k]["bytes"] / 1_000_000_000_000
    cs = s * 5

    r1 = rs[k]
    # r2 = rs_c[k]
    crs1 = (r1 / 3600) * 1.086
    # crs2 = (r2 / 3600) * 1.086
    # m = min(cd1, cd2, crs1, crs2, cs)
    m = min(cd1, crs1, cs)
    print(f"{cd1}, {crs1}, {cs}")
    duck_total += cd1
    # duck_c_total += c2
    bq_total += cs
    min_total += m

    if cs < cd1:
        print(f"BigQuery Less Than DuckDB {k}: ${cs}, ${cd1}")
    # if cs < min(cd1, cd2):
    #     print(f"BigQuery Less Than Best DuckDB {k}: ${cs}, ${cd1}, ${cd2}")
    if cs < crs1:
        print(f"BigQuery Less Than Redshift {k}: ${cs}, ${crs1}")
    # if cs < min(crs1, crs2):
    #     print(f"BigQuery Less Than Best Redshift {k}: ${cs}, ${crs1}, ${crs2}")



print(f"{duck_total}, {duck_c_total}, {bq_total}, {min_total}")
