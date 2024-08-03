import matplotlib.pyplot as plt
import math
import numpy as np
import pandas as pd
import json
import os
from table_names import tpcds_names

home = os.path.expanduser("~")
os.chdir(f"{home}/arachne/sampling")

data_15 = json.load(open("baseline_0.15/outputs_noduck_0.12_1.086_5.json"))
data_25 = json.load(open("baseline_0.25/outputs_noduck_0.12_1.086_5.json"))
data_50 = json.load(open("baseline_0.5/outputs_noduck_0.12_1.086_5.json"))
data_100 = json.load(open(
        f"{home}/arachne/inter_query_analysis/parquet_1000/real_data_rs1/outputs_noduck_0.12_1.086_5.json"))

datas = [data_15, data_25, data_50, data_100]
vals = [0.15, 0.25, 0.5, 1.0]

i = 0
for i, d in enumerate(datas):
    s = vals[i]
    line = f"{s} "
    for k in tpcds_names:
        prof  = round( d[k]["profiling_cost"], 2)
        save = data_100[k]["bq"] - data_100[k]["arachne"]

        iters = "N/A"
        if save > 0:
            iters = math.ceil(prof / save)

        baseline = s * data_100[k]["profiling_cost"]
        error = abs(s - (prof / data_100[k]["profiling_cost"]))
        # error = 100 * ((baseline - prof) / baseline)
        # error = round(error, 2)
        error = int(error)

        
        line += f"& \multicolumn{{1}}{{c|}}{{{prof}}} & "
        line += f"\multicolumn{{1}}{{c|}}{{{iters}}} & "
        line += f"{error} "

    line += "\\\\ \\hline"
    print(line)


line = "Dataset "
for i in range(24):
    line += f"& \multicolumn{{3}}{{c|}}{{{i}}} "

line += f"\\\\ \\hline\\hline"
print(line)


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
