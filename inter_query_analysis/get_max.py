import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys

dir_ = sys.argv[1]
SF = sys.argv[2] # scale factor
CS = sys.argv[3] # cluster size
duck = sys.argv[4] # with duckdb or not

fname = "noduck"
duck_txt = ""
if duck == "duck":
    fname = "duck"
    duck_txt = "_1.48"

print(fname)
rs_cost = int(CS) * 1.086
f = open(f"{dir_}/outputs_{fname}_0.12_{rs_cost}_5{duck_txt}.json")
data = pd.read_json(f"{dir_}/outputs_{fname}_0.12_{rs_cost}_5{duck_txt}.json").T
data = data[data["multi_cloud_plan"] == "multi"]


print(data["percent_diff"])
print(data["percent_diff"].max())
