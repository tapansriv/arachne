import json
import numpy as np
import time
from google.cloud import bigquery
import sys

sf = sys.argv[1]

client = bigquery.Client()
job_config = bigquery.QueryJobConfig(use_query_cache=False)

def dummy_callback(future):
    global jobs_done
    jobs_done[future.job_id] = True

queries = {}

to_test = ["bi-11", "nbr"]
for fname in to_test:
    f = open(f"../queries/bq_queries/{fname}.sql")
    qry = "".join(f.readlines())
    queries[fname] = qry
print('hi')

jobs = {index: client.query(q, job_config=job_config) for index, q in queries.items()}
jobs_done = {job.job_id: False for job in jobs.values()}
[job.add_done_callback(dummy_callback) for job in jobs.values()]

# blocking loop to wait for jobs to finish
while not (np.all(list(jobs_done.values()))):
    print('waiting for jobs to finish ... sleeping for 1s')
    time.sleep(1)
print('all jobs done, do your stuff')

output = {}
for index, job in jobs.items():
    info = {}
    info['bytes'] = job.total_bytes_billed
    info['time'] = (job.ended - job.started).total_seconds()
    print(info)
    output[index] = info

out_file = f"../baseline/bigquery_baseline_ldbc_sf{sf}.json"
with open(out_file, "w") as f:
    json.dump(output, f, indent=4)

