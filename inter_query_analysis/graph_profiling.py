import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys

dir_ = sys.argv[1]
# f = open(f"{dir_}/outputs.json")
# data = json.load(f)
# f.close()
data = pd.read_json(f"{dir_}/outputs.json").T
plot_data = data[data["multi_cloud_plan"] == True]
title = "Inter-Query Execution Plans on TPC-DS SF-1000"

arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

xs = [1, 10, 20, 30, 40, 50, 60]
num_qs = len(xs)
ind = np.arange(num_qs)
width = 0.18
for i in range(len(plot_data)):
    row = plot_data.iloc[i]
    title = f"Arachne Costs over Time versus Baseline; Dataset {row.name}"
    prof_costs = [row['profiling_cost'] for _ in xs]
    arachne = [row['arachne'] * x for x in xs]
    bq = [row['bq'] * x for x in xs]

    plt.rcParams['xtick.labelsize'] = 6
    plt.rcParams['ytick.labelsize'] = 8
    fig, ax = plt.subplots()

    rect1 = ax.bar(ind, prof_costs, width, color=duck_c_color, label="Profiling Cost")
    rect1a= ax.bar(ind, arachne, width, color=arachne_color, label="Arachne Cost", bottom=prof_costs)
    rect2 = ax.bar(ind + width, bq, width, color=bq_color, label="BigQuery Cost")

    # add some text for labels, title and axes ticks
    ax.set_ylabel("Cost ($)")
    ax.set_xticks(ind + width)
    ax.set_title(title)
    ax.set_xlabel("Iterations Since Profiling")
    ax.set_xticklabels(xs)
    ax.legend()
    # ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))

    # plt.show()
    outfile = f"graphs/sf1000_over_time_{row.name}.png"
    figure = plt.gcf()
    figure.set_size_inches(8, 6)
    plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
    plt.close()






