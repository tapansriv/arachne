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

parser = ArgumentParser(description="Load tables into Redshift")
parser.add_argument("--outfile", help="file to write runtime to")
parser.add_argument("--cid", help="Name of cluster")
parser.add_argument("file", help="Path to query file")
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

f = open(args.file)
qry = "".join(f.readlines())

try:
    runtime = run_one_query(cid, user, qry)

    if args.outfile:
        with open(args.outfile, 'w') as fp:
            print(runtime, file=fp)
finally:
    pass
    #pause_cluster(cid)


