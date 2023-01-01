import json
import sys
import numpy as np
import time
from google.cloud import bigquery

missed = [5]
assert len(sys.argv) == 2
s = float(sys.argv[1])
assert s < 1 and s > 0
print(s)
client = bigquery.Client()
job_config = bigquery.QueryJobConfig(use_query_cache=False)

def dummy_callback(future):
    global jobs_done
    jobs_done[future.job_id] = True

queries = {}

for i in missed:
# for i in range(1, 100):
    index = str(i)
    if i < 10:
        index = f"0{index}"
    fname = f"{index}.sql"
    f = open(fname)
    qry = "".join(f.readlines())
    queries[index] = qry

print("starting jobs")
jobs = {index: client.query(q, job_config=job_config) for index, q in queries.items()}
jobs_done = {job.job_id: False for job in jobs.values()}
[job.add_done_callback(dummy_callback) for job in jobs.values()]

# blocking loop to wait for jobs to finish
while not (np.all(list(jobs_done.values()))):
    print('waiting for jobs to finish ... sleeping for 1s', flush=True)
    time.sleep(1)
print('all jobs done, do your stuff')


out_file = f"bigquery_baseline_1tb_{s}.json"
output = {}
# with open(out_file) as fp:
#     output = json.load(fp)

for index, job in jobs.items():
    info = {}
    info['bytes'] = job.total_bytes_billed
    info['time'] = (job.ended - job.started).total_seconds()
    print(info)
    output[index] = info

# with open(out_file, "w") as f:
#     json.dump(output, f, indent=4)

