import os
import re
import time
import json
from jproperties import Properties
import sys
import redshift_connector

config = Properties()
home = os.path.expanduser("~")
with open(f"{home}/arachneDB/config/config.properties", "rb") as f:
    config.load(f)

tables = ["promotion", "call_center", "catalog_page", "catalog_returns", "catalog_sales",
        "customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item",
        "reason", "ship_mode", "store", "store_returns",
        "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
        "web_sales", "web_site"]

assert len(sys.argv) == 3
s = float(sys.argv[1])
name = sys.argv[2]
assert s < 1 and s > 0
assert re.match("redshift-cluster-[0-9]", name)


print(len(tables))
print(name)

conn = redshift_connector.connect(
    host=f"{name}.cm5xisyashnz.us-east-2.redshift.amazonaws.com",
    port=5439,
    database='dev',
    user=config.get('user').data,
    password=config.get('password').data
)
cursor = conn.cursor()

times = {}
try:
    for tbl in tables:
        fname = f"{home}/arachneDB/redshift_schema/{tbl}.sql"
        f = open(fname)
        qry = "".join(f.readlines())
        auth = "'arn:aws:iam::552633893236:role/service-role/AmazonRedshift-CommandsAccessRole-20220225T121207' FORMAT AS PARQUET;";
        load = f"COPY {tbl} FROM 's3://arachne-transfer/{tbl}_{s}.parquet' iam_role " + auth;
        print(f"executing {tbl}")
        # print(f"{load}")
        start = time.time()
        cursor.execute(qry)
        cursor.execute(load)
        end = time.time()
        runtime = end - start
        times[tbl] = runtime

        cursor.execute(f"SELECT * FROM {tbl} limit 1")
        print(cursor.fetchall())
        print(f"finished {tbl}")
        conn.commit()
except Exception as e:
    cursor.close()
    conn.close()
    print("error: dumping existing times logged")
    print(json.dumps(times, indent=4, sort_keys=True))
    raise e


cursor.close()
conn.close()

print(times)
with open(f"rs1_load_times_1tb_{s}.json", "w") as fp:
    json.dump(times, fp, indent=4, sort_keys=True)

