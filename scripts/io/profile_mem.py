import duckdb
import shutil
import os
import sys
import time

key = sys.argv[1]
print(f"profiling disk usage {key}")

home = os.path.expanduser("~")
os.chdir(f"/mnt/disks/tpcds/parquet")

con = duckdb.connect(f"/mnt/disks/tpcds/disk/dbs/{key}.db")
f = open(f"{home}/arachneDB/p_queries/{key}.sql")
qry = "".join(f.readlines())

start = time.time()
con.execute(qry)
runtime = time.time() - start
pid = os.getpid()
shutil.copy2(f"/proc/{pid}/io", f"{home}/arachneDB/disk_results/{key}.io")
print(f"{key}: {runtime}")
