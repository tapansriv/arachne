import redshift_connector
import os
import sys
import duckdb
from jproperties import Properties

if len(sys.argv) < 2:
    exit("Not enough arguments")

key = sys.argv[1]
orig_only = False
if len(sys.argv) == 3:
    orig_only = True

config = Properties()
home = os.path.expanduser("~")
with open(f"{home}/arachneDB/config/config.properties", "rb") as f:
    config.load(f)

conn = redshift_connector.connect(
    host='redshift-cluster-1.cm5xisyashnz.us-east-2.redshift.amazonaws.com',
    port=5439,
    database='dev',
    user=config.get('user').data,
    password=config.get('password').data
)
cursor = conn.cursor()

home = os.path.expanduser("~")
basepath = f"{home}/arachneDB/redshift_queries"
outpath = f"{home}/arachneDB/data"

num = 0
for i in range(4, 0, -1):
    fname = f"{basepath}/{key}_{i}.sql"
    if os.path.exists(fname):
        num = i
        break

print(f"starting {key}, {num}")
orig_path = f"{basepath}/{key}.sql"
f = open(orig_path)
orig_all = "".join(f.readlines())
qs = orig_all.split(";")

for i, q in enumerate(qs):
    if not q.strip():
        continue
    cursor.execute("EXPLAIN " + q)
    res = cursor.fetchall()
    outfile = f"{outpath}/{key}_orig_{i+1}"
    fp = open(outfile, "w")
    for t in res:
        fp.write(t[0])


print("finished explaining original")
if not orig_only:
    for cut in range(1, num+1):
        print(f"starting {cut}")
        path = f"{basepath}/{key}_{cut}.sql"
        f = open(path)
        q_all = "".join(f.readlines())
        qs = q_all.split(";")
        for i, q in enumerate(qs):
            if not q.strip():
                continue
            cursor.execute("EXPLAIN " + q)
            res = cursor.fetchall()
            outfile = f"{outpath}/{key}_{cut}_{i+1}"
            fp = open(outfile, "w")
            for t in res:
                fp.write(t[0])

cursor.close()
conn.close()
