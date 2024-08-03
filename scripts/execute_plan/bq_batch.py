import json
import os
from argparse import ArgumentParser
import glob
import numpy as np
import time
from google.cloud import bigquery

parser = ArgumentParser(description="Batch execute queries in BigQuery")
parser.add_argument("--outfile", default="out_query.txt", help="outfile")
parser.add_argument("start_loc", choices=['aws', 'gcp'], help="start location")
parser.add_argument("path", help="path to profiles")
args = parser.parse_args()
print(args)
print(args.path)

client = bigquery.Client()
job_config = bigquery.QueryJobConfig(
        use_query_cache=False,
        priority=bigquery.QueryPriority.BATCH,
)

home = os.path.expanduser("~")
output = {}
query_keys = []
loc = args.start_loc.upper()
egress = 0.12
if loc == "AWS":
    egress = 0.09

fname = f"outputs_noduck_{loc}_{egress}_4.344_6.25.json"
exec_data_path = os.path.join(args.path, fname)
profile = json.load(open(exec_data_path))
if loc == "GCP":
    query_keys = profile['all']['exec_details']['stayed_queries']
elif loc == "AWS":
    query_keys = profile['all']['exec_details']['moved_queries']
else:
    raise ValueError()

query_path = f"{home}/arachne/custom_workload/bq_queries/"
queries = {}
for key in query_keys:
    qpath = os.path.join(query_path, key + '.sql')
    f = open(qpath)
    qry = "".join(f.readlines())
    queries[key] = qry
print(f"starting queries {len(queries)}")
start = time.time()

jobs = {index: client.query(q, job_config=job_config) for index, q in queries.items()}
while True:
    dones = [job.done() for _, job in jobs.items()]
    if all(dones):
        break
    time.sleep(0.01)
end = time.time()
runtime = end - start
print(f"Jobs done: {runtime} seconds wall clock")

for index, job in jobs.items():
    info = {}
    info['bytes'] = job.total_bytes_billed
    info['time'] = (job.ended - job.started).total_seconds()
    print(f"{index}: {info}")
    output[index] = info

output['tot_time'] = runtime
with open(args.outfile, "w") as f:
    json.dump(output, f, indent=4, sort_keys=True)

