'''
WILL NOT PAUSE CLUSTER IF QUERY FAILS 
ASSUMES THIS IS AN INTERACTIVE SCRIPT SOMEWHAT
'''

import os
import glob
import sys
from jproperties import Properties
import time
import json
import boto3
from argparse import ArgumentParser
from cluster_funcs import pause_cluster, run_one_query
# CONSTS
tables = ["promotion", "call_center", "catalog_page", "catalog_returns", "catalog_sales",
        "customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item",
        "reason", "ship_mode", "store", "store_returns",
        "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
        "web_sales", "web_site"]
assert len(tables) == 24

parser = ArgumentParser(description="Load tables into Redshift")
parser.add_argument("--cid", help="Name of cluster")
args = parser.parse_args()

if args.cid:
    cid = args.cid
else:
    cid = "redshift-cluster-1"

config = Properties()
home = os.path.expanduser("~")
with open(f"{home}/arachne/config/config.properties", "rb") as f:
    config.load(f)

user = config.get('user').data


for tbl in tables:
    qry = f"SELECT COUNT(*) FROM {tbl};"
    runtime = run_one_query(cid, user, qry)



