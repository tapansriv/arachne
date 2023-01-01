import os
import duckdb

con = duckdb.connect("tpcds.db")

path = f"{os.path.expanduser('~')}/duckdb/extension/tpcds/dsdgen/schema"
os.chdir(path)

for fname in os.listdir():
    if not os.path.isfile(fname):
        continue

    print(f"create table {fname}")
    with open(fname) as f:
        qry = "".join(f.readlines())
        con.execute(qry)

