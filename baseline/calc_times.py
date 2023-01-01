import json 

duck = json.load(open("duck_baseline.json"))
duck_c = json.load(open("duck_c_baseline.json"))
bq = json.load(open("bigquery_baseline.json"))
rs = json.load(open("rs_baseline.json"))
rs_c = json.load(open("rs_c_baseline.json"))

keys = bq.keys() & duck.keys() & rs.keys()


bq_tot_time = 0
duck_tot_time = 0
duck_opt_tot_time = 0
rs_tot_time = 0
rs_opt_tot_time = 0

for k in keys:
    duck_time = duck[k]
    duck_opt_time = duck[k]
    if k in duck_c:
        duck_c_time = duck_c[k]
        if duck_c_time < duck_opt_time:
            duck_opt_time = duck_c_time

    rs_time = rs[k]
    rs_opt_time = rs[k]
    if k in rs_c:
        rs_c_time = rs_c[k]
        if rs_c_time < rs_opt_time:
            rs_opt_time = rs_c_time

    bq_time = bq[k]['time']
    
    bq_tot_time += bq_time
    duck_tot_time += duck_time
    duck_opt_tot_time += duck_opt_time
    rs_tot_time += rs_time
    rs_opt_tot_time += rs_opt_time


print(f"Big Query Time: {bq_tot_time}s, Duck Total Time: {duck_tot_time}s, Duck Optimal Time: {duck_opt_tot_time}s, Redshift Total Time: {rs_tot_time}, Redshift Optimal Time: {rs_opt_tot_time}")



'''
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
'''
