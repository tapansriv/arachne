import glob
import json
from statistics import stdev

num_trials = len(glob.glob("trial*"))
std_times = {}
calcite_times = {}
for i in range(1, num_trials+1):
    dir_ = f"trial{i}"
    n = len(f"{dir_}/std/")
    for fname in glob.glob(f"{dir_}/std/*.time"):
        qry = fname[n:-5]
        if qry not in std_times:
            std_times[qry] = []
        f = open(fname)
        lines = [x.strip() for x in f.readlines()]
        assert len(lines) == 1
        t = int(lines[0].strip())
        secs = float(t) / 1000
        std_times[qry].append(secs)

    n = len(f"{dir_}/calcite/")
    for fname in glob.glob(f"{dir_}/calcite/*.time"):
        qry = fname[n:-5]
        if qry not in calcite_times:
            calcite_times[qry] = []

        f = open(fname)
        lines = [x.strip() for x in f.readlines()]
        assert len(lines) == 1
        t = int(lines[0].strip())
        secs = float(t) / 1000
        calcite_times[qry].append(secs)


with open("cockroach_baseline.json", 'w') as fp:
    # json.dump(std_baseline, fp, indent=4, sort_keys=True)
    json.dump(std_times, fp, indent=4, sort_keys=True)
            
with open("cockroach_c_baseline.json", 'w') as fp:
    # json.dump(c_baseline, fp, indent=4, sort_keys=True)
    json.dump(calcite_times, fp, indent=4, sort_keys=True)
            

