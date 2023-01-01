'''
Compare costs for queries between redshift and bigquery; group by which queries
are cheaper in which DB
'''

import json
import os
import math
from argparse import ArgumentParser
from funcs import compare, bq_sort, rs_sort

parser = ArgumentParser(description="See what queries are cheaper in which database")
parser.add_argument("--verbose", action="store_true", help="more prints")
parser.add_argument("--cluster_size", type=int, default=1, 
                    help="Number of Redshift nodes")
parser.add_argument("tool", choices=["compare", "bq", "rs"], help="What analysis do you want to do?")
parser.add_argument("path", help="Path where profiles live")
args = parser.parse_args()

os.chdir(args.path)

BQ_COST = 6.25 # $/TB
RS_COST = 1.086 * args.cluster_size # $/HR


if args.tool == "compare":
    compare(args, BQ_COST, RS_COST)
elif args.tool == "bq":
    bq_sort(args, BQ_COST)
elif args.tool == "rs":
    rs_sort(args, RS_COST)

