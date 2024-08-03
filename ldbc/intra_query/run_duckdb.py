import duckdb
import os
import sys
import time
import json

fname = sys.argv[1]
sf = sys.argv[2]

calcite = False
qfile = f"queries/p_queries/{fname}.sql" 
if len(sys.argv) > 3:
    qfile = f"queries/c_queries/{fname}.sql" 
    calcite = True 

print(qfile)
print(calcite)
f = open(qfile)
if not calcite:
    os.chdir(f"/mnt/disks/ldbc/parquet")

qry = "".join(f.readlines())

con = duckdb.connect("/mnt/disks/ldbc/dbs/ldbc.db")
con.execute(f"pragma memory_limit='185g'")
print(f"connected: starting query {fname}")

start = time.time()
res = con.execute(qry)
end = time.time()

# r = res.fetchall()
# print(r)

runtime = end - start
print(f"Query {fname} took {runtime} seconds")

outfile = f"/home/tapansriv/arachne/ldbc/baseline/duck_baseline_ldbc_sf{sf}.json"
if calcite:
    outfile = f"/home/tapansriv/arachne/ldbc/baseline/duck_c_baseline_ldbc_sf{sf}.json"

data = None
try:
    with open(outfile) as fp:
        data = json.load(fp)
except:
    data = {}

data[fname] = runtime

with open(outfile, 'w') as fp:
    json.dump(data, fp, indent=4)
