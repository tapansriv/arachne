import os
import time
import sys
import duckdb

if len(sys.argv) < 2:
    exit("Not enough arguments")

home = os.path.expanduser("~")
basepath = f"{home}/arachne/p_queries"
outpath = f"{home}/arachne/data"
os.chdir("/mnt/disks/tpcds/parquet")

key = sys.argv[1]
num = 0
for i in range(4, 0, -1):
    fname = f"{basepath}/{key}_{i}.sql"
    if os.path.exists(fname):
        num = i
        break

print(f"starting {key}, {num}")
for cut in range(1, num+1):
    try:
        dbname = f"/mnt/disks/tpcds/dbs/{key}_{cut}.db"
        con = duckdb.connect(dbname)
        path = f"{basepath}/{key}_{cut}.sql"
        print(dbname)
        print(path)
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
            start = time.time()
            con.execute(q1)
            runtime += (time.time() - start)
        print(f"{cut} time: {runtime}")
    except e: 
        print(e)
        continue
