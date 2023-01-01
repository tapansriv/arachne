import glob
import os
os.chdir("real_data_rs1")

vals = glob.glob("outputs_noduck_*_1.086_5.0*")

es = []
for v in vals:
    vs = v.split("_")
    print(vs[2])
    es.append(vs[2])

es.sort()
print(es)
