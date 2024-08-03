import duckdb
import os
import sys
import time

fname = sys.argv[1]
sf = sys.argv[2]

qfile = f"queries/c_queries/{fname}.sql" 
f = open(qfile)

qry = "".join(f.readlines())

con = duckdb.connect("/mnt/disks/ldbc/dbs/ldbc.db")
con.execute(f"pragma memory_limit='185g'")
con.execute("pragma enable_profiling='json'")
profile_outfile = f"/home/tapansriv/arachne/ldbc/profiles/{fname}_{sf}.json"
con.execute(f"pragma profile_output='{profile_outfile}'")
print(f"connected: starting query {fname}")

start = time.time()
res = con.execute(qry)
end = time.time()

runtime = end - start
print(f"Query {fname} took {runtime} seconds")
