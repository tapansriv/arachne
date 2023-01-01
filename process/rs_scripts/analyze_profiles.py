import glob
import sys
import os
import json

dir_ = sys.argv[1]
home = os.path.expanduser("~")
os.chdir(f"{home}/arachneDB/{dir_}/worked")

data = {}
files = glob.glob("*.profile")
tot = 0
for f in files:
    tot += 1
    key = int(f[:-8])
    lines = [x.strip() for x in open(f).readlines()]
    size = len(lines)
    i = 0
    trial = 1
    val = lines[i]

    tot_cost = 0
    key_vals = {}
    while val: 
        num = int(val)
        total_runtime = 0
        for j in range(num):
            curr = lines[i+1+j]
            t = float(curr.split("RUNTIME: ")[1].split(" ")[0])
            total_runtime += t
        cost = (total_runtime/3600) * 1.086
        tot_cost += cost
        key_vals[trial] = cost
        # print(f"{key}: {trial}, runtime: {total_runtime}, cost: {cost}")
        i += num + 1
        val = None
        if i < size:
            val = lines[i]
        trial += 1
    key_vals['total'] = tot_cost
    key_vals['len'] = trial - 1
    data[key] = key_vals
    # print(f"{key}, cost: {tot_cost}")
print(tot)
with open("processed_profile.json", "w") as fp:
    json.dump(data, fp, indent=4)
print(json.dumps(data, indent=4))
