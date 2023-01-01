import math
import random
import json

BYTES_TO_GB = math.pow(2, 30)
BYTES_TO_TB = math.pow(2, 40)
BQ_COST = 6.25 # $/TB

queries = [i for i in range(1, 100)]

subset = random.sample(queries, 60)
subset = [str(x) if x >= 10 else "0" + str(x) for x in subset]
print(subset)

bq1 = json.load(open("../parquet_1000/real_data_rs1/bigquery_baseline.json"))
bq2 = json.load(open("../parquet_2000/real_data_rs1/bigquery_baseline.json"))

bq1 = json.load(open("../parquet_1000/internal_rs1/bigquery_baseline.json"))
bq2 = json.load(open("../parquet_2000/internal_rs1/bigquery_baseline.json"))

bytes_1tb = 0
runtime_1tb = 0
bytes_2tb = 0
runtime_2tb = 0

for q in subset:
    bytes_1tb += bq1[q]["bytes"]
    bytes_2tb += bq2[q]["bytes"]

    runtime_1tb += bq1[q]["time"]
    runtime_2tb += bq2[q]["time"]

cost_1tb = 48 * BQ_COST * (bytes_1tb / BYTES_TO_TB)
cost_2tb = 48 * BQ_COST * (bytes_2tb / BYTES_TO_TB)

total_cost = cost_1tb + cost_2tb
total_runtime = 48 * (runtime_1tb + runtime_2tb)

print(f"${total_cost:.2f} over {total_runtime:.2f} seconds, {total_runtime / 3600} hours")
print(f"${cost_1tb} for {runtime_1tb} seconds; ${cost_2tb} for {runtime_2tb} seconds") 


