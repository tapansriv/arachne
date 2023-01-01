import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys
from argparse import ArgumentParser

parser = ArgumentParser(description="Run inter-query analysis")

parser.add_argument("--duck", action="store_true", help="Use DuckDB in Analysis")
parser.add_argument("--cluster_size", type=int, default=1, help="Number of Redshift nodes in cluster")
parser.add_argument("--move", action="store_true", help="Max over all non-staying plans. If unset, will only consider multi-cloud plans")
parser.add_argument("--only_max", action="store_true", help="Print only max value")
parser.add_argument("--no_calcite", action="store_true", help="Only look at non-calcite plans")
parser.add_argument("start_loc", choices=['aws', 'gcp'], help="Where data begins")
parser.add_argument("path", help="Path with data for analysis")
args = parser.parse_args()

fname = "noduck"
duck_txt = ""
if args.duck == "duck":
    fname = "duck"
    duck_txt = "_1.48"

print(fname)
rs_cost = int(args.cluster_size) * 1.086

data = None
if args.start_loc == "gcp":
    if args.no_calcite:
        data = pd.read_json(f"{args.path}/outputs_NOCALCITE_{fname}_GCP_0.12_{rs_cost}_6.25{duck_txt}.json").T
    else:
        data = pd.read_json(f"{args.path}/outputs_{fname}_GCP_0.12_{rs_cost}_6.25{duck_txt}.json").T
elif args.start_loc == "aws":
    if args.no_calcite:
        data = pd.read_json(f"{args.path}/outputs_NOCALCITE_{fname}_AWS_0.09_{rs_cost}_6.25{duck_txt}.json").T
    else:
        data = pd.read_json(f"{args.path}/outputs_{fname}_AWS_0.09_{rs_cost}_6.25{duck_txt}.json").T
else:
    raise ValueError("Illegal start location: {args.start_loc}")

if "parquet" in args.path:
    cols = list(data.index)
    if "all" in cols:
        cols.remove("all")
    data = data.loc[cols]

num_multi = len(data[data["multi_cloud_plan"] == "multi"])
num_stay = len(data[data["multi_cloud_plan"] == "stay"])
num_move = len(data[data["multi_cloud_plan"] == "move"])

print(f"MULTI: {num_multi}, MOVE: {num_move}, STAY: {num_stay}")

if args.move:
    data = data[data["multi_cloud_plan"] != "stay"]
else:
    data = data[data["multi_cloud_plan"] == "multi"]
# print(data)


if not args.only_max:
    data["speedup"] = data["baseline_runtime"] - data["arachne_runtime"] 
    # print(data[["percent_diff", "speedup", "arachne_runtime", "baseline_runtime"]])

    data["percent_diff"] = data.percent_diff.astype(float)
    print(data[data["speedup"] > 0][["speedup", "percent_diff"]])
    print('------')
    print(data.loc[data[data["speedup"] > 0]["percent_diff"].idxmax()]["percent_diff"].max())
    print('------')




# print(data["percent_diff"].max())
