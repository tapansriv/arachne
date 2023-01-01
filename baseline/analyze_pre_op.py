import json 
from statistics import stdev

duck = json.load(open("duck_baseline.json"))
duck_c = json.load(open("duck_c_baseline.json"))
rs = json.load(open("rs_baseline.json"))
rs_c = json.load(open("rs_c_baseline.json"))

duck_keys = duck.keys() & duck_c.keys()
duck_savings = {}
duck_percents = []
for k in duck_keys:
    dr1 = duck[k]
    dr2 = duck_c[k]
    cd1 = (dr1 / 3600) * 1.48
    cd2 = (dr2 / 3600) * 1.48

    if cd2 < cd1:
        savings = (cd1 - cd2) 
        percent = 100 * (savings / cd1)
        # print(f"{savings}, {percent}")
        duck_percents.append(percent)
        vals = {}
        vals['val1'] = cd1
        vals['val2'] = cd2
        vals['savings'] = savings
        vals['percent'] = percent
        duck_savings[k] = vals


rs_keys = rs.keys() & rs_c.keys()
rs_savings = {}
rs_percents = []
for k in rs_keys:
    rsr1 = rs[k]
    rsr2 = rs_c[k]
    crs1 = (rsr1 / 3600) * 1.086
    crs2 = (rsr2 / 3600) * 1.086

    if crs2 < crs1:
        savings = crs1 - crs2
        percent = 100 * (savings / crs1)
        # print(f"{savings}, {percent}")
        rs_percents.append(percent)
        vals = {}
        vals['crs1'] = crs1
        vals['crs2'] = crs2
        vals['savings'] = savings
        vals['percent'] = percent
        rs_savings[k] = vals


num_duck = len(duck_savings)
num_rs = len(rs_savings)

avg_duck_percent = sum(duck_percents) / num_duck
avg_rs_percent = sum(rs_percents) / num_rs

max_duck = max(duck_percents)
max_rs = max(rs_percents)

min_duck = min(duck_percents)
min_rs = min(rs_percents)

stdev_duck = stdev(duck_percents)
stdev_rs = stdev(rs_percents)

print(f"{num_duck}, {avg_duck_percent}, {stdev_duck}, {min_duck}, {max_duck}")
print(f"{num_rs}, {avg_rs_percent}, {stdev_rs}, {min_rs}, {max_rs}")


