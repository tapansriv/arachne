import json

x1 = json.load(open("bigquery_baseline_old.json"))
x2 = json.load(open("bigquery_100_baseline.json"))



assert len(x1.keys() & x2.keys()) == 0

x = {}

for k in x1:
    x[k] = x1[k]

for k in x2:
    x[k] = x2[k]

with open("bigquery_baseline.json", 'w') as fp:
    json.dump(x, fp, sort_keys=True, indent=4)



