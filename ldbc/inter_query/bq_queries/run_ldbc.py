import json
import glob
import numpy as np
import time
from google.cloud import bigquery

client = bigquery.Client()
job_config = bigquery.QueryJobConfig(
        use_query_cache=False,
        # priority=bigquery.QueryPriority.BATCH,
        # dry_run=True,
)

def dummy_callback(future):
    global jobs_done
    jobs_done[future.job_id] = True

queries = {}


files = glob.glob("*.sql")
for fname in files:
    key = fname[0:-4]
    print(key)
    f = open(fname)
    qry = "".join(f.readlines())
    queries[key] = qry

print(f"starting queries {len(queries)}")
start = time.time()
jobs = {index: client.query(q, job_config=job_config) for index, q in queries.items()}
# jobs_done = {job.job_id: False for job in jobs.values()}
# [job.add_done_callback(dummy_callback) for job in jobs.values()]

# blocking loop to wait for jobs to finish
# while not (np.all(list(jobs_done.values()))):
while True:
    dones = [job.done() for _, job in jobs.items()]
    if all(dones):
        break
    time.sleep(0.01)
end = time.time()
runtime = end - start
print(f"Jobs done: {runtime} seconds wall clock")

out_file = "bigquery_ldbc_internal2.json"
output = {}

try:
    with open(out_file) as f:
        output = json.load(f)
except FileNotFoundError:
    pass

for index, job in jobs.items():
    info = {}
    info['bytes'] = job.total_bytes_billed
    info['time'] = (job.ended - job.started).total_seconds()
    print(f"{index}: {info}")
    output[index] = info

with open(out_file, "w") as f:
    json.dump(output, f, indent=4)

