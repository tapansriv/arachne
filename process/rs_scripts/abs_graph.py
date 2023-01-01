import matplotlib.pyplot as plt
import numpy as np
import json
import sys
import os


'''
Graph data as a bar chart 

arr is the array of data
labels
colors
keys
title is the title of the graph
outfile is the file to write the final image to
'''
def graph_runtime(arr, labels, colors, keys, title, outfile):
    num_qs, num_cols = arr.shape
    ind = np.arange(num_qs)
    width = 0.2
    # arachne_color='#a22a2b'
    # bq_color='#357e99'
    # rs_color='#357e99'

    fig, ax = plt.subplots()

    def autolabel(rects):
        """
        Attach a text label above each bar displaying its height
        """
        for rect in rects:
            height = rect.get_height()
            ax.text(rect.get_x() + rect.get_width()/2., 1.01*height,
                    '{:.2f}'.format(height),
                    ha='center', va='bottom', fontsize=6)
    
    for i in range(num_cols):
        rects = ax.bar(ind + i*width, arr[:,i], width, color=colors[i], label=labels[i])
        # autolabel(rects)
    
    # add some text for labels, title and axes ticks
    ax.set_ylabel("Cost ($)")
    ax.set_xticks(ind + width/3)
    ax.set_title(title)
    ax.set_xlabel('Query Number')

    ax.set_xticklabels(keys)
    ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
    
    figure = plt.gcf()
    figure.set_size_inches(16, 9)
    plt.savefig(outfile, dpi=100, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
    plt.close()

dir_ = sys.argv[1]
home = os.path.expanduser("~")
os.chdir(f"{home}/arachneDB/{dir_}/worked")
f = open("processed_data.json")
raw = json.load(f)

keys = []

arachne_costs = []
bq_costs = []
rs_costs = []
cheapest_baseline_costs = []

for k in raw:
    keys.append(k)
    perf = raw[k]
    arachne_cost = perf["arachne_cost"]
    if arachne_cost == -1:
        arachne_cost = perf["rs_cost"]
    rs_cost = perf["rs_cost"]
    bq_cost = perf["bq_cost"]
    print(f"{k}: {arachne_cost}, {rs_cost}, {bq_cost}")
    cheapest_baseline = min(bq_cost, rs_cost)
    
    arachne_costs.append(arachne_cost)
    bq_costs.append(bq_cost)
    rs_costs.append(rs_cost)
    cheapest_baseline_costs.append(cheapest_baseline)

run_costs = np.array([bq_costs, rs_costs, arachne_costs]).T
a_bq = np.array([bq_costs, arachne_costs]).T
a_rs = np.array([rs_costs, arachne_costs]).T
cheap_comp = np.array([cheapest_baseline_costs, arachne_costs]).T

arachne_color = "#ecae17"
bq_color = "#455984"
rs_color = "#a12721"

labels = ["BigQuery", "Redshift", "Arachne"]
title = "Arachne, BigQuery, and Redshift costs per query ($)"
outfile = "raw_all.png"
colors = [bq_color, rs_color, arachne_color]
graph_runtime(run_costs, labels, colors, keys, title, outfile)

labels = ["Cheapest Baseline", "Arachne"]
title = "Arachne versus Cheapest Baseline cost per query ($)"
outfile = "raw_cheap.png"
graph_runtime(cheap_comp, labels, colors, keys, title, outfile)

labels = ["BigQuery", "Arachne"]
title = "Arachne versus BigQuery cost per query ($)"
outfile = "raw_a_bq.png"
colors = [bq_color, arachne_color]
graph_runtime(a_bq, labels, colors, keys, title, outfile)

labels = ["Redshift", "Arachne"]
title = "Arachne versus Redshift cost per query ($)"
outfile = "raw_a_rs.png"
colors = [rs_color, arachne_color]
graph_runtime(a_rs, labels, colors, keys, title, outfile)


