import matplotlib.pyplot as plt
import math
import numpy as np
import pandas as pd
import json
import os
from table_names import tpcds_names
from argparse import ArgumentParser

parser = ArgumentParser()
parser.add_argument("--no_calcite", action="store_true", help="No calcite in nums")
args = parser.parse_args()

home = os.path.expanduser("~")
os.chdir(f"{home}/arachne/sampling")

file_15 = "baseline_0.15/outputs_noduck_0.12_1.086_6.25.json"
file_25 = "baseline_0.25/outputs_noduck_0.12_1.086_6.25.json"
file_50 = "baseline_0.5/outputs_noduck_0.12_1.086_6.25.json"
file_100 = f"{home}/arachne/inter_query_analysis/parquet_1000/batch_rs1/outputs_noduck_GCP_0.12_1.086_6.25.json"

if args.no_calcite:
    file_15 = "baseline_0.15/outputs_NOCALCITE_noduck_0.12_1.086_6.25.json"
    file_25 = "baseline_0.25/outputs_NOCALCITE_noduck_0.12_1.086_6.25.json"
    file_50 = "baseline_0.5/outputs_NOCALCITE_noduck_0.12_1.086_6.25.json"
    file_100 = f"{home}/arachne/inter_query_analysis/parquet_1000/batch_rs1/outputs_NOCALCITE_noduck_GCP_0.12_1.086_6.25.json"

data_15 = json.load(open(file_15))
data_25 = json.load(open(file_25))
data_50 = json.load(open(file_50))
data_100 = json.load(open(file_100))

i = 0
for k in tpcds_names:
    prof_15 = round(data_15[k]["profiling_cost"], 2)
    prof_25 = round(data_25[k]["profiling_cost"], 2)
    prof_50 = round(data_50[k]["profiling_cost"], 2)
    prof_100 = round(data_100[k]["profiling_cost"], 2)
    save = data_100[k]["baseline_cost"] - data_100[k]["arachne"]

    iters_15 = "N/A"
    iters_25 = "N/A"
    iters_50 = "N/A"
    iters_100 = "N/A"
    if save > 0:
        iters_15 = math.ceil(prof_15 / save)
        iters_25 = math.ceil(prof_25 / save)
        iters_50 = math.ceil(prof_50 / save)
        iters_100 = math.ceil(prof_100 / save)

    # s15  = 0.15 * data_100[k]["profiling_cost"]
    # s25  = 0.25 * data_100[k]["profiling_cost"]
    # s50  = 0.50 * data_100[k]["profiling_cost"]
    # s100 = 1.0 * data_100[k]["profiling_cost"]
    errors_15  = round(abs(0.15 - (prof_15 / data_100[k]["profiling_cost"])), 2)
    errors_25  = round(abs(0.25 - (prof_25 / data_100[k]["profiling_cost"])), 2)
    errors_50  = round(abs(0.50 - (prof_50 / data_100[k]["profiling_cost"])), 2) 
    errors_100 = round(abs(1.0  - (prof_100 / data_100[k]["profiling_cost"])), 2) 

    line = f"DS-Derived {i} "
    line += f"& \\multicolumn{{1}}{{c|}}{{{prof_15}}} & \\multicolumn{{1}}{{c|}}{{{iters_15}}} & {errors_15} " 
    line += f"& \\multicolumn{{1}}{{c|}}{{{prof_25}}} & \\multicolumn{{1}}{{c|}}{{{iters_25}}} & {errors_25} " 
    line += f"& \\multicolumn{{1}}{{c|}}{{{prof_50}}} & \\multicolumn{{1}}{{c|}}{{{iters_50}}} & {errors_50} " 
    line += f"& \\multicolumn{{1}}{{c|}}{{{prof_100}}} & \\multicolumn{{1}}{{c|}}{{{iters_100}}} & {errors_100} " 
    line += f"\\\\ \\hline"
    i += 1
    print(line)


# vals = ["0.15", "0.25", "0.50", "1.0"]
# line = "Dataset "
# for s in vals:
#     line += f"& \multicolumn{{3}}{{c|}}{{C}} & \multicolumn{{3}}{{c|}}{{I}} & \multicolumn{{3}}{{c|}}{{E}} "

# line += f"\\\\ \\hline"
# print(line)


'''
\begin{table}[]
\begin{tabular}{|c|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|ccc|}
\hline

Dataset   & \multicolumn{3}{c|}{0.15}         & \multicolumn{2}{c|}{0.25}         & \multicolumn{2}{c|}{0.5}          & \multicolumn{2}{c|}{1.0}          \\ \hline
Sample Size & \multicolumn{1}{c|}{C} & \multicolumn{1}{c|}{I} & E &    & \multicolumn{1}{c|}{Cost} & Iters & \multicolumn{1}{c|}{Cost} & Iters & \multicolumn{1}{c|}{Cost} & Iters \\ \hline
0.15       & \multicolumn{1}{c|}{1} & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{3}    & 4     & \multicolumn{1}{c|}{5}    & 6     & \multicolumn{1}{c|}{7}    & 8     \\ \hline
0.25       & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
0.5        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
1.0        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
        & \multicolumn{1}{c|}{}  & \multicolumn{1}{c|}{I}      & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       & \multicolumn{1}{c|}{}     &       \\ \hline
\end{tabular}
\end{table}
'''
