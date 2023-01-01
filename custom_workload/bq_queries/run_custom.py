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

out_file = "bigquery_custom.json"
output = {}

try:
    with open(out_file) as f:
        output = json.load(f)
except FileNotFoundError:
    pass

queries = {}

# files = glob.glob("7*.sql")
files = ["10a.sql", "10b.sql", "10c.sql", "11a.sql", "11b.sql", "11c.sql"]
for fname in files:
    key = fname[0:-4]
    # if key == "2b":
    #     continue
    # if key == "3b":
    #     continue
    # if key in output and output[key]['bytes']:
    #     continue

    print(key)
    f = open(fname)
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

with open(out_file, "w") as f:
    json.dump(output, f, indent=4, sort_keys=True)

