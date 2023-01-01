'''
Sum costs for each thing
'''

import json

low_mem = json.load(open("low_mem/duckdb_baseline.json"))
std_setup = json.load(open("std_setup/duckdb_baseline.json"))

keys = low_mem.keys()
print(f"Low Mem ({len(low_mem.keys())}); Std ({len(std_setup.keys())}); Num keys: {len(keys)}")

lm_total = 0
std_total = 0
for k in keys:
    lm_time = low_mem[k] / 3600 # hours
    lm_cost = lm_time * 1.086
    lm_total += lm_cost

    std_time = std_setup[k] / 3600 # hours
    std_cost = std_time * 1.086
    std_total += std_cost

print(f"Low Mem Cost: ${lm_total}; Std Cost: ${std_total}")
