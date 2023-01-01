import matplotlib.pyplot as plt
import os
import pandas as pd
from argparse import ArgumentParser

parser = ArgumentParser(description="Graph cost vs. runtime")
args = parser.parse_args()

presentation_color = "#DFE5D2"
# plt.rcParams['axes.facecolor'] = presentation_color
# plt.rcParams['savefig.facecolor'] = presentation_color

rs_cost = 4 * 1.086

folders = ["io_2", "mixed", "cpu_0.5"]
labels = ["W-IO", "W-Mixed", "W-CPU"]
assert len(folders) == len(labels)

gcp_outfile = "outputs_noduck_GCP_0.12_4.344_6.25.json"
aws_outfile = "outputs_noduck_AWS_0.09_4.344_6.25.json"

bq_baseline_cost = []
rs_baseline_cost = []
arachne_aws_cost = []
arachne_bq_cost = []

arachne_aws_type = []
arachne_bq_type = []

bq_baseline_time = []
rs_baseline_time = []
arachne_aws_time = []
arachne_bq_time = []

for i in range(len(folders)):
    folder = folders[i]
    label = labels[i]

    gcp_path = os.path.join("custom_workload", folder, gcp_outfile)
    aws_path = os.path.join("custom_workload", folder, aws_outfile)

    gcpDF = pd.read_json(gcp_path).T
    awsDF = pd.read_json(aws_path).T

    bq_baseline_cost.append(gcpDF['baseline_cost'])
    bq_baseline_time.append(gcpDF['baseline_runtime']/3600)

    rs_baseline_cost.append(awsDF['baseline_cost'])
    rs_baseline_time.append(awsDF['baseline_runtime']/3600)

    arachne_bq_cost.append(gcpDF['arachne']) 
    arachne_bq_time.append(gcpDF['arachne_runtime'] / 3600)
    arachne_bq_type.append(gcpDF['multi_cloud_plan'])
    
    arachne_aws_cost.append(awsDF['arachne']) 
    arachne_aws_time.append(awsDF['arachne_runtime'] / 3600)
    arachne_aws_type.append(awsDF['multi_cloud_plan'])


arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

font = {'size' : 19}
plt.rc('font', **font)

fig = plt.figure(figsize=(6.5,3.5))
ax = fig.subplots()

for i in range(len(folders)):
    xs = [float(arachne_aws_time[i]), float(rs_baseline_time[i])]
    ys = [float(arachne_aws_cost[i]), float(rs_baseline_cost[i])]
    print(xs)
    print(ys)
    ax.plot(xs, ys, c='k', zorder=1)


ax.scatter(arachne_aws_time, arachne_aws_cost, 
           c=arachne_color, label="Arachne-RS", zorder=2, marker='D', s=130)
ax.scatter(rs_baseline_time, rs_baseline_cost, c=duck_color, label="Redshift", zorder=2, s=130)

ax.annotate(labels[0], (rs_baseline_time[0]+0.15, rs_baseline_cost[0]-6))
ax.annotate(labels[1], (arachne_aws_time[1]-0.01, arachne_aws_cost[1]-7),
            rotation=5)
# ax.annotate(labels[1], (rs_baseline_time[1]-2.5, rs_baseline_cost[1]-11))
ax.annotate(labels[2], (rs_baseline_time[2]-2, rs_baseline_cost[2]+3))
plt.xticks([0, 2, 4, 6, 8, 10, 12, 14])
plt.xlim([0, 15])
plt.ylim([0, 85])

plt.xlabel("Runtime (hrs)")
plt.ylabel("Cost ($)")
plt.legend(loc='upper left')

outfile = f"graphs/custom_aws_serial.pdf"
plt.savefig(outfile, edgecolor='#d5d4c2',
        bbox_inches='tight', dpi=1200)
plt.close()
plt.clf()

font = {'size' : 19}
plt.rc('font', **font)
fig = plt.figure(figsize=(6.5,3.5))
ax = fig.subplots()

for i in range(len(folders)):
    xs = [float(arachne_bq_time[i]), float(bq_baseline_time[i])]
    ys = [float(arachne_bq_cost[i]), float(bq_baseline_cost[i])]
    print(xs)
    print(ys)
    ax.plot(xs, ys, c='k', zorder=1)


ax.scatter(arachne_bq_time, arachne_bq_cost, 
           c=arachne_color, label="Arachne-BQ", zorder=2, marker='D', s=130)
ax.scatter(bq_baseline_time, bq_baseline_cost, c=bq_color, label="BigQuery", zorder=2, s=130)

ax.annotate(labels[0], (bq_baseline_time[0], bq_baseline_cost[0]+2))
ax.annotate(labels[1], (bq_baseline_time[1], bq_baseline_cost[1]-8.9))
ax.annotate(labels[2], (arachne_bq_time[2], arachne_bq_cost[2]+2))

plt.xlim([0, 3])
plt.ylim([0, 85])
plt.xticks([0, 1, 2, 3])

plt.xlabel("Runtime (hrs)")
plt.ylabel("Cost ($)")
plt.legend()

outfile = f"graphs/custom_gcp_serial.pdf"
plt.savefig(outfile, edgecolor='#d5d4c2',
        bbox_inches='tight', dpi=1200)










