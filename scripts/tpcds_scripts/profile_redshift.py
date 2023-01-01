import os
from jproperties import Properties
import redshift_connector
import time
import json
import sys

if len(sys.argv) < 3:
    print("not enough args")
    exit(0)

start_ind = int(sys.argv[1])
end_ind = int(sys.argv[2])
# queries = [3, 12, 13, 15, 19, 20, 21, 22, 23, 26, 27, 28, 31, 34, 36, 37, 38,
#         40, 42, 43, 46, 48, 49, 52, 53, 55, 60, 63, 66, 68, 70, 71, 73, 74, 77,
#         79, 82, 84, 86, 87, 88, 89, 90, 91, 93, 96, 98]

queries = [x for x in range(start_ind,end_ind)]

config = Properties()
home = os.path.expanduser("~")
output = {}
with open(f"{home}/arachneDB/config/config.properties", "rb") as f:
    config.load(f)

conn = redshift_connector.connect(
    host='arachne-cluster.cm5xisyashnz.us-east-2.redshift.amazonaws.com',
    database='dev',
    user=config.get('user').data,
    password=config.get('password').data
)
cursor = conn.cursor()

already_run = {
    '50': 373.3095877170563,
    '51': 423.13286113739014,
    '52': 74.36963558197021,
    '53': 77.1588339805603,
    '54': 121.76319169998169,
    '75': 594.673903465271,
    '76': 211.40479159355164,
    '77': 494.828027009964
}

for num in queries:
    qry_str = str(num) 
    if num < 10:
        qry_str = "0" + qry_str

    if (num >= 50 and num <= 54) or (num >=75 and num <= 77):
        output[qry_str] = already_run[qry_str]
        print(f"already ran qry {qry_str}: {output[qry_str]}")
        continue
    try:
        fname = f"{home}/arachneDB/redshift_queries/{qry_str}.sql"
        f = open(fname)
        qry = "".join(f.readlines())
        print(f"executing qry {qry_str}")
        start = time.time()
        cursor.execute(qry)
        end = time.time()
        runtime = end - start
        print(f"finished qry {qry_str}: {runtime}")
        output[qry_str] = runtime
    except Exception as e:
        print(e)
        output[qry_str] = -1
        continue

cursor.close()
conn.close()

with open(f"{home}/arachneDB/out/redshift_times_{start_ind}_{end_ind}.json", "w") as fp:
    json.dump(output, fp)
