import matplotlib.pyplot as plt
from operator import sub
import numpy as np
import pandas as pd
import json
import sys

dir_ = sys.argv[1]
SF = sys.argv[2] # scale factor
CS = sys.argv[3] # cluster size
duck = sys.argv[4] # with duckdb or not
rs_cost = int(CS) * 1.086

fontsize = 15
markersize = 8
x = 6.5
y = 3.5

fname = "noduck"
duck_txt = ""
if duck == "duck":
    fname = "duck"
    duck_txt = "_1.48"
print(fname)

bqs = np.linspace(0.25, 10, 40)
egresses = np.linspace(0, 0.24, 49)
print(egresses)

arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

multi_bq = []
gcp_bq = []
aws_bq = []
for bq in bqs:
    bq_key = bq
    if bq == 5:
        bq_key = 5 # bq is float. want to get rid of 5.0 -> 5
    data = pd.read_json(f"{dir_}/outputs_{fname}_0.12_{rs_cost}_{bq_key}{duck_txt}.json").T
    multi_cloud = data[data["multi_cloud_plan"] == "multi"]
    gcp_only = data[data["multi_cloud_plan"] == "gcp"]
    aws_only = data[data["multi_cloud_plan"] == "aws"]
    cnt_multi_cloud = len(multi_cloud)
    cnt_gcp_only = len(gcp_only)
    cnt_aws_only = len(aws_only)
    multi_bq.append(cnt_multi_cloud)
    gcp_bq.append(cnt_gcp_only)
    aws_bq.append(cnt_aws_only)

font = {'size' : fontsize}
plt.rc('font', **font)
fig = plt.figure(figsize=(x,y))
# fig = plt.figure()
ax = fig.subplots()
plt.plot(bqs, multi_bq, label=f"Multi: GA1", marker='*', ms=markersize,
        c=arachne_color, zorder=3)
plt.plot(bqs, gcp_bq, label=f"BQ Only", marker='o', ms=markersize, c=bq_color,
        zorder=2)
plt.plot(bqs, aws_bq, label=f"RS-{CS} Only", marker='D', ms=markersize,
        c=duck_color, zorder=1)
plt.axvline(x=5.0, color='k')

plt.xlim([-0.5, 10.5])
plt.ylim([-2, 25])
plt.xlabel("BigQuery Cost $/TB")
plt.ylabel("Number of Plans")
# plt.legend()
# plt.show()
outfile = f"graphs/sf{SF}_cs{CS}_{fname}_what_if_bq.png"
plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(),
        edgecolor='#d5d4c2', bbox_inches='tight')
plt.clf()



multi_e = []
gcp_e = []
aws_e = []
for e2 in egresses:
    e = round(e2, 3)
    data_file = f"{dir_}/outputs_{fname}_{e}_{rs_cost}_5.0{duck_txt}.json"
    if e == 0.12:
        data_file = f"{dir_}/outputs_{fname}_{e}_{rs_cost}_5{duck_txt}.json"
    # print(data_file)

    data = pd.read_json(data_file).T
    multi_cloud = data[data["multi_cloud_plan"] == "multi"]
    gcp_only = data[data["multi_cloud_plan"] == "gcp"]
    aws_only = data[data["multi_cloud_plan"] == "aws"]
    cnt_multi_cloud = len(multi_cloud)
    cnt_gcp_only = len(gcp_only)
    cnt_aws_only = len(aws_only)
    multi_e.append(cnt_multi_cloud)
    gcp_e.append(cnt_gcp_only)
    aws_e.append(cnt_aws_only)

font = {'size' : fontsize}
plt.rc('font', **font)
fig = plt.figure(figsize=(x,y))
# fig = plt.figure()
ax = fig.subplots()
ax.plot(egresses, multi_e, label=f"Multi: GA1", marker='*', ms=markersize,
        c=arachne_color, zorder=3)
ax.plot(egresses, gcp_e, label=f"BQ Only", marker='o', ms=markersize,
        c=bq_color, zorder=2)
ax.plot(egresses, aws_e, label=f"RS-{CS} Only", marker='D', ms=markersize, c=duck_color,
        zorder=1)
ax.axvline(x=0.12, color='k')

plt.xlim([-0.01, 0.26])
plt.ylim([-2, 25])
plt.xticks(np.arange(0, 0.26, 0.04))
plt.xlabel("Egress Cost $/GB")
plt.ylabel("Number of Plans")
# plt.legend()
# plt.show()
outfile = f"graphs/sf{SF}_cs{CS}_{fname}_what_if_egress.png"
# figure = plt.gcf()
# figure.set_size_inches(9,5)
plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(),
        edgecolor='#d5d4c2', bbox_inches='tight')

