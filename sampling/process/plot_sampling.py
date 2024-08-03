import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import os

home = os.path.expanduser("~")

data_15 = pd.read_json("baseline_0.15/outputs_noduck_0.12_1.086_5.json").T
data_25 = pd.read_json("baseline_0.25/outputs_noduck_0.12_1.086_5.json").T
data_50 = pd.read_json("baseline_0.5/outputs_noduck_0.12_1.086_5.json").T
data_100 = pd.read_json(
        f"{home}/arachne/inter_query_analysis/parquet_1000/real_data_rs1/outputs_noduck_0.12_1.086_5.json").T

foo1 = data_15["profiling_cost"] / data_100["profiling_cost"]
foo2 = data_25["profiling_cost"] / data_100["profiling_cost"]
foo3 = data_50["profiling_cost"] / data_100["profiling_cost"]
x = pd.concat([foo1, foo2, foo3], axis=1, keys=["0.15", "0.25", "0.50"])
print(x)

