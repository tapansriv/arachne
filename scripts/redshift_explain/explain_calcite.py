import os
import time
import sys
from jproperties import Properties
import redshift_connector

if len(sys.argv) < 2:
    exit("Not enough arguments")

home = os.path.expanduser("~")
basepath = f"{home}/arachneDB/c_queries/rs"
outpath = f"{home}/arachneDB/sql_preopt/rs_c_query_plans"

key = sys.argv[1]

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
print(f"starting {key}")

orig_path = f"{basepath}/{key}.sql"
f = open(orig_path)
q = "".join(f.readlines())
cursor.execute("EXPLAIN " + q)
res = cursor.fetchall()
outfile = f"{outpath}/{key}_calcite"
fp = open(outfile, "w")
for t in res:
    fp.write(t[0] + "\n")

cursor.close()
conn.close()


