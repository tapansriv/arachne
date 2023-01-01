tables = ["promotion", "call_center", "catalog_page", "catalog_returns", "catalog_sales",
        "customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item",
        "reason", "ship_mode", "store", "store_returns",
        "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
        "web_sales", "web_site"]
assert len(tables) == 24

import os
import time
import json
from jproperties import Properties
import boto3
from argparse import ArgumentParser

parser = ArgumentParser(description="Load tables into Redshift")

parser.add_argument("--cid", help="Name of cluster")
parser.add_argument("size", choices=["1", "2"], help="Data size")
args = parser.parse_args()

bucket = "arachne-tpcds"
if args.size == "2":
    bucket = "arachne-tpcds-2tb"

config = Properties()
home = os.path.expanduser("~")
with open(f"{home}/arachneDB/config/config.properties", "rb") as f:
    config.load(f)


if args.cid:
    cid = args.cid
else:
    cid = "redshift-cluster-1"

print(f"loading from {bucket} into {cid}")
user = config.get('user').data
psswd = config.get('password').data
access_key = config.get('access_key_id').data
secret_key = config.get('secret_access_key').data

client = boto3.client('redshift-data')
create_jobs = {}
start = time.time()

for tbl in tables:
    fname = f"{home}/arachneDB/redshift_schema/{tbl}.sql"
    f = open(fname)
    qry = "".join(f.readlines())
    response = client.execute_statement(
        ClusterIdentifier=cid,
        Database='dev',
        DbUser=user,
        Sql = qry
    )
    create_jobs[response['Id']] = False
print(len(create_jobs.keys()))
while not all(create_jobs.values()):
    time.sleep(0.5) # sleep 0.5 seconds
    for jobId in create_jobs:
        response = client.describe_statement(
                    Id=jobId
                )
        if response['Status'] == "FINISHED":
            create_jobs[jobId] = True
        elif response['Status'] in ["ABORTED", "FAILED"]:
            print("failed create table")
            print(response)
            raise ValueError()

print("completed making tables")
load_jobs = {}
for tbl in tables:
    auth = f"'aws_access_key_id={access_key};aws_secret_access_key={secret_key}' FORMAT AS PARQUET;"
    load = f"COPY {tbl} FROM 's3://{bucket}/{tbl}.parquet' CREDENTIALS " + auth;
    print(load)
    response = client.execute_statement(
        ClusterIdentifier=cid,
        Database='dev',
        DbUser=user,
        Sql = load
    )
    load_jobs[response['Id']] = False

print("submitted loads")
while not all(load_jobs.values()):
    time.sleep(0.5) # sleep 0.5 seconds
    for jobId in load_jobs:
        if load_jobs[jobId]:
            continue
        response = client.describe_statement(
                    Id=jobId
                )
        if response['Status'] == "FINISHED":
            load_jobs[jobId] = True
            print("finished load!")
        elif response['Status'] in ["ABORTED", "FAILED"]:
            print("failed load")
            print(response)
            raise ValueError()

end = time.time()
runtime = end - start
print(f"Took {runtime} seconds")
print(runtime, file=open(f"{cid}.txt", "w"))

client = boto3.client('redshift')
response = client.pause_cluster(
    ClusterIdentifier=cid,
)
print(response)
