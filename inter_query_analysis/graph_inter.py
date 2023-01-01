import matplotlib.pyplot as plt
import numpy as np
import json
import sys

dir_ = sys.argv[1]
f = open(f"{dir_}/outputs.json")
data = json.load(f)
f.close()

x_labels = []
arachne = []
bq = []

for k in data:
    if data[k]["multi_cloud_plan"] == True:
        x_labels.append(k)
        arachne.append(data[k]["arachne"])
        bq.append(data[k]["bq"])

# duck = [300, 315, 400, 250]
title = "Inter-Query Execution Plans on TPC-DS SF-1000"

arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

num_qs = len(x_labels)
ind = np.arange(num_qs)
width = 0.18

plt.rcParams['xtick.labelsize'] = 6
plt.rcParams['ytick.labelsize'] = 8
fig, ax = plt.subplots()

rect1= ax.bar(ind, arachne, width, color=arachne_color, label="Arachne Cost")
rect2 = ax.bar(ind + width, bq, width, color=bq_color, label="BigQuery Cost")
# rect3 = ax.bar(ind + 2*width, duck, width, color=duck_color, label="DuckDB Cost")

# add some text for labels, title and axes ticks
ax.set_ylabel("Cost ($)")
ax.set_xticks(ind + width)
ax.set_title(title)
ax.set_xlabel("Dataset Name")
# ax.set_xlabel("Query Number")

ax.set_xticklabels(x_labels)
ax.legend()
# ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))

# plt.show()
outfile = "sf1000_inter.png"
figure = plt.gcf()
figure.set_size_inches(8, 6)
plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
plt.close()
