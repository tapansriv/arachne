import json

f = open("out")
lines = f.readlines()
output = {}

for l in lines:
    if not l.startswith("Query /"):
        continue

    x = l[6:]
    vals = x.split(":")
    longkey = vals[0]
    key = longkey.split("/")[-1][:-4]
    z = (vals[1].strip().split(" ")[0])
    runtime = float(z)

    output[key] = runtime

with open("ldbc.json", 'w') as fp:
    json.dump(output, fp, indent=4, sort_keys=True)

