import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import json
import sys

'''
im in a rush make this better later
breakdown for CS1, SF1000, catalog_sales, noduck; updated 11/14, using iq2 and
all associated costs (api, storage, loading, movement)

catalog_sales  33.126112    15500.646965     61.903661  ...    46.487636      98.999708      30042.885879
store_returns  49.710356     31796.27164    100.961471  ...    50.763043     154.224457      52187.768027
warehouse      52.848011    34528.351078    120.327997  ...    56.080038     177.491868      57357.878286
web_sales      41.910929    18600.413653     70.704103  ...    40.723484     115.652055      37460.174216



'''
arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"
baseline = "#a2c0c7"

presentation_color = "#DFE5D2"
# plt.rcParams['axes.facecolor'] = presentation_color
# plt.rcParams['savefig.facecolor'] = presentation_color

cs = [duck_c_color, duck_color, bq_color]

arachne_data = pd.DataFrame({
    "Dataset 3":  [20.62, 1.68, 8.24], # catalog_sales
    "Dataset 16": [39.13, 3.89, 1.89], # store_returns
  # "Dataset 19": [42.18, 5.19, 0.40], # warehouse
    "Dataset 22": [20.62, 1.68, 17.03] # web_sales
    }, index=["Arachne Migration Costs", "Arachne RS Query Cost", "Arachne BQ Query Cost"]
)

baseline_data = pd.DataFrame({
    # "catalog_sales": [0.0, 34.12, 7.42],
    # "store_returns": [0.0, 71.96, 2.20],
    # "warehouse":     [0.0, 92.29, 0.33]
    "Dataset 3":  [61.90], # catalog_sales
    "Dataset 16": [100.96], # store_returns
  # "Dataset 19": [120.33], # warehouse
    "Dataset 22": [70.70]  # web_sales
    }, index=["BigQuery Baseline Costs"]
)

arachne_data = arachne_data.T
baseline_data = baseline_data.T

# font = {'size' : 15}
# plt.rc('font', **font)

fig = plt.figure(figsize=(9,3))
# fig = plt.figure()
ax = fig.subplots()
baseline_data.plot(kind="bar", stacked=True, width=0.4, 
                  ax=ax, position=0, rot=0, color=[duck_no_cut_color])
arachne_data.plot(kind="bar", stacked=True, width=0.4, 
                   ax=ax, position=1, hatch='//', rot=0, color=cs)

ax.set_xlim(right=len(baseline_data)-0.5)
ax.set_ylim(top=100)
# ax.set_aspect(0.025)
# ax.set_aspect(0.015)
# plt.legend(loc='center left', bbox_to_anchor=(1, 0.72))
plt.legend()

plt.ylabel("Cost ($)")

# plt.show()
outfile = f"graphs/sf1000_rs1_breakdown.pdf"
# figure = plt.gcf()
# figure.set_size_inches(8, 6)
plt.savefig(outfile, edgecolor='#d5d4c2', bbox_inches='tight')
