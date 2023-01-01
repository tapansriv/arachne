import glob
import json

x = {}

for fname in glob.glob("*"):
    if ".py" in fname:
        continue
    if ".json" in fname:
        continue

    f = open(fname)
    for l in f.readlines():
        if l.startswith("finished original query"):
            vals = l.split(":")
            r = float(vals[1].strip())
            x[fname] = r
            break
        else:
            continue

with open("rs_baseline.json", "w") as fp:
    print(json.dumps(x, indent=4, sort_keys=True))
    json.dump(x, fp, indent=4, sort_keys=True)
