import json
import glob

fp = open("/home/cc/arachneDB/baseline/duck_c_chameleon_baseline.json")
d = json.load(fp)
fp.close()

exclude = ["02", "03", "04", "11", "22", "28", "40", "52", "98"]

for fn in glob.glob("*.json"):
    key = fn[:2]
    if key in exclude:
        continue
    f = open(fn)
    x = json.load(f)
    f.close()

    print(f"{key}: {x['timing']}")
    d[key] = x['timing']

with open("/home/cc/arachneDB/baseline/duck_c_chameleon_baseline.json", "w") as fp:
    json.dump(d, fp, indent=4, sort_keys=True)



