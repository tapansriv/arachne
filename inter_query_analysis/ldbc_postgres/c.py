import json

f = open('bigquery_baseline.json')
bq = json.load(f)
f.close()

result = {}
for k in bq:
    tmp = {}
    tmp['bytes'] = bq[k]
    result[k] = tmp

with open("bigquery_baseline.json", "w") as fp:
    json.dump(result, fp, indent=4, sort_keys=True)
