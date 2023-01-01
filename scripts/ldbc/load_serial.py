tables = ["person", "person_tag", "knows", "likes", "person_university",
        "person_company", "organisation", "place", "tag", "tagclass", "message",
        "message_tag", "forum", "forum_person", "forum_tag"]
        
assert len(tables) == 15

import os
import time
import json
from jproperties import Properties
import boto3
from argparse import ArgumentParser

parser = ArgumentParser(description="Load tables into Redshift")

# parser.add_argument("size", choices=["1", "2"], help="Data size")
parser.add_argument("cid", help="cluster name")
args = parser.parse_args()

bucket = "ldbc"

config = Properties()
home = os.path.expanduser("~")
with open(f"{home}/arachneDB/config/config.properties", "rb") as f:
    config.load(f)


cid = args.cid

user = config.get('user').data
psswd = config.get('password').data
access_key = config.get('access_key_id').data
secret_key = config.get('secret_access_key').data

client = boto3.client('redshift-data')
load_times = {t: 0 for t in tables}

total_start = time.time()

fname = f"schema.sql"
f = open(fname)
qry = "".join(f.readlines())
response = client.execute_statement(
    ClusterIdentifier=cid,
    Database='dev',
    DbUser=user,
    Sql = qry
)
jobId = response['Id']
is_done = False

while not is_done:
    time.sleep(0.01) # sleep 0.5 seconds
    response = client.describe_statement(
                Id=jobId
            )
    if response['Status'] == "FINISHED":
        is_done = True

    elif response['Status'] in ["ABORTED", "FAILED"]:
        print("failed create table")
        print(response)
        raise ValueError()

print("completed making tables")

for tbl in tables:
    start = time.time()
    auth = f"'aws_access_key_id={access_key};aws_secret_access_key={secret_key}' FORMAT AS PARQUET;"
    load = f"COPY {tbl} FROM 's3://{bucket}/{tbl}.parquet' CREDENTIALS " + auth;
    if tbl == "tag":
        load = f"COPY \"{tbl}\" FROM 's3://{bucket}/{tbl}.parquet' CREDENTIALS " + auth;

    print(f"Loading {tbl} from bucket: {bucket}")
    response = client.execute_statement(
        ClusterIdentifier=cid,
        Database='dev',
        DbUser=user,
        Sql = load
    )
    jobId = response['Id']
    is_done = False

    while not is_done:
        time.sleep(0.01) # sleep 0.5 seconds
        response = client.describe_statement(
                    Id=jobId
                )
        if response['Status'] == "FINISHED":
            end = time.time()
            runtime = end - start
            load_times[tbl] += runtime
            is_done = True
            print(f"finished loading {tbl}: {runtime}")

        elif response['Status'] in ["ABORTED", "FAILED"]:
            print("failed load")
            print(response)
            raise ValueError()

total_end = time.time()
with open(f"{cid}.json", 'w') as fp:
    json.dump(load_times, fp, indent=4, sort_keys=True)

runtime = total_end - total_start
print(f"Took {runtime} seconds in total")
print(runtime, file=open(f"{cid}_total_load_time.txt", "w"))
