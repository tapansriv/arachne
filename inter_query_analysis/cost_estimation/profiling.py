'''
Profiling RS8
'''
import json

COST = 1.086 * 8

query_files = ["../parquet_1000/real_data_rs8/rs_baseline.json",
               "../parquet_1000/real_data_rs8/rs_c_baseline.json",
               "../parquet_2000/real_data_rs8/rs_baseline.json",
               "../parquet_2000/real_data_rs8/rs_c_baseline.json",
               "../parquet_1000/real_data_rs8/rs_load_times.json",
               "../parquet_2000/real_data_rs8/rs_load_times.json"]

query_runtime = 0
for qf in query_files:
    data = json.load(open(qf))
    for q in data:
        query_runtime += data[q]

query_cost = (query_runtime / 3600) * COST
print(f"Total cost: ${query_cost:.2f} and Runtime: {query_runtime:.2f} seconds")
