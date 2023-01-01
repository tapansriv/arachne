import json 

duck = json.load(open("duck_baseline.json"))
duck_c = json.load(open("duck_c_baseline.json"))
bq = json.load(open("bigquery_baseline.json"))
rs = json.load(open("rs_baseline.json"))
rs_c = json.load(open("rs_c_baseline.json"))

for k in bq:
    if k not in duck or k not in duck_c:
        # print(f"duck missing {k}")
        continue

    bt = bq[k]['time']
    dt = duck[k]
    dct = duck_c[k]
    # print(f"{k}; duck: {dt}, duck calcite:{dct}, bq: {bt}")
    if dt < bt or dct < bt:
        print(f"{k}; duck: {dt}, duck calcite: {dct}, bq: {bt}")



for k in bq:
    if k not in rs or k not in rs_c:
        #print(f"redshift missing {k}")
        continue

    bt = bq[k]['time']
    rt = rs[k]
    rct = rs_c[k]
    # print(f"{k}; redshift: {rt}, redshift calcite:{rct}, bq: {bt}")
    if rt < bt or rct < bt:
        print(f"{k}; redshift: {rt}, redshift calcite:{rct}, bq: {bt}")

