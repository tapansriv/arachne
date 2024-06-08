import matplotlib.pyplot as plt
from operator import sub
import numpy as np
import pandas as pd
import json
from argparse import ArgumentParser

def plot(data: pd.DataFrame, plot_type: str, price_type: str, src: str, outfile:
         str, legend: bool):
    assert plot_type in ["percent", "type", "runtime"]
    assert price_type in ["egress", "bq"]
    assert src in ["aws", "gcp"]
    assert outfile.endswith('.pdf')

    fontsize = 19
    markersize = 8
    x = 6.5
    y = 2.4
    arachne_color  = "#ecae17"
    bq_color = "#455984"
    duck_color = "#a12721"

    # mixed_color = "#577836"
    # io_color = "#"
    # cpu_color = '#a2c0c7'
    mixed_color = "#c85327"
    io_color = "#4B3C4A"
    cpu_color = '#577836'

    src_label = "BQ"
    dest_label = f"RS-{CS}"
    c = "GA4"
    base_egress = 0.12
    yticklabels = ["Stay (BQ)", "Multi (GA4)", "Move (RS-4)"]
    if src == "aws":
        base_egress = 0.09
        c = "AG4"
        src_label = f"RS-{CS}"
        dest_label = "BQ"
        yticklabels = ["Stay (RS-4)", "Multi (AG4)", "Move (BQ)"]

    font = {'size' : fontsize}
    plt.rc('font', **font)
    fig = plt.figure(figsize=(x,y))

    
    mixed_data = data[data["Label"] == "Mixed"]
    cpu_data = data[data["Label"] == "CPU"]
    io_data = data[data["Label"] == "IO"]
    if plot_type == "percent":
        plt.plot(mixed_data['Price'], mixed_data["Percent Diff"],
                 label=f"Mixed-{c}", marker='^', ms=markersize, c=mixed_color,
                 zorder=3)
        plt.plot(cpu_data['Price'], cpu_data["Percent Diff"], label=f"CPU-{c}",
                 marker='o', ms=markersize, c=cpu_color, zorder=2)
        plt.plot(io_data['Price'], io_data["Percent Diff"], label=f"IO-{c}",
                 marker='D', ms=markersize, c=io_color, zorder=1)
        plt.ylim([-1, 100])
        plt.yticks([0, 25, 50, 75, 100])
        plt.ylabel("% Savings")

    elif plot_type == "runtime":
        mixed_diff = mixed_data["Baseline Runtime"] - mixed_data["Arachne Runtime"]
        cpu_diff = cpu_data["Baseline Runtime"] - cpu_data["Arachne Runtime"]
        io_diff = io_data["Baseline Runtime"] - io_data["Arachne Runtime"]

        plt.plot(mixed_data['Price'], mixed_diff, label=f"Mixed-{c}",
                 marker='^', ms=markersize, c=mixed_color, zorder=3)
        plt.plot(cpu_data['Price'], cpu_diff, label=f"CPU-{c}", marker='o',
                 ms=markersize, c=cpu_color, zorder=2)
        plt.plot(io_data['Price'], io_diff, label=f"IO-{c}", marker='D',
                 ms=markersize, c=io_color, zorder=1)
        # plt.ylim([-1, 100])
        plt.ylabel("Seconds Faster than Baseline")

    elif plot_type == "type":
        # print(mixed_data)
        plt.scatter(mixed_data['Price'], mixed_data["Plan Enum"],
                 label=f"Mixed-{c}", zorder=3, marker='^', s=64,
                 c=mixed_color)
        plt.scatter(cpu_data['Price'], cpu_data["Plan Enum"], label=f"CPU-{c}",
                 zorder=2, marker='o',  s=64, 
                    c=cpu_color)
        plt.scatter(io_data['Price'], io_data["Plan Enum"], label=f"IO-{c}",
                 zorder=1, marker='D',  s=64, 
                    c=io_color)
        plt.yticks(np.arange(3), yticklabels)
        plt.ylim([-0.1, 2.1])
        plt.ylabel("Type of Plan")
    
    if price_type == "egress":
        plt.xlim([-0.01, 0.26])
        plt.xlabel("Egress Cost $/GB")
        plt.axvline(x=base_egress, color='k')
    elif price_type == "bq":
        plt.axvline(x=6.25, color='k')
        plt.xlim([-0.5, 13])
        plt.xlabel("BigQuery Cost $/TB")

    if legend:
        plt.legend()
    plt.savefig(outfile, facecolor=fig.get_facecolor(),
            edgecolor='#d5d4c2', bbox_inches='tight')
    plt.clf()


parser = ArgumentParser(description="Run inter-query analysis")

parser.add_argument("--legend", action="store_true", help="Print legend flag")
parser.add_argument("--rs_cost", type=float, default=1.086, help="Redshift Hourly Cost in dollars")
parser.add_argument("--cluster_size", type=int, default=4, help="Number of Redshift nodes in cluster")
args = parser.parse_args()


dirs = ["cpu_0.5", "mixed", "io_2"]
labels = ["CPU", "Mixed", "IO"]
assert len(dirs) == len(labels)

