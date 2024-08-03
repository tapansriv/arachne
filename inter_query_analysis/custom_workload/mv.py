import subprocess
import json

dirs = ["cpu_0.5", "io_2", "mixed"]
workloads = ["CPU", "IO", "Mixed"]


for i in range(len(dirs)):
    dir_ = dirs[i]
    wrkld = workloads[i]

    f1 = open(f"{dir_}/bigquery_baseline.json")
    f2 = open(f"{dir_}/rs_baseline.json")
    x1 = json.load(f1)
    x2 = json.load(f2)
    keys = x1.keys() & x2.keys()
    for k in keys:
        src = f"/Users/tapansriv/arachne/custom_workload/redshift_queries/{k}.sql"
        dst = f"/Users/tapansriv/multi-cloud-workload/{wrkld}"
        print(src)
        print(dst)
        subprocess.run(["cp", src, dst])
