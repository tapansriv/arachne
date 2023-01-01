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
plot_data = data[data["multi_cloud_plan"] == "multi"]
print(plot_data)
a_runtime, a_cost = plot_data["arachne_runtime"], plot_data["arachne"]
bq_runtime, bq_cost = plot_data["bq_baseline_runtime"], plot_data["bq"]

assert len(a_runtime) == len(bq_runtime)
a_runtime = (a_runtime / 3600)
bq_runtime = (bq_runtime / 3600)
print(a_runtime[0])
# for i in range(len(a_runtime)):
#     a_runtime[i] = (a_runtime[i] / 3600)
#     bq_runtime[i] = (bq_runtime[i] / 3600)

arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

font = {'size' : 15}
plt.rc('font', **font)

fig = plt.figure(figsize=(6.5,3.5))
ax = fig.subplots()
# ax.ticklabel_format(axis='x', style='sci', scilimits=(0,0), useMathText=True)

## Scatter plot with text labels
'''
ax.scatter(plot_data["arachne_runtime"], plot_data["arachne"], c=arachne_color, 
        label="Arachne")
ax.scatter(plot_data["bq_baseline_runtime"], plot_data["bq"], c=bq_color,
        label="BigQuery")

for i in range(len(plot_data)):
    row = plot_data.iloc[i]
    ax.annotate(row.name, (row["arachne_runtime"], row["arachne"]))
    ax.annotate(row.name, (row["bq_baseline_runtime"], row["bq"]))
'''

## Scatter plot, lines between points for same dataset, no text labels
for i in range(len(plot_data["arachne"])):
    xs = [a_runtime[i], bq_runtime[i]]
    ys = [a_cost[i], bq_cost[i]]
    print(xs)
    print(ys)
    ax.plot(xs, ys, c='k', zorder=1)

# l = f"Arachne: BigQuery, Redshift (GA{CS})"
l = f"Arachne"
# ax.scatter(plot_data["arachne_runtime"], plot_data["arachne"], c=arachne_color, 
#         label=  l, zorder=2, marker='D', s=130)
# ax.scatter(plot_data["bq_baseline_runtime"], plot_data["bq"], c=bq_color,
#         label="BigQuery", zorder=2, s=130)
ax.scatter(a_runtime, plot_data["arachne"], c=arachne_color, 
        label=  l, zorder=2, marker='D', s=130)
ax.scatter(bq_runtime, plot_data["bq"], c=bq_color,
        label="BigQuery", zorder=2, s=130)

# for i in range(len(plot_data)):
print(len(plot_data))
ds = [3, 16, 22]
rows = [1, 2, 5]
for i in range(3):
    row = plot_data.iloc[rows[i]]
    txt = f"Dataset {ds[i]}"
    # ax.annotate(row.name, (row["arachne_runtime"]/3600, row["arachne"]))
    ax.annotate(txt, (row["bq_baseline_runtime"]/3600, row["bq"]))

plt.xlabel("Runtime (hrs)")
plt.ylabel("Cost ($)")
if SF == "1000":
    # plt.xlim([6500, 38000])
    plt.xlim([1.8, 10.5])
    plt.ylim([0, 103])
elif SF == "2000":
    # plt.xlim([9000, 95000])
    plt.xlim([2.5, 26])
    plt.ylim([0, 206])

plt.legend()
# plt.legend(loc='center left', bbox_to_anchor=(1, 0.5))

# plt.show()
outfile = f"graphs/sf{SF}_cs{CS}_{fname}_runtime.png"
plt.savefig(outfile, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2',
        bbox_inches='tight')
plt.close()

