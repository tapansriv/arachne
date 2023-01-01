import json

f = open('foo')
lines = [x.strip() for x in f.readlines()]

baseline = {}
for l in lines:
    if l.startswith("starting"):
        continue
    if "error in running calcite" in l:
        continue
    vals = l.split(": ")
    runtime = float(vals[1].split(" ")[0])
    key = vals[0][-6:-4]
    baseline[key] = runtime

with open("rs_c_baseline2.json", 'w') as fp:
    json.dump(baseline, fp, indent=4, sort_keys=True)
