import json 
import os
import sys

dir_ = sys.argv[1]
home = os.path.expanduser("~")
fp = open(f"{home}/arachneDB/{dir_}/worked/processed_profile.json")
prof = json.load(fp)

for k in prof:
    num = prof[k]['len']
    if num == 4:
        continue
    t = k
    if int(k) < 10:
        t = "0" + t
    for i in range(num+1, 5):
        key = f"{t}_{i}.sql"
        os.remove(key)
