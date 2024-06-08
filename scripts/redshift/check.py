import json
import os

x = json.load(open("estimation_baseline.json"))

for k in x:
    key = k.split("/")[-1][:-4]
    check = f"plans/{key}.plan"
    if not os.path.exists(check):
        print(key)
