import duckdb
import sys

sf = sys.argv[1]

con = duckdb.connect(f"ldbc-sf{sf}.db")
f1 = open("create_message.sql")
create = "".join(f1.readlines())
con.execute(create)
print("dropped message only and recreated")

f = open("load_message.sql")
qry = "".join(f.readlines())

queries = qry.split(";")

i = 0
for q in queries: 
    if not q: 
        continue
    i += 1
    con.execute(q)
    if i == 1:
        print("Added post")
    if i == 2:
        print("Added comment. finished")

