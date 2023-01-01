import json

bq = json.load(open("bigquery_baseline.json"))
duck = json.load(open("duckdb_baseline.json"))

keys = bq.keys() & duck.keys()
conv = 2**30

for k in keys:
    size_cost = 0.005 * (bq[k]['bytes'] / conv)
    time_cost = 1.086 * (duck[k] / 3600)

    print(f"{k}: size_cost: {size_cost}, time_cost: {time_cost}")
    if size_cost < time_cost:
        print(f"{k}; woot")

