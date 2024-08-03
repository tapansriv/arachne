import os
import glob
import sys
from jproperties import Properties
import time
import json
import boto3
from argparse import ArgumentParser
from cluster_funcs import pause_cluster, run_one_query, FailedException, AbortedException

parser = ArgumentParser(description="Load tables into Redshift")
parser.add_argument("--cid", help="Name of cluster")
args = parser.parse_args()

if args.cid:
    cid = args.cid
else:
    cid = "redshift-cluster-1"

config = Properties()
home = os.path.expanduser("~")
with open(f"{home}/arachne/config/config.properties", "rb") as f:
    config.load(f)

user = config.get('user').data

std_query_path = f"{home}/arachne/redshift_queries/"
calcite_query_path = f"{home}/arachne/c_queries/rs/"
rs = {}
rs_c = {}

client = boto3.client('redshift-data')

print(f"querying against {cid}")
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

print("starting standard query baselines")
std_keys = ["0" + str(i) if i < 10 else str(i) for i in range(1, 100)]
baseline_file = f"{cid}_baseline.json"

for key in std_keys:
    print(f"starting query {key}")
    done = False
    f = open(std_query_path + key + ".sql")
    qry = "".join(f.readlines())

    try: 
        runtime = run_one_query(cid, user, qry)
        rs[key] = runtime
        print(f"Query {key}: {runtime} seconds")
    except:
        with open(baseline_file, 'w') as fp:
            json.dump(rs, fp, indent=4, sort_keys=True)
        print(f"failed to run {key}")
        print(response)
        pause_cluster(cid)
        raise
with open(baseline_file, 'w') as fp:
    json.dump(rs, fp, indent=4, sort_keys=True)



print("starting calcite query baselines")
c_keys = glob.glob(calcite_query_path + "*.sql")
c_baseline_file = f"{cid}_c_baseline.json"

for key in c_keys:
    print(f"starting query {key}")
    done = False
    f = open(key)
    qry = "".join(f.readlines())

    try: 
        runtime = run_one_query(cid, user, qry)
        c_key = key[-6:-4]
        rs_c[c_key] = runtime
        print(f"Query {key}: {runtime} seconds")
    except FailedException as e:
        print(f"Query {key} error in running calcite")
        done = True
    except AbortedException as e:
        with open(c_baseline_file, 'w') as fp:
            json.dump(rs_c, fp, indent=4, sort_keys=True)
        print(f"failed to run {key}")
        print(response)
        pause_cluster(cid)
        raise e

with open(c_baseline_file, 'w') as fp:
    json.dump(rs_c, fp, indent=4, sort_keys=True)

pause_cluster(cid)












