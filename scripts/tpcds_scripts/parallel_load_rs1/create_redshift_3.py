import os
import time
import json
from jproperties import Properties
import redshift_connector

config = Properties()
home = os.path.expanduser("~")
with open(f"{home}/arachne/config/config.properties", "rb") as f:
    config.load(f)

tables = ["customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item", "reason",
        "ship_mode", "store", "store_returns", "time_dim", "warehouse",
        "web_page", "web_returns", "web_site"]

weird_tables = ["catalog_returns", "catalog_sales", "customer", "store_returns",
        "store_sales", "web_returns", "web_sales"]
# weird_tables = ["store_sales"]
print(len(tables))
print("redshift-cluster-1")

conn = redshift_connector.connect(
    host='redshift-cluster-1.cm5xisyashnz.us-east-2.redshift.amazonaws.com',
    port=5439,
    database='dev',
    user=config.get('user').data,
    password=config.get('password').data
)
cursor = conn.cursor()

times = {}
try:
    for tbl in tables:
        fname = f"{home}/arachne/redshift_schema/{tbl}.sql"
        # if tbl == "promotion":
        #     fname = f"{home}/arachne/redshift_schema/{tbl}2.sql"
        f = open(fname)
        qry = "".join(f.readlines())
        auth = "'arn:aws:iam::552633893236:role/service-role/AmazonRedshift-CommandsAccessRole-20220225T121207' FORMAT AS PARQUET;";
        load = f"COPY {tbl} FROM 's3://arachne-multicloud-2tb/tpcds_2tb/{tbl}.parquet' iam_role " + auth;
        if tbl in weird_tables:
            load = f"COPY {tbl} FROM 's3://arachne-multicloud-2tb/{tbl}.parquet' iam_role " + auth;

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
with open("rs1_load_times_2tb.json", "w") as fp:
    json.dump(times, fp, indent=4, sort_keys=True)

