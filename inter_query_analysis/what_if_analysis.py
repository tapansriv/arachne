import matplotlib.pyplot as plt
from operator import sub
import numpy as np
import pandas as pd
import json
from argparse import ArgumentParser
from table_names import *

def sign(x: int):
    if x < 0:
        return 0
    elif x > 0:
        return 1
    else:
        return 0

parser = ArgumentParser(description="Run inter-query analysis")
parser.add_argument("--rs_cost", type=float, default=1.086, help="Redshift Hourly Cost in dollars")
parser.add_argument("--cluster_size", type=int, default=4, help="Number of Redshift nodes in cluster")
parser.add_argument("path", help="Number of Redshift nodes in cluster")
args = parser.parse_args()

dir_ = args.path
CS = args.cluster_size # cluster size
rs_cost = int(CS) * args.rs_cost
fname = "NOCALCITE_noduck"
duck_txt = ""
mmap = {'stay': 0, 'multi': 1, 'move': 2}



bqs = np.linspace(0.25, 12.5, 50)
egresses  = np.linspace(0, 0.24, 49)

rows = []
bq_data = {}
for bq_key in bqs:
    gcp_data_file = f"{dir_}/outputs_{fname}_GCP_0.12_{rs_cost}_{bq_key}{duck_txt}.json"
    df = pd.read_json(gcp_data_file)
    gcpdf = df.loc[:, df.columns != 'all'].T
    gcpdf["price"] = bq_key
    bq_data[bq_key] = gcpdf

rows = []
egress_data = {}
for e2 in egresses:
    e = round(e2, 3)
    gcp_data_file = f"{dir_}/outputs_{fname}_GCP_{e}_{rs_cost}_6.25{duck_txt}.json"
    df = pd.read_json(gcp_data_file)
    gcpdf = df.loc[:, df.columns != 'all'].T
    gcpdf["price"] = e
    egress_data[e] = gcpdf



bq_summary = {tbl: [] for tbl in tpcds_names}
eg_summary = {tbl: [] for tbl in tpcds_names}
for i in range(24):
    tbl = tpcds_names[i]
    for bq_key in bq_data.keys():
        df = bq_data[bq_key]
        tbl_data = df.loc[tbl]
        diff = tbl_data["baseline_runtime"] - tbl_data["arachne_runtime"]
        bq_summary[tbl].append((bq_key, diff, tbl_data["percent_diff"]))

    for e in egress_data.keys():
        df = egress_data[e]
        tbl_data = df.loc[tbl]
        diff = tbl_data["baseline_runtime"] - tbl_data["arachne_runtime"]
        eg_summary[tbl].append((e, diff, tbl_data["percent_diff"]))



for tbl in bq_summary:
    current_sign = sign(bq_summary[tbl][0][1])
    for bq_key, diff, save in bq_summary[tbl]:
        # if tbl == "store_sales":
        #     print(diff)
        if sign(diff) == current_sign:
            continue
        print(f"{tbl} BQ changed sign: ${bq_key}/TB;")
        current_sign = sign(diff)

for tbl in eg_summary:
    current_sign = sign(eg_summary[tbl][0][1])
    for eg_key, diff, save in eg_summary[tbl]:
        if sign(diff) == current_sign:
            continue
        print(f"{tbl} EGRESS changed sign: ${eg_key}/GB;")
        current_sign = sign(diff)





































