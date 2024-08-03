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

std_query_path = f"{home}/ldbc/queries/"
rs = {}

client = boto3.client('redshift-data')

print(f"querying against {cid}")
print("starting standard query baselines")
std_keys = glob.glob(f"{std_query_path}/*.sql")
baseline_file = f"ldbc_baseline.json"

for key in std_keys:
    print(f"starting query {key}")
    done = False
    f = open(key)
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

# pause_cluster(cid)












