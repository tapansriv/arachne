import sys
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

parser = ArgumentParser(description="Run inter-query analysis")

parser.add_argument("--sample", type=float, choices=[0.15, 0.25, 0.5], help="Sample ratio")
parser.add_argument("--internal", action="store_true", help="Load data internally")
parser.add_argument("--dataset", choices=["ldbc", "tpcds"], help="BQ Dataset to use")
parser.add_argument("bucket", help="Redshift Hourly Cost in dollars")
args = parser.parse_args()

dataset = "tpcds"
if args.dataset:
    dataset = args.dataset

bucket = args.bucket
if args.sample:
    bucket = f"{args.bucket}/sample_{args.sample}"

for tbl in tables[dataset]:
    '''
    CREATE OR REPLACE EXTERNAL TABLE tpcds.date_dim
    OPTIONS (
      format = 'PARQUET',
      uris = ['gs://arachne_tpcds/date_dim.parquet']
    );
    '''
    '''
    LOAD DATA INTO tpcds.date_dim
    FROM FILES (
      format='PARQUET',
      uris = ['gs://arachne_tpcds/date_dim.parquet']
    )
    '''
    
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
