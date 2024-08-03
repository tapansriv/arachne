import os
import time
import sys
import duckdb

if len(sys.argv) < 3:
    exit("Not enough arguments")

home = os.path.expanduser("~")
basepath = f"{home}/arachne/p_queries"
outpath = f"{home}/arachne/data"
os.chdir("/mnt/disks/tpcds/parquet")

key = sys.argv[1]
num = int(sys.argv[2])
val = key
if num != 0: 
    val = f"{key}_{num}"

print("starting {val}")

con = duckdb.connect(f"/mnt/disks/tpcds/dbs/{val}.db")
path = f"{basepath}/{val}.sql"
f = open(path)
q_all = "".join(f.readlines())
qs = q_all.split(";")

runtime = 0
for i, q in enumerate(qs):
    q1 = q.strip()
    if not q1:
        continue
    if not q1.startswith("CREATE TABLE"):
        continue
    print(q1)
    start = time.time()
    con.execute(q1)
    runtime += (time.time() - start)
print(f"{val} time: {runtime}")
