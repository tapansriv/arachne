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

arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

print(fname)
rs_cost = int(CS) * 1.086
data = pd.read_json(f"{dir_}/outputs_{fname}_0.12_{rs_cost}_5{duck_txt}.json").T
multi_cloud = data[data["multi_cloud_plan"] == "multi"]
gcp_only = data[data["multi_cloud_plan"] == "gcp"]
aws_only = data[data["multi_cloud_plan"] == "aws"]

cnt_multi_cloud = len(multi_cloud)
cnt_gcp_only = len(gcp_only)
cnt_aws_only = len(aws_only)
counts = [cnt_multi_cloud, cnt_gcp_only, cnt_aws_only]
x_labels = ["Multi-Cloud", "GCP Only", "AWS Only"]
print(f"Multi: {cnt_multi_cloud}, gcp: {cnt_gcp_only}, aws: {cnt_aws_only}")

# title = f"Count per Optimal Inter-Query Plan Type; SF-{SF}; Cluster Size {CS}{duck_txt}"
# num_qs = len(x_labels)
# ind = np.arange(num_qs)
# width = 0.25
# 
# plt.rcParams['xtick.labelsize'] = 6
# plt.rcParams['ytick.labelsize'] = 8
# fig, ax = plt.subplots()
# 
# rect1= ax.bar(ind, counts, color=duck_no_cut_color)
# 
# # add some text for labels, title and axes ticks
# ax.set_ylabel("Count")
# ax.set_xticks(ind, labels=x_labels)
# ax.set_title(title)
# ax.set_xlabel("Plan Type")
# 
# outfile = f"graphs/sf{SF}_cs{CS}_{fname}_inter_distrib.png"
# figure = plt.gcf()
# figure.set_size_inches(8, 6)
# plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')

