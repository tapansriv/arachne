import duckdb
import sys

sf = sys.argv[1]

qry = "".join(open('tapan_schema.sql').readlines())

con = duckdb.connect(f"ldbc-sf{sf}.db")
con.execute(f"pragma memory_limit='57g'")
con.execute(qry)
