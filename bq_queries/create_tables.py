import json
import numpy as np
import time
import sys
from google.cloud import bigquery
from argparse import ArgumentParser

tpcds_tables = ["call_center", "catalog_page", "catalog_returns", "catalog_sales",
        "customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item",
        "promotion", "reason", "ship_mode", "store", "store_returns",
        "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
        "web_sales", "web_site"]

ldbc_tables = ["organisation", "place", "tag", "tagclass", "message",
        "message_tag", "forum", "forum_person", "forum_tag", "person",
        "person_tag", "knows", "likes", "person_university", "person_company"]

tables = {
            "tpcds": tpcds_tables,
            "ldbc":  ldbc_tables,
         }

client = bigquery.Client()
job_config = bigquery.QueryJobConfig(
        use_query_cache=False,
)

parser = ArgumentParser(description="Run inter-query analysis")
parser.add_argument("--drop", action="store_true",  help="Drop tables first")
parser.add_argument("--sample", type=float, choices=[0.15, 0.25, 0.5], help="Sample ratio")
parser.add_argument("--internal", action="store_true", help="Load data internally")
parser.add_argument("--dataset", choices=["ldbc", "tpcds"], help="BQ Dataset to use")
parser.add_argument("bucket", help="Redshift Hourly Cost in dollars")
args = parser.parse_args()

dataset = "tpcds"
if args.dataset:
    dataset = args.dataset


if args.drop:
    drop_qrys = {}
    for tbl in tables[dataset]:
        qry = "DROP TABLE {dataset}.{tbl};"
        drop_qrys[tbl] = qry

    print("dropping tables")
    jobs = {index: client.query(q, job_config=job_config) for index, q in drop_qrys.items()}
    while True:
        dones = [job.done() for _, job in jobs.items()]
        if all(dones):
            break
        time.sleep(0.01)
    print("tables dropped")
    
bucket = args.bucket
if args.sample:
    bucket = f"{args.bucket}/sample_{args.sample}"

queries = {}
for tbl in tables[dataset]:
    qry = ""
    if args.internal:
        qry = f"LOAD DATA INTO {dataset}.{tbl}\n"
        qry += '''FROM FILES (
          format = 'PARQUET',
        '''
        
        tbl_line = f"  uris = ['gs://{bucket}/{tbl}.parquet']\n"  
        if args.sample:
            tbl_line = f"  uris = ['gs://{bucket}/{tbl}_{args.sample}.parquet']\n"  

        qry += tbl_line
        qry += '''); '''
    else:
        qry = f"CREATE OR REPLACE EXTERNAL TABLE {dataset}.{tbl}\n"
        qry += '''OPTIONS (
          format = 'PARQUET',
        '''
        tbl_line = f"  uris = ['gs://{bucket}/{tbl}.parquet']\n"  
        if args.sample:
            tbl_line = f"  uris = ['gs://{bucket}/{tbl}_{args.sample}.parquet']\n"  
        qry += tbl_line
        qry += '''); '''

    print(qry)
    queries[tbl] = qry

print("creating tables")
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
print(f"Tables created: {runtime} seconds wall clock")

