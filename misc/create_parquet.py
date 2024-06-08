import sys
import os
import duckdb

tbl = sys.argv[1]
dir_ = sys.argv[2]
path = f"/mnt/{dir_}"
os.chdir(path)

con = duckdb.connect(f"/mnt/{dir_}/dbs/{tbl}.db")
con.execute("PRAGMA memory_limit='30G'")
con.execute("PRAGMA threads = 1")
# os.chdir("/mnt/disks/tpch")

qry = f"COPY {tbl} TO 'parquet/{tbl}.parquet' (FORMAT 'parquet')"
con.execute(qry)
