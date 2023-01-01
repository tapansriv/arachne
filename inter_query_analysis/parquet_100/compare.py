'''
Compare low mem vs std setup situations
'''
import json

low_mem = json.load(open("low_mem/duckdb_baseline.json"))
std_setup = json.load(open("std_setup/duckdb_baseline.json"))

keys = low_mem.keys() & std_setup.keys()
print(f"Low Mem ({len(low_mem.keys())}); Std ({len(std_setup.keys())}); Num keys: {len(keys)}")

for k in keys:
    lm_time = low_mem[k]
    std_time = std_setup[k]

    diff = abs(lm_time - std_time)
    percent_diff = diff / std_time
    if percent_diff > 0.15:
        print(f"Key: {k}: Low: {lm_time}, Std: {std_time}, Diff: {diff}, %: {percent_diff}")


