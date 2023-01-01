import matplotlib.pyplot as plt
from operator import sub
import numpy as np
import pandas as pd
import json
from argparse import ArgumentParser

parser = ArgumentParser(description="Run inter-query analysis")
parser.add_argument("--duck", action="store_true", help="Use DuckDB in Analysis")
parser.add_argument("--legend", action="store_true", help="Print legend flag")
parser.add_argument("--rs_cost", type=float, default=1.086, help="Redshift Hourly Cost in dollars")
parser.add_argument("--cluster_size", type=int, default=1, help="Number of Redshift nodes in cluster")
parser.add_argument("scale", choices=['1000', '2000'], help="Scale factor of dataset")
parser.add_argument("start_loc", choices=['aws', 'gcp'], help="Where data begins")
parser.add_argument("path", help="Path with data for analysis")
args = parser.parse_args()


dir_ = args.path
SF = args.scale # scale factor
CS = args.cluster_size # cluster size
src = args.start_loc.upper()
duck = args.duck # with duckdb or not
rs_cost = int(CS) * args.rs_cost

fontsize = 15
markersize = 8
x = 6.5
y = 3.5

src_label = "BQ"
dest_label = f"RS-{CS}"
if src == "AWS":
    src_label = f"RS-{CS}"
    dest_label = "BQ"


fname = "noduck"
duck_txt = ""
if duck == "duck":
    fname = "duck"
    duck_txt = "_1.48"
print(fname)

bqs = np.linspace(0.25, 12.5, 50)
egresses  = np.linspace(0, 0.24, 49)
print(egresses)

arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

multi_bq = []
all_src = []
all_dest = []
for bq in bqs:
    bq_key = bq
    data_file = f"{dir_}/outputs_{fname}_{src}_0.12_{rs_cost}_{bq_key}{duck_txt}.json"
    # print(data_file)

    df = pd.read_json(data_file)
    data = df.loc[:, df.columns != 'all'].T
    # data = pd.read_json(data_file).T
    multi_cloud = data[data["multi_cloud_plan"] == "multi"]
    src_only = data[data["multi_cloud_plan"] == "stay"]
    dest_only = data[data["multi_cloud_plan"] == "move"]
    cnt_multi_cloud = len(multi_cloud)
    cnt_src_only = len(src_only)
    cnt_dest_only = len(dest_only)
    multi_bq.append(cnt_multi_cloud)

    all_src.append(cnt_src_only)
    all_dest.append(cnt_dest_only)

font = {'size' : fontsize}
plt.rc('font', **font)
fig = plt.figure(figsize=(x,y))
# fig = plt.figure()
ax = fig.subplots()
plt.plot(bqs, multi_bq, label=f"Multi: GA1", marker='*', ms=markersize,
        c=arachne_color, zorder=3)
plt.plot(bqs, all_src, label=src_label, marker='o', ms=markersize, c=bq_color,
        zorder=2)
plt.plot(bqs, all_dest, label=dest_label, marker='D', ms=markersize,
        c=duck_color, zorder=1)
plt.axvline(x=6.25, color='k')

plt.xlim([-0.5, 13])
plt.ylim([-2, 25])
plt.xlabel("BigQuery Cost $/TB")
plt.ylabel("Number of Plans")
# plt.legend()
# plt.show()
outfile = f"graphs/sf{SF}_cs{CS}_{fname}_{src}_what_if_bq.pdf"
plt.savefig(outfile, facecolor=fig.get_facecolor(),
        edgecolor='#d5d4c2', bbox_inches='tight')
