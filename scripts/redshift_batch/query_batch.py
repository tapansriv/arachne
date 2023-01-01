import os
import sys
from jproperties import Properties
import time
import json
import boto3
from argparse import ArgumentParser

parser = ArgumentParser(description="Load tables into Redshift")
parser.add_argument("--cid", help="Name of cluster")
args = parser.parse_args()

config = Properties()
home = os.path.expanduser("~")
with open(f"{home}/arachneDB/config/config.properties", "rb") as f:
    config.load(f)

if args.cid:
    cid = args.cid
else:
    cid = "redshift-cluster-1"
user = config.get('user').data

path = f"{home}/arachneDB/inter_query_analysis/parquet_1000/batch_rs4/"
std_query_path = f"{home}/arachneDB/redshift_queries/"
calcite_query_path = f"{home}/arachneDB/c_queries/rs/"

rs = json.load(open(path + "rs_baseline.json"))
rs_c = json.load(open(path + "rs_c_baseline.json"))

queries_text = []

query_keys = ["03", "06", "07", "08", "09", "13", "19", "21", "22", "27", "28","34", "36", 
              "39", "42", "43", "44", "46", "47", "48", "52", "53", "55", "59", "61", "63", 
              "65", "67", "68", "70", "73", "79", "82", "88", "89", "96", "98"]

for q in query_keys: 
    qpath = None
    if q not in rs_c:
        qpath = std_query_path + q + ".sql"
    elif rs_c[q] < rs[q]:
        qpath = calcite_query_path + q + ".sql"
    else: 
        qpath = std_query_path + q + ".sql"
    f = open(qpath)
    qry = "".join(f.readlines())
    queries_text.append(qry)
    f.close()


print(len(query_keys))
print(len(queries_text))

try:
    client = boto3.client('redshift-data')
    jobs = {}

    start = time.time()

    for qry in queries_text:
        response = client.execute_statement(
            ClusterIdentifier=cid,
            Database='dev',
            DbUser=user,
            Sql = qry
        )
        jobs[response['Id']] = False

    print(f"submitted {len(jobs.keys())} queries")
    i = 0
    while not all(jobs.values()):
        time.sleep(0.01) # sleep 0.5 seconds
        for jobId in jobs:
            if jobs[jobId]:
                continue
            response = client.describe_statement(
                        Id=jobId
            )
            if response['Status'] == "FINISHED":
                jobs[jobId] = True
                i += 1
                print(f"finished job {i}")
            elif response['Status'] in ["ABORTED", "FAILED"]:
                print("failed run queries")
                print(response)
                raise ValueError()

    end = time.time()
    runtime = end - start
    print(f"Queries took {runtime} seconds")
    print(runtime, file=open(f"{cid}_query_batch.txt", "w"))
finally:
    client = boto3.client('redshift')
    response = client.pause_cluster(
        ClusterIdentifier=cid,
    )
    print(response)












