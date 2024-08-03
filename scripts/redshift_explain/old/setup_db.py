import redshift_connector
import os
import time
import sys
from jproperties import Properties
import duckdb

if len(sys.argv) < 3:
    exit("Not enough arguments")

home = os.path.expanduser("~")
basepath = f"{home}/arachne/redshift_queries"
outpath = f"{home}/arachne/data"

key = sys.argv[1]
num = int(sys.argv[2])
val = key
if num != 0: 
    val = f"{key}_{num}"

config = Properties()
home = os.path.expanduser("~")
with open(f"{home}/arachne/config/config.properties", "rb") as f:
    config.load(f)

conn = redshift_connector.connect(
    host='redshift-cluster-1.cm5xisyashnz.us-east-2.redshift.amazonaws.com',
    port=5439,
    database='dev',
    user=config.get('user').data,
    password=config.get('password').data
)
cursor = conn.cursor()
print("starting {val}")

path = f"{basepath}/{val}.sql"
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
    print(q1)
    start = time.time()
    cursor.execute(q1)
    runtime += (time.time() - start)
print(f"{val} time: {runtime}")
cursor.close()
conn.close()

