import sys
import os
import duckdb

tbl = sys.argv[1]
dir_ = sys.argv[2]
con = duckdb.connect(f"/mnt/{dir_}/dbs/{tbl}.db")

fname = f"{os.path.expanduser('~')}/duckdb/extension/tpcds/dsdgen/schema/{tbl}.sql"
print(f"create table {tbl}")
with open(fname) as f:
    qry = "".join(f.readlines())
    con.execute(qry)

