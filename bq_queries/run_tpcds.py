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

# web_sales
# keys = ["01", "03", "06", "07", "08", "09", "13", "15", "16", "17", "18", "19",
#      "20", "21", "22", "24", "25", "26", "27", "28", "29", "30", "32", "34",
#      "36", "37", "39", "40", "41", "42", "43", "44", "46", "47", "48", "50",
#      "52", "53", "55", "57", "59", "61", "63", "64", "65", "67", "68", "70",
#      "72", "73", "79", "81", "82", "83", "84", "88", "89", "91", "93", "96",
#      "97", "98", "99"]
# rest besides web_sales
# keys = ['02', '04', '05', '10', '11', '12', '14', '23', '31', '33', '35', '38',
#         '45', '49', '51', '54', '56', '58', '60', '62', '66', '69', '71', '74',
#         '75', '76', '77', '78', '80', '85', '86', '87', '90', '92', '94', '95']

for i in range(1, 100):
# for index in keys:
    # index = str(i)
    # if i < 10:
    #     index = f"0{index}"
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

