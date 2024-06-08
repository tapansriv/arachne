import duckdb
import os
import sys
import json
import time

key = sys.argv[1]
home = os.path.expanduser("~")
f = open(f"{home}/arachneDB/p_queries/{key}.sql")
qry = "".join(f.readlines())

os.chdir("/mnt/disks/tpcds/parquet")
runtimes = []
for t in range(5):
    con = duckdb.connect(f"/mnt/disks/tpcds/baseline_scripts/{key}.db")
    con.execute("PRAGMA memory_limit='165G'")
    start = time.time()
    con.execute(qry)
    runtime = time.time() - start
    runtimes.append(runtime)
    print(f"{key}, trial {t}, runtime: {runtime}")
    con.close()
    os.remove(f"/mnt/disks/tpcds/baseline_scripts/{key}.db")

runtimes.sort()
avg = sum(runtimes) / len(runtimes)
print(f"{key} avg runtime: {avg}")
print(f"{key} median runtime: {runtimes[2]}")

out_dict = {}
out_dict['avg'] = avg
out_dict['median'] = runtimes[2]
out_dict['runtimes'] = runtimes
fp = open(f"{home}/duck_baselines2/{key}.json", "w")
json.dump(out_dict, fp, indent=4)
