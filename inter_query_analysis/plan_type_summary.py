import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys
from argparse import ArgumentParser

parser = ArgumentParser(description="Graph cost vs. runtime")
parser.add_argument("--duck", action="store_true", help="Use DuckDB in Analysis")
parser.add_argument("--aws", action="store_true", help="Egress cost")
parser.add_argument("--legend", action="store_true", help="Print legend flag")

parser.add_argument("path", help="Path with data for analysis")
parser.add_argument("scale", help="Name of benchark")
parser.add_argument("cluster_size", help="Where data begins")
args = parser.parse_args()

dir_ = args.path
SF = args.scale # scale factor
CS = args.cluster_size # cluster size
start = "GCP"
egress = 0.12
if args.aws:
    start = "AWS"
    egress = 0.09


fname = "noduck"
duck_txt = ""
if args.duck:
    fname = "duck"
    duck_txt = "_1.48"

print(fname)
rs_cost = int(CS) * 1.086
f = open(f"{dir_}/outputs_{fname}_{start}_{egress}_{rs_cost}_6.25{duck_txt}.json")
data = pd.read_json(f"{dir_}/outputs_{fname}_{start}_{egress}_{rs_cost}_6.25{duck_txt}.json").T
num_mlti = len(data[data["multi_cloud_plan"] == "multi"])
num_move = len(data[data["multi_cloud_plan"] == "move"])
num_stay = len(data[data["multi_cloud_plan"] == "stay"])

print(f"Multi: {num_mlti}")
print(f"Move: {num_move}")
print(f"Stay: {num_stay}")

