import redshift_connector
import os
import time
from jproperties import Properties
import sys

if len(sys.argv) < 2:
    exit("Not enough arguments")

home = os.path.expanduser("~")
basepath = f"{home}/arachneDB/redshift_queries"
outpath = f"{home}/arachneDB/data"

key = sys.argv[1]
num = 0
for i in range(4, 0, -1):
    fname = f"{basepath}/{key}_{i}.sql"
    if os.path.exists(fname):
        num = i
        break

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

print(f"starting {key}, {num}")
for cut in range(1, num+1):
    try:
        path = f"{basepath}/{key}_{cut}.sql"
        print(path)
        f = open(path)
        q_all = "".join(f.readlines())
        qs = q_all.split(";")

        runtime = 0
        for i, q in enumerate(qs):
            q1 = q.strip()
            if not q1:
                continue
            if not q1.startswith("CREATE TABLE"):
                continue
            start = time.time()
            cursor.execute(q1)
            runtime += (time.time() - start)
        print(f"{cut} time: {runtime}")
    except e: 
        print(e)
        continue

cursor.close()
conn.close()

