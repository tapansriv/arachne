import json
import glob

outfile = "rs_baseline.json"
output = {}
try:
    with open(outfile) as f:
        output = json.load(f)
except FileNotFoundError:
    pass

for f in glob.glob("*.out"):
    key = f[0:-4]
    x = open(f)
    runtime = float(x.readlines()[0].strip())
    output[key] = runtime


with open(outfile, 'w') as fp:
    json.dump(output, fp, indent=4, sort_keys=True)
