import os
import glob
import sys
from jproperties import Properties
import time
import json
import boto3
from argparse import ArgumentParser
from cluster_funcs import pause_cluster, run_one_query, run_explain, FailedException, AbortedException

parser = ArgumentParser(description="Load tables into Redshift")
parser.add_argument("--cid", help="Name of cluster")
parser.add_argument("query_path", help="Where queries are stored")
args = parser.parse_args()

if args.cid:
    cid = args.cid
else:
    cid = "redshift-cluster-1"

config = Properties()
home = os.path.expanduser("~")
with open(f"{home}/arachneDB/config/config.properties", "rb") as f:
    config.load(f)

user = config.get('user').data

query_path = f"{home}/arachneDB/{args.query_path}"
rs = {}

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

 

# all keys
# std_keys = ["0" + str(i) if i < 10 else str(i) for i in range(1, 100)]

# web_sales 
# std_keys = ["01", "03", "06", "07", "08", "09", "13", "15", "16", "17", "18", "19",
#         "20", "21", "22", "24", "25", "26", "27", "28", "29", "30", "32", "34",
#         "36", "37", "39", "40", "41", "42", "43", "44", "46", "47", "48", "50",
#         "52", "53", "55", "57", "59", "61", "63", "64", "65", "67", "68", "70",
#         "72", "73", "79", "81", "82", "83", "84", "88", "89", "91", "93", "96",
#         "97", "98", "99"]

# rest besides web_sales
# std_keys = ['02', '04', '05', '10', '11', '12', '14', '23', '31', '33', '35',
#         '38', '45', '49', '51', '54', '56', '58', '60', '62', '66', '69', '71',
#         '74', '75', '76', '77', '78', '80', '85', '86', '87', '90', '92', '94',
#         '95']

# for key in std_keys: 
# use glob to get key set

for key in glob.glob(f"{query_path}/*.sql"):
# for key in ["/home/cc/arachneDB/runtime_estimation/queries/query94_9.sql"]:
    print(f"starting query {key}")
    done = False
    # f = open(f"{query_path}/{key}.sql")
    f = open(f"{key}")
    qry = "".join(f.readlines())

    qid = key.split("/")[-1][:-4]
    # qid = key
    print(qid)
    try: 
        run_explain(cid, user, qid, qry)
    except:
        print(f"failed to run {key}")
pause_cluster(cid)












