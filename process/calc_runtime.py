import json
import sys
import os


def get_baseline_runtime(b, b_c, bq, k, gcp):
    rate = 1.086
    if gcp:
        rate = 1.45

    c1 = (b[k] / 3600) * rate
    c2 = (b_c[k] / 3600) * rate
    bq_val = bq_baseline[k]["bytes"]
    r3 = bq_baseline[k]['time']
    c3 = (bq_val / 1000000000) * 0.005
    # print(f"baseline: {b[k]}, b_c: {b_c[k]}, bq: {r3}")


    boundary = min(c1, c2)
    if gcp: 
        boundary = min(c1, c2, c3)

    vals = [(b[k], c1), (b_c[k], c2), (r3, c3)]
    z = [x for (x, y) in vals if y == boundary]
    return z[0] 


dir_ = sys.argv[1]
home = os.path.expanduser("~")
os.chdir(f"{home}/arachneDB/{dir_}/worked")

f = None
f_c = None
gcp = False
if dir_.startswith("gcp"):
    f = open(f"{home}/arachneDB/baseline/duck_baseline.json")
    f_c = open(f"{home}/arachneDB/baseline/duck_c_baseline.json")
    gcp = True
elif dir_.startswith("rs"):
    f = open(f"{home}/arachneDB/baseline/rs_baseline.json")
    f_c = open(f"{home}/arachneDB/baseline/rs_c_baseline.json")

baseline = json.load(f)
baseline_c = json.load(f_c)
f = open(f"{home}/arachneDB/baseline/bigquery_baseline.json")
bq_baseline = json.load(f)

vals = [int(x.strip()) for x in open("../gen_worked").readlines()]
keys = [str(x) if x >= 10 else "0"+str(x) for x in vals]
print(keys)

output = {}

for k in keys:
    data = {}

    lines = [l.strip() for l in open(f"{k}.out").readlines()]
    last = lines[-1]
    if "FAILED" in last:
        # arachne_time = baseline[k]
        arachne_time = get_baseline_runtime(baseline, baseline_c, bq_baseline, k, gcp)        
        if arachne_time < 0:
            continue
        data['arachne_time'] = arachne_time
        data['failed'] = 1
        print(f"{k} no plan: {arachne_time}")
    else:
        num_lines = len(lines)
        start = -1
        for i, l in reversed(list(enumerate(lines))):
            if l.startswith("(estimate)"):
                start = i+1
                break

        a_runtime = 0
        for i in range(start, num_lines-1):
            line = lines[i]
            vals = line.split(" ")
            for j in range(0, len(vals)):
                if vals[j].startswith("RUNTIME"):
                    r = float(vals[j+1])
                    a_runtime += r
                    # print(f"line {i} runtime: {r}")
                    break
        
        print(a_runtime)
        data['arachne_time'] = a_runtime
        data['failed'] = 0
        print(f"{k} found plan: {arachne_time}")

    b = baseline[k]
    b_c = baseline_c[k]
    bq = bq_baseline[k]['time']
    data['baseline_time'] = b
    data['baseline_calcite_time'] = b_c
    data['bq_time'] = bq
    output[k] = data

# print(json.dumps(output, indent=4))
with open("processed_runtime.json", "w") as fp:
    json.dump(output, fp, indent=4)
