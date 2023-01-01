import os
import time
import sys
from jproperties import Properties
import redshift_connector

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

orig_path = f"{basepath}/{key}.sql"
f = open(orig_path)
q = "".join(f.readlines())
cursor.execute("EXPLAIN " + q)
res = cursor.fetchall()
outfile = f"{outpath}/{key}_orig"
fp = open(outfile, "w")
for t in res:
    fp.write(t[0] + "\n")

for cut in range(1, num+1):
    '''
    create tables
    '''
    path = f"{basepath}/{key}_{cut}.sql"
    print(path)
    f = open(path)
    q_all = "".join(f.readlines())
    qs = q_all.split(";")
    qs = [i for i in qs if i.strip()]
    try:
        runtime = 0
        for i, q in enumerate(qs):
            q1 = q.strip()
            if not q1:
                continue
            if q1.startswith("CREATE TABLE"):
                start = time.time()
                cursor.execute(q1)
                runtime += (time.time() - start)

            cursor.execute("EXPLAIN " + q1)
            res = cursor.fetchall()
            outfile = f"{outpath}/{key}_{cut}_{i+1}"
            fp = open(outfile, "w")
            for t in res:
                fp.write(t[0] + "\n")
        print(f"{cut} time: {runtime}")
    except Exception as e:
        n = len(qs) - 1
        for i in range(n):
            tbl = f"rs_table_{key}_{i}"
            cursor.execute(f"DROP TABLE {tbl}")
        cursor.close()
        conn.close()
        raise e
    else: 
        n = len(qs) - 1
        for i in range(n):
            tbl = f"rs_table_{key}_{i}"
            cursor.execute(f"DROP TABLE {tbl}")

cursor.close()
conn.close()

