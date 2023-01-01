import os
import sys
from jproperties import Properties
import time
import json
import boto3
from argparse import ArgumentParser

parser = ArgumentParser(description="Load tables into Redshift")
parser.add_argument("--cid", help="Name of cluster")
parser.add_argument("--outfile", default="out_query.txt", help="outfile")
parser.add_argument("path", help="path to profiles")
args = parser.parse_args()

query_keys = []
bq_baselines = json.load(open(os.path.join(args.path, "bigquery_baseline.json")))
rs_baselines = json.load(open(os.path.join(args.path, "rs_baseline.json")))

query_keys = bq_baselines.keys() & rs_baselines.keys()

# if loc == "GCP":
#     query_keys = profile['all']['exec_details']['moved_queries']
# elif loc == "AWS":
#     query_keys = profile['all']['exec_details']['stayed_queries']
# else:
#     raise ValueError()

if len(query_keys) == 0:
    print("Not running any Redshift queries in this plan")
    exit()

config = Properties()
home = os.path.expanduser("~")
with open(f"{home}/arachneDB/config/config.properties", "rb") as f:
    config.load(f)

if args.cid:
    cid = args.cid
else:
    cid = "redshift-cluster-1"
user = config.get('user').data

query_path = f"{home}/arachneDB/custom_workload/redshift_queries/"

queries_text = []
for q in query_keys: 
    qpath = os.path.join(query_path, q + ".sql")
    f = open(qpath)
    qry = "".join(f.readlines())
    queries_text.append(qry)
    f.close()

assert len(query_keys) == len(queries_text)
print(len(query_keys))




try:
    client = boto3.client('redshift-data')
    print("disable cache")
    disable_query_cache = "SET enable_result_cache_for_session TO OFF"
    response = client.execute_statement(
        ClusterIdentifier=cid,
        Database='dev',
        DbUser=user,
        Sql = disable_query_cache
    )
    jobId = response['Id']
    while True:
        time.sleep(0.01)
        response = client.describe_statement(Id=jobId)
        if response['Status'] == "FINISHED":
            break
        elif response['Status'] in ["ABORTED", "FAILED"]:
            print(response)
            raise ValueError()

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
    print(runtime, file=open(args.outfile, "w"))
finally:
    pass
    # if args.cid != "rs4-1tb-2":
    #     client = boto3.client('redshift')
    #     response = client.pause_cluster(
    #         ClusterIdentifier=cid,
    #     )
    #     print(response)












