import os
import time
import json
from jproperties import Properties
import boto3
from argparse import ArgumentParser

parser = ArgumentParser(description="Load tables into Redshift")

parser.add_argument("--cid", help="Name of cluster")
parser.add_argument("--outfile", default="out.txt", help="outfile")
parser.add_argument("size", choices=["1", "2"], help="Data size")
parser.add_argument("start_loc", choices=['aws', 'gcp'], help="start location")
parser.add_argument("path", help="path to profiles")
args = parser.parse_args()

bucket = "arachne-tpcds"
if args.size == "2":
    bucket = "arachne-tpcds-2tb"

loc = args.start_loc.upper()
egress = 0.12
if loc == "AWS":
    egress = 0.09

fname = f"outputs_noduck_{loc}_{egress}_4.344_6.25.json"
exec_data_path = os.path.join(args.path, fname)
profile = json.load(open(exec_data_path))

tables = []
if loc == "GCP":
    tables = profile['all']['exec_details']['moved_tables']
elif loc == "AWS":
    tables = profile['all']['exec_details']['stayed_tables']
else:
    raise ValueError()


mvmt_runtime = profile['all']['exec_details']['mvmt_runtime']
mvmt_cost = profile['all']['exec_details']['mvmt_cost']
print(f"Movement takes {mvmt_runtime} seconds and costs ${mvmt_cost}")

if len(tables) == 0:
    print("Not moving any tables in this plan")
    exit()

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
print(runtime, file=open(args.outfile, "w"))
