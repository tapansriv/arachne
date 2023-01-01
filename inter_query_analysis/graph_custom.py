import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys
from argparse import ArgumentParser

parser = ArgumentParser(description="Graph cost vs. runtime")
args = parser.parse_args()

presentation_color = "#DFE5D2"
# plt.rcParams['axes.facecolor'] = presentation_color
# plt.rcParams['savefig.facecolor'] = presentation_color

rs_cost = 4 * 1.086

f = "custom_workload/outputs.json"
data = json.load(open(f))

folders = {0.5: "cpu_0.5", 1.0: "mixed", 2.0: "io_2"}
labels = ["CPU", "Mixed", "IO"]
ratios = [0.5, 1.0, 2.0]

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
for k in ratios:
    v = folders[k]
    bq_baseline_cost.append(data[v]['baseline']['gcp']['cost'])
    bq_baseline_time.append(data[v]['baseline']['gcp']['runtime']/3600)

    rs_baseline_sec = data[v]['baseline']['aws']['runtime']# + data[v]['baseline']['aws']['load']
    rs_baseline_cost.append((rs_baseline_sec/3600) * rs_cost)
    rs_baseline_time.append(rs_baseline_sec/3600)

    aws_data = data[v]['aws']
    qcost = rs_cost * (aws_data['rs_query_time'] / 3600)
    lcost = rs_cost * (aws_data['rs_load_time'] / 3600)

    acost = aws_data['bq_cost'] + qcost + lcost + aws_data['mvmt_cost']
    atime = aws_data['bq_runtime'] + aws_data['rs_query_time'] + \
            aws_data['rs_load_time'] + aws_data['mvmt_runtime']

    arachne_aws_cost.append(acost) 
    arachne_aws_time.append(atime/3600)
    arachne_aws_type.append(aws_data['plan_type'])
    

    bq_data = data[v]['gcp']
    qcost = rs_cost * (bq_data['rs_query_time'] / 3600)
    lcost = rs_cost * (bq_data['rs_load_time'] / 3600)

    acost = bq_data['bq_cost'] + qcost + lcost + bq_data['mvmt_cost']
    atime = bq_data['bq_runtime'] + bq_data['rs_query_time'] + \
            bq_data['rs_load_time'] + bq_data['mvmt_runtime']

    arachne_bq_cost.append(acost)
    arachne_bq_time.append(atime/3600)
    arachne_bq_type.append(bq_data['plan_type'])



arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

font = {'size' : 15}
plt.rc('font', **font)

fig = plt.figure(figsize=(6.5,3.5))
ax = fig.subplots()

for i in range(len(ratios)):
    xs = [arachne_aws_time[i], rs_baseline_time[i]]
    ys = [arachne_aws_cost[i], rs_baseline_cost[i]]
    # print(xs)
    print(ys)
    ax.plot(xs, ys, c='k', zorder=1)


ax.scatter(arachne_aws_time, arachne_aws_cost, 
           c=arachne_color, label="Arachne-RS", zorder=2, marker='D', s=130)
ax.scatter(rs_baseline_time, rs_baseline_cost, c=duck_color, label="Redshift", zorder=2, s=130)

ax.annotate(labels[0], (rs_baseline_time[0]-1, rs_baseline_cost[0]))
ax.annotate(labels[1], (arachne_aws_time[1], arachne_aws_cost[1]-3))
ax.annotate(labels[2], (rs_baseline_time[2]+0.18, rs_baseline_cost[2]-1))
plt.xlim([0, 14.5])
plt.ylim([0, 85])

plt.xlabel("Runtime (hrs)")
plt.ylabel("Cost ($)")
plt.legend()

outfile = f"graphs/custom_aws.pdf"
plt.savefig(outfile, edgecolor='#d5d4c2',
        bbox_inches='tight', dpi=1200)
plt.close()
plt.clf()

fig = plt.figure(figsize=(6.5,3.5))
ax = fig.subplots()

for i in range(len(ratios)):
    xs = [arachne_bq_time[i], bq_baseline_time[i]]
    ys = [arachne_bq_cost[i], bq_baseline_cost[i]]
    # print(xs)
    print(ys)
    ax.plot(xs, ys, c='k', zorder=1)


ax.scatter(arachne_bq_time, arachne_bq_cost, 
           c=arachne_color, label="Arachne-BQ", zorder=2, marker='D', s=130)
ax.scatter(bq_baseline_time, bq_baseline_cost, c=bq_color, label="BigQuery", zorder=2, s=130)

ax.annotate(labels[0], (bq_baseline_time[0], bq_baseline_cost[0]))
ax.annotate(labels[1], (bq_baseline_time[1], bq_baseline_cost[1]+0.2))
ax.annotate(labels[2], (arachne_bq_time[2], arachne_bq_cost[2]))

plt.xlim([0, 2.2])
plt.ylim([0, 85])

plt.xlabel("Runtime (hrs)")
plt.ylabel("Cost ($)")
plt.legend()

outfile = f"graphs/custom_gcp.pdf"
plt.savefig(outfile, edgecolor='#d5d4c2',
        bbox_inches='tight', dpi=1200)










