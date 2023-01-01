import duckdb
import time
import sys

key = sys.argv[1]

con = duckdb.connect(f"/mnt/disks/tpcds/dbs/{key}")
f = open(f"{key}.sql")
qry = "".join(f.readlines())

start = time.time()
con.execute(qry)
r = time.time() - start
print(f"{key}: {r}")
with open(f"07.times", "a") as fp:
    fp.write(f"{key}: {r}\n")
