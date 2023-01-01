import os
import sys
import duckdb

if len(sys.argv) < 2:
    exit("Not enough arguments")

key = sys.argv[1]
dir_ = "c_queries/duck/"

con = duckdb.connect(f"/mnt/disks/tpcds/dbs/{key}.db")
home = os.path.expanduser("~")
os.chdir("/mnt/disks/tpcds/parquet")

basepath = f"{home}/arachneDB/{dir_}"
outpath = f"{home}/arachneDB/data"

print(f"starting {key}")
orig_path = f"{basepath}/{key}.sql"
f = open(orig_path)
qry = "".join(f.readlines())

res = con.execute("EXPLAIN " + qry)
x = res.fetchall()
outfile = f"{outpath}/{key}_calcite_1"
fp = open(outfile, "w")
fp.write(x[0][1])
