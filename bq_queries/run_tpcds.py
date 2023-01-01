import json
import numpy as np
import time
from google.cloud import bigquery
from argparse import ArgumentParser

parser = ArgumentParser(description="Run BigQuery queries")
parser.add_argument("--outfile", default="bigquery_baseline.json", help="Outfile for results")
parser.add_argument("--batch", action="store_true", help="Batch queries")
parser.add_argument("--dry_run", action="store_true", help="Dry run in job config")
args = parser.parse_args()

client = bigquery.Client()
job_config = bigquery.QueryJobConfig(
        use_query_cache=False,
)

# batch doesn't matter if its dry_run
if args.batch:
    job_config = bigquery.QueryJobConfig(
            use_query_cache=False,
            priority=bigquery.QueryPriority.BATCH,
    )
if args.dry_run:
    job_config = bigquery.QueryJobConfig(
            use_query_cache=False,
            dry_run=True,
    )

queries = {}
for i in range(1, 100):
    index = str(i)
    if i < 10:
        index = f"0{index}"
    fname = f"{index}.sql"
    f = open(fname)
    qry = "".join(f.readlines())
    queries[index] = qry

print("starting queries")
start = time.time()
jobs = {index: client.query(q, job_config=job_config) for index, q in queries.items()}

# blocking loop to wait for jobs to finish
while True:
    dones = [job.done() for _, job in jobs.items()]
    if all(dones):
        break
    time.sleep(0.01)
end = time.time()
runtime = end - start
print(f"Jobs done: {runtime} seconds wall clock")

output = {}
for index, job in jobs.items():
    info = {}
    info['bytes'] = job.total_bytes_billed
    info['time'] = (job.ended - job.started).total_seconds()
    print(f"{index}: {info}")
    output[index] = info

with open(args.outfile, "w") as f:
    json.dump(output, f, indent=4)

