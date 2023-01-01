import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys
import os

keys = ["67(1TB)", "Square", "86(2TB)", "86(10TB)", "Window"]
num_qs = len(keys)
presentation_color = "#DFE5D2"
# plt.rcParams['axes.facecolor'] = presentation_color
# plt.rcParams['savefig.facecolor'] = presentation_color

# arachne = [1.65, 0.0026302, 0.003537]
# bq = [5, 0.00508, 0.00508]
# duck = [25, 0.04588, 0.014849]
# duckdb: $0.07320684865398407 calcite: $0.050691946056980554 bigquery: $0.015615234375

arachne = [1.82868, 0.0055069, 0.0895742572, 0.27872752812, 0.311999]
bq = [4.998105, 0.015615234375, 0.62853, 3.142, 1.17914]
duck = [20.4027, 0.07320684865398407, 0.1605, 0.631947, 3.7159]
duck_calcite = [21.0109, 0.050691946056980554, 0.15143966453, 0.608774114, 3.7159]

percents = []
a_normalized = []
# bq_normalized = [1.0 for _ in range(num_qs)]
bq_normalized = []
duck_normalized = []
duck_c_normalized = []

assert len(bq) == num_qs
assert len(duck) == num_qs
assert len(duck_calcite) == num_qs

for i in range(num_qs):
    worst_baseline = max([bq[i], duck[i], duck_calcite[i]])
    a_normalized.append(arachne[i] / worst_baseline)
    bq_normalized.append(bq[i] / worst_baseline)
    duck_normalized.append(duck[i] / worst_baseline)
    duck_c_normalized.append(duck_calcite[i] / worst_baseline)

    # a_normalized.append(arachne[i] / bq[i])
    # bq_normalized.append(bq[i] / bq[i])
    # duck_normalized.append(duck[i] / bq[i])
    # duck_c_normalized.append(duck_calcite[i] / bq[i])

    # p = (min(duck[i], duck_calcite[i], bq[i]) - arachne[i]) / min(duck[i], duck_calcite[i], bq[i])
    # percents.append(100 * p)
    # # pbq = (bq[i] - arachne[i]) / bq[i]
    # pbq = arachne[i] / bq[i]
    # bq_normalized.append(pbq)
    # # pduck = (duck[i] - arachne[i]) / duck[i]
    # pduck = arachne[i] / duck[i]
    # duck_normalized.append(pduck)
    # # pduckc = (duck_calcite[i] - arachne[i]) / duck_calcite[i]
    # pduckc = arachne[i] / duck_calcite[i]
    # duck_c_normalized.append(pduckc)

arachne_color = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

# ind = np.arange(num_qs)
# width = 0.18
#
# plt.rcParams['xtick.labelsize'] = 6
# plt.rcParams['ytick.labelsize'] = 8
# fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
# fig.subplots_adjust(hspace=0.05)  # adjust space between axes
# 
# rect1 = ax1.bar(ind, arachne, width, color=arachne_color, label="Arachne")
# rect2 = ax1.bar(ind + width, duck, width, color=duck_color, label="DuckDB")
# rect3 = ax1.bar(ind + width, duck_calcite, width, color=duck_c_color, label="DuckDB-Calcite")
# rect4 = ax1.bar(ind + 3*width, bq, width, color=bq_color, label="BigQuery")
# 
# rect1 = ax2.bar(ind, arachne, width, color=arachne_color, label="Arachne")
# rect2 = ax2.bar(ind + width, duck, width, color=duck_color, label="DuckDB")
# rect3 = ax1.bar(ind + 2*width, duck_calcite, width, color=duck_c_color, label="DuckDB-Calcite")
# rect4 = ax2.bar(ind + 3*width, bq, width, color=bq_color, label="BigQuery")
# 
# title = "Hybrid vs Static Execution Plan Costs per System"
# outfile = "hybrids_absolute.png"
# 
# # ax1.set_ylabel("Cost ($)")
# plt.ylabel("Cost ($)")
# plt.xticks(ind + width)
# ax1.set_title(title)
# ax2.set_xlabel('Query Name')
# ax2.set_xticklabels(keys)
# 
# ax1.legend()
# ax1.set_ylim(1.5, 26)  # outliers only
# ax2.set_ylim(0, 0.04)  # most of the data
# # hide the spines between ax1 and ax2
# ax1.spines['bottom'].set_visible(False)
# ax2.spines['top'].set_visible(False)
# # ax1.set_xticks([])
# ax1.xaxis.tick_top()
# ax1.tick_params(top=False, bottom=False, labeltop=False)  # don't put tick labels at the top
# ax2.xaxis.tick_bottom()
# 
# d = .5  # proportion of vertical to horizontal extent of the slanted line
# kwargs = dict(marker=[(-1, -d), (1, d)], markersize=12,
#               linestyle="none", color='k', mec='k', mew=1, clip_on=False)
# ax1.plot([0, 1], [0, 0], transform=ax1.transAxes, **kwargs)
# ax2.plot([0, 1], [1, 1], transform=ax2.transAxes, **kwargs)
# 
# # plt.show()
# figure = plt.gcf()
# figure.set_size_inches(8, 6)
# plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
# plt.close()
# plt.clf()
# -----------------

# ind = np.arange(num_qs)
# width = 0.25
# 
# # plt.rcParams['xtick.labelsize'] = 6
# # plt.rcParams['ytick.labelsize'] = 8
# fig, ax = plt.subplots()
# 
# rect1 = ax.bar(ind, percents, width, color=arachne_color, label="Arachne")
# 
# title = "Percent Savings of Hybrid vs Cheapest Baseline"
# outfile = "hybrids_relative.png"
# 
# ax.set_ylabel("Percent Savings (%)")
# ax.set_xticks(ind)
# ax.set_title(title)
# ax.set_xlabel('Query Name')
# 
# ax.set_xticklabels(keys)
# ax.legend()
# 
# # plt.show()
# figure = plt.gcf()
# figure.set_size_inches(8, 6)
# plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
# plt.close()
# plt.clf()
# 

# -----------------

ind = np.arange(num_qs)
width = 0.18

font = {'size': 15}
plt.rc('font', **font)

fig = plt.figure(figsize=(9,3))
ax = fig.subplots()

rect1 = ax.bar(ind, a_normalized, width, color=arachne_color, label="Arachne")
rect2 = ax.bar(ind + width, duck_normalized, width, color=duck_color, label="DuckDB")
rect3 = ax.bar(ind + 2*width, duck_c_normalized, width, color=duck_c_color, label="Alt Syntax")
rect4 = ax.bar(ind + 3*width, bq_normalized, width, color=bq_color, label="BigQuery")

title = "Cost of Arachne Query Normalized to Worst Baseline"
outfile = "hybrids_normalized.pdf"

plt.ylabel("Normalized Cost")
plt.xticks(ind + 3*width/2)
ax.set_xlabel('Query Name')
ax.set_xticklabels(keys)

ax.legend(loc='upper right')
# ax.legend(bbox_to_anchor=(0.435, 1.0), loc='upper right')

# plt.show()
# figure = plt.gcf()
# figure.set_size_inches(8, 6)
plt.savefig(outfile, dpi=800, 
        edgecolor='#d5d4c2', bbox_inches='tight')
# plt.close()
# plt.clf()