CS = args.cluster_size # cluster size
rs_cost = int(CS) * args.rs_cost
fname = "noduck"
duck_txt = ""
mmap = {'stay': 0, 'multi': 1, 'move': 2}



bqs = np.linspace(0.25, 12.5, 50)
egresses  = np.linspace(0, 0.24, 49)

rows = []
columns = ['Price', 'Percent Diff', 'Arachne Runtime', 'Baseline Runtime', 'Plan Type', 'Plan Enum', 'Src', 'Label']
for bq_key in bqs:
    for i in range(len(dirs)):
        l = labels[i]
        dir_ = dirs[i]
        gcp_data_file = f"custom_workload/{dir_}/outputs_{fname}_GCP_0.12_{rs_cost}_{bq_key}{duck_txt}.json"
        aws_data_file = f"custom_workload/{dir_}/outputs_{fname}_AWS_0.09_{rs_cost}_{bq_key}{duck_txt}.json"

        gcpdf = pd.read_json(gcp_data_file).T
        awsdf = pd.read_json(aws_data_file).T

        gcp_type = gcpdf["multi_cloud_plan"].values[0]
        aws_type = awsdf["multi_cloud_plan"].values[0]
        rows.append([bq_key, float(gcpdf["percent_diff"]),
                     float(gcpdf["arachne_runtime"]),
                     float(gcpdf["baseline_runtime"]), gcp_type, mmap[gcp_type],
                     "gcp", l])

        rows.append([bq_key, float(awsdf["percent_diff"]),
                     float(awsdf["arachne_runtime"]),
                     float(awsdf["baseline_runtime"]), aws_type, mmap[aws_type],
                     "aws", l])
# print(rows)
bq_data = pd.DataFrame(rows, columns=columns)
print(bq_data)

plot(bq_data[bq_data['Src'] == 'aws'], "percent", "bq", "aws", "graphs/custom_bq_aws_percent_what_if.pdf", True)
plot(bq_data[bq_data['Src'] == 'gcp'], "percent", "bq", "gcp", "graphs/custom_bq_gcp_percent_what_if.pdf", True)
# plot(bq_data[bq_data['Src'] == 'aws'], "runtime", "bq", "aws", "graphs/custom_bq_aws_runtime_what_if.pdf", True)
# plot(bq_data[bq_data['Src'] == 'gcp'], "runtime", "bq", "gcp", "graphs/custom_bq_gcp_runtime_what_if.pdf", True)
plot(bq_data[bq_data['Src'] == 'aws'], "type", "bq", "aws", "graphs/custom_bq_aws_type_what_if.pdf", True)
plot(bq_data[bq_data['Src'] == 'gcp'], "type", "bq", "gcp", "graphs/custom_bq_gcp_type_what_if.pdf", True)

rows = []
for e2 in egresses:
    e = round(e2, 3)
    for i in range(len(dirs)):
        l = labels[i]
        dir_ = dirs[i]
        gcp_data_file = f"custom_workload/{dir_}/outputs_{fname}_GCP_{e}_{rs_cost}_6.25{duck_txt}.json"
        aws_data_file = f"custom_workload/{dir_}/outputs_{fname}_AWS_{e}_{rs_cost}_6.25{duck_txt}.json"
        gcpdf = pd.read_json(gcp_data_file).T
        awsdf = pd.read_json(aws_data_file).T

        gcp_type = gcpdf["multi_cloud_plan"].values[0]
        aws_type = awsdf["multi_cloud_plan"].values[0]
        rows.append([e, float(gcpdf["percent_diff"]),
                     float(gcpdf["arachne_runtime"]),
                     float(gcpdf["baseline_runtime"]), gcp_type, mmap[gcp_type],
                     "gcp", l])
        rows.append([e, float(awsdf["percent_diff"]),
                     float(awsdf["arachne_runtime"]),
                     float(awsdf["baseline_runtime"]), aws_type, mmap[aws_type],
                     "aws", l])

egress_data = pd.DataFrame(rows, columns=columns)
print(egress_data)
plot(egress_data[egress_data['Src'] == 'aws'], "percent", "egress", "aws", "graphs/custom_egress_aws_percent_what_if.pdf", False)
plot(egress_data[egress_data['Src'] == 'gcp'], "percent", "egress", "gcp", "graphs/custom_egress_gcp_percent_what_if.pdf", False)
# plot(egress_data[egress_data['Src'] == 'aws'], "runtime", "egress", "aws", "graphs/custom_egress_aws_runtime_what_if.pdf", False)
# plot(egress_data[egress_data['Src'] == 'gcp'], "runtime", "egress", "gcp", "graphs/custom_egress_gcp_runtime_what_if.pdf", False)
plot(egress_data[egress_data['Src'] == 'aws'], "type", "egress", "aws", "graphs/custom_egress_aws_type_what_if.pdf", False)
plot(egress_data[egress_data['Src'] == 'gcp'], "type", "egress", "gcp", "graphs/custom_egress_gcp_type_what_if.pdf", False)

