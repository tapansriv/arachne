import matplotlib.pyplot as plt
from operator import sub
import numpy as np
import pandas as pd
import json
from argparse import ArgumentParser

def plot(data: pd.DataFrame, price_type: str, outfile: str, legend: bool):
    assert price_type in ["egress", "bq"]
    assert outfile.endswith('.pdf')

    fontsize = 22
    markersize = 8
    x = 6.5
    y = 3.5
    arachne_color  = "#ecae17"
    bq_color = "#455984"
    mixed_color = "#c85327"
    io_color = "#4B3C4A"
    cpu_color = '#577836'

    src_label = "BQ"
    dest_label = f"RS-{CS}"
    c = "GA4"
    base_egress = 0.12

    font = {'size' : fontsize}
    plt.rc('font', **font)
    fig = plt.figure(figsize=(x,y))
    ax1 = fig.subplots()
    ax2 = ax1.twinx()


    speedup = 100 * (data["Baseline Runtime"] - data["Arachne Runtime"]) / (data["Baseline Runtime"])
    savings = data["Percent Diff"]
    ln1 = ax1.plot(data['Price'], speedup, label=f"% Speedup",
             marker='^', ms=markersize, c=mixed_color, zorder=3)
    ln2 = ax2.plot(data['Price'], savings, label=f"% Savings",
             marker='o', ms=markersize, c=cpu_color)

    if price_type == "egress":
        plt.xlim([-0.01, 0.26])
        ax1.set_xlabel("Egress Cost $/GB")
        plt.axvline(x=base_egress, color='k')
        ax1.set_xticks([0.0, 0.05, 0.10, 0.15, 0.20, 0.25])
    elif price_type == "bq":
        plt.axvline(x=6.25, color='k')
        plt.xlim([-0.5, 13])
        ax1.set_xlabel("BigQuery Cost $/TB")
        ax1.set_xticks([0.0, 2.5, 5.0, 7.5, 10.0, 12.5])

    ax1.set_ylabel("Percent Speedup")
    ax2.set_ylabel("Percent Savings")
    ax1.set_ylim(-30, 35)
    ax2.set_ylim(-5, 90)
    ax1.set_yticks([-30, -20, -10, 0, 10, 20, 30])


    if legend:
        # plt.legend()
        lns = ln1 + ln2
        labs = [l.get_label() for l in lns]
        # ax1.legend(lns, labs, loc=(0.6, 0.25))
        ax2.legend(lns, labs, loc='upper right')

    plt.savefig(outfile, facecolor=fig.get_facecolor(),
            edgecolor='#d5d4c2', bbox_inches='tight')
    plt.clf()


parser = ArgumentParser(description="Run inter-query analysis")

parser.add_argument("--legend", action="store_true", help="Print legend flag")
parser.add_argument("--cluster_size", type=int, default=4, help="Number of Redshift nodes in cluster")

parser.add_argument("table_name", help="Path with data for analysis")
parser.add_argument("path", help="Path with data for analysis")
args = parser.parse_args()

CS = args.cluster_size # cluster size
rs_cost = int(CS) * 1.086
fname = "NOCALCITE_noduck"
dir_ = args.path

bqs = np.linspace(0.25, 12.5, 50)
egresses  = np.linspace(0, 0.24, 49)

rows = []
columns = ['Price', 'Percent Diff', 'Arachne Runtime', 'Baseline Runtime', 'Plan Type']
for bq_key in bqs:
    gcp_data_file = f"{dir_}/outputs_{fname}_GCP_0.12_{rs_cost}_{bq_key}.json"
    gcpdf = pd.read_json(gcp_data_file).T.loc[args.table_name]

    gcp_type = gcpdf["multi_cloud_plan"]
    rows.append([bq_key, float(gcpdf["percent_diff"]),
                 float(gcpdf["arachne_runtime"]),
                 float(gcpdf["baseline_runtime"]), gcp_type])

# print(rows)
bq_data = pd.DataFrame(rows, columns=columns)
print(bq_data)
plot(bq_data, "bq", f"graphs/{args.table_name}_what_if_bq.pdf", True)

rows = []
for e2 in egresses:
    e = round(e2, 3)
    gcp_data_file = f"{dir_}/outputs_{fname}_GCP_{e}_{rs_cost}_6.25.json"
    gcpdf = pd.read_json(gcp_data_file).T.loc[args.table_name]

    gcp_type = gcpdf["multi_cloud_plan"]
    rows.append([e, float(gcpdf["percent_diff"]),
                 float(gcpdf["arachne_runtime"]),
                 float(gcpdf["baseline_runtime"]), gcp_type])

egress_data = pd.DataFrame(rows, columns=columns)
print(egress_data)
plot(egress_data, "egress", f"graphs/{args.table_name}_what_if_egress.pdf",
     False)

