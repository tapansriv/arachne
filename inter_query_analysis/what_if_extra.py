import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys
from argparse import ArgumentParser

parser = ArgumentParser(description="Graph cost vs. runtime what-if")
parser.add_argument("--legend", action="store_true", help="Print legend flag")
parser.add_argument("--cluster_size", type=int, default=1, help="Where data begins")

parser.add_argument("table_name", help="Path with data for analysis")
parser.add_argument("type", choices=["bq", "egress"], help="Path with data for analysis")
parser.add_argument("compare", type=float, help="Path with data for analysis")
parser.add_argument("path", help="Path with data for analysis")
args = parser.parse_args()

dir_ = args.path
CS = args.cluster_size # cluster size
rs_cost = int(CS) * 1.086

e1 = 0.12
e2 = 0.12
bq1 = 6.25
bq2 = 6.25
if args.type == "bq":
    if args.compare < bq1:
        bq1 = args.compare
    elif args.compare > bq2:
        bq2 = args.compare
else:
    if args.compare < e1:
        e1 = args.compare
    elif args.compare > e2:
        e2 = args.compare

f1 = f"{dir_}/outputs_NOCALCITE_noduck_GCP_{e1}_{rs_cost}_{bq1}.json"
f2 = f"{dir_}/outputs_NOCALCITE_noduck_GCP_{e2}_{rs_cost}_{bq2}.json"

start_data = pd.read_json(f1).T.loc[args.table_name]
end_data = pd.read_json(f2).T.loc[args.table_name]

start_arachne = ((start_data["arachne_runtime"]/3600), start_data["arachne"])
start_baseline = ((start_data["baseline_runtime"]/3600),
                  start_data["baseline_cost"])

end_arachne = ((end_data["arachne_runtime"]/3600), end_data["arachne"])
end_baseline = ((end_data["baseline_runtime"]/3600),
                  end_data["baseline_cost"])


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

xs = [start_arachne[0], start_baseline[0]]
ys = [start_arachne[1], start_baseline[1]]
ax.plot(xs, ys, c='k', zorder=1)

xs = [end_arachne[0], end_baseline[0]]
ys = [end_arachne[1], end_baseline[1]]
ax.plot(xs, ys, c='k', zorder=1)



ax.scatter([start_arachne[0]], [start_arachne[1]], c=arachne_color, 
        label="Arachne", zorder=2, marker='D', s=130)
ax.scatter(start_baseline[0], start_baseline[1], c=bq_color,
        label="BigQuery", zorder=2, s=130)

ax.scatter([end_arachne[0]], [end_arachne[1]], c=arachne_color, 
        label="Arachne", zorder=2, marker='D', s=130)
ax.scatter(end_baseline[0], end_baseline[1], c=bq_color,
        label="BigQuery", zorder=2, s=130)

plt.xlabel("Runtime (hrs)")
plt.ylabel("Cost ($)")
if "1000" in dir_:
    pass
    # plt.xticks(np.arange(-1, 12, step=1))
    plt.xlim([0, 3])
    plt.ylim([0, 85])
elif "2000" in dir_:
    plt.xticks(np.arange(-1, 12, step=1))
    plt.xlim([0, 10.2])
    plt.ylim([0, 220])

if args.legend:
    plt.legend()
    # plt.legend(loc='center left', bbox_to_anchor=(1, 0.5))

plt.show()
# outfile = f"graphs/what_if_{args.table_name}_{args.type}.pdf"
# plt.savefig(outfile, edgecolor='#d5d4c2', bbox_inches='tight', dpi=1200)
plt.close()


