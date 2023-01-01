import json
duck_qs = ['03', '04', '11', '15', '19', '21', '34', '37', '39', '40', '42',
        '43', '46', '47', '50', '52', '55', '56', '57', '60', '63', '68', '73',
        '74', '79', '82', '89', '91']

assert len(duck_qs) == 28

rs_qs = ['04', '09', '18', '22', '25', '27', '33', '48', '49', '56', '60', '71',
        '72', '75', '83', '84', '87', '95']

assert len(rs_qs) == 18

duck =   json.load(open("duck_baseline.json"))
duck_c = json.load(open("duck_c_baseline.json"))
rs =     json.load(open("rs_baseline.json"))
rs_c =   json.load(open("rs_c_baseline.json"))

duck_calcite_data = {}
for q in duck_qs: 
    duck_runtime = duck[q]
    duck_c_runtime = duck_c[q]
    percent_diff = 100* ((duck_runtime - duck_c_runtime) / duck_runtime)
    duck_calcite_data[q] = percent_diff
    print(f"{q}: {percent_diff}")

rs_calcite_data = {}
for q in rs_qs: 
    rs_runtime = rs[q]
    rs_c_runtime = rs_c[q]
    percent_diff = 100* ((rs_runtime - rs_c_runtime) / rs_runtime)
    print(f"{q}: {percent_diff}")
    rs_calcite_data[q] = percent_diff

with open("duck_calcite_data.json", "w") as fp:
    json.dump(duck_calcite_data, fp, indent=4, sort_keys=True)

with open("rs_calcite_data.json", "w") as fp:
    json.dump(rs_calcite_data, fp, indent=4, sort_keys=True)


