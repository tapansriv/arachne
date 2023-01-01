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
parser.add_argument("--no_calcite", action="store_true", help="Use data without calcite profiles")

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

presentation_color = "#DFE5D2"
# plt.rcParams['axes.facecolor'] = presentation_color
# plt.rcParams['savefig.facecolor'] = presentation_color

fname = "noduck"
duck_txt = ""
if args.duck:
    fname = "duck"
    duck_txt = "_1.48"

print(fname)
rs_cost = int(CS) * 1.086
filename = f"{dir_}/outputs_{fname}_{start}_{egress}_{rs_cost}_6.25{duck_txt}.json"
if args.no_calcite:
    filename = f"{dir_}/outputs_NOCALCITE_{fname}_{start}_{egress}_{rs_cost}_6.25{duck_txt}.json"

data = pd.read_json(filename).T
plot_data = data[data["multi_cloud_plan"] == "multi"]
print(plot_data)
a_runtime, a_cost = plot_data["arachne_runtime"], plot_data["arachne"]
bq_runtime, bq_cost = plot_data["baseline_runtime"], plot_data["baseline_cost"]

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

font = {'size' : 19}
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
ax.scatter(bq_runtime, plot_data["baseline_cost"], c=bq_color,
        label="BigQuery", zorder=2, s=130)

print(len(plot_data))
# ds = [3, 16, 22]
# rows = [1, 2, 5]
# for i in range(3):
#     row = plot_data.iloc[rows[i]]
#     txt = f"Dataset {ds[i]}"
#     # ax.annotate(row.name, (row["arachne_runtime"]/3600, row["arachne"]))
#     ax.annotate(txt, (row["bq_baseline_runtime"]/3600, row["bq"]))

# rows = [2]
# for i in range(1):
#     row = plot_data.iloc[rows[i]]
#     atxt = f"${row['arachne']:.2f}"
#     btxt = f"${row['bq']:.2f}"
#     ax.annotate(atxt, (row["arachne_runtime"]/3600, row["arachne"]+2))
#     ax.annotate(btxt, (row["bq_baseline_runtime"]/3600, row["bq"]-10))

plt.xlabel("Runtime (hrs)")
plt.ylabel("Cost ($)")
if SF == "1000":
    # plt.xlim([6500, 38000])
    plt.xticks(np.arange(-1, 12, step=1))
    plt.yticks([0, 25, 50, 75, 100, 125])
    plt.xlim([0, 11.2])
    plt.ylim([0, 127])
elif SF == "2000":
    # plt.xlim([9000, 95000])
    plt.xticks(np.arange(-1, 12, step=1))
    plt.yticks([0, 50, 100, 150, 200])
    plt.xlim([0, 10.2])
    plt.ylim([0, 220])

if args.legend:
    plt.legend()
    # plt.legend(loc='center left', bbox_to_anchor=(1, 0.5))

# plt.show()
m = "ext"
if "internal" in dir_:
    m = "int"

outfile = f"graphs/sf{SF}_cs{CS}_{start}_{m}_{fname}_runtime.pdf"
if args.no_calcite:
    outfile = f"graphs/sf{SF}_cs{CS}_NOCALCITE_{start}_{m}_{fname}_runtime.pdf"
plt.savefig(outfile, edgecolor='#d5d4c2',
        bbox_inches='tight', dpi=1200)
plt.close()

