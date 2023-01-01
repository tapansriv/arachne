import json 
import os
import sys

dir_ = sys.argv[1]
home = os.path.expanduser("~")
fp = open(f"{home}/arachneDB/{dir_}/worked/processed_profile.json")
prof = json.load(fp)

for k in sorted(prof):
    num = prof[k]['len']
    t = k
    if int(k) < 10:
        t = "0" + t
    print(f"{t} has {num} cuts")
    for i in range(1, num+1):
        key = f"{t}_{i}_1"
        if not os.path.exists(f"{home}/arachneDB/data/{key}"):
            print(key)
