import json

rs = json.load(open('rs_baseline.json'))
bq = json.load(open('bigquery_baseline.json'))

keys = rs.keys() & bq.keys()

out = {}
for k in keys:
    out[k] = rs[k]

with open('io_sf1000.json', 'w') as fp:
    json.dump(out, fp, indent=4, sort_keys=True)


