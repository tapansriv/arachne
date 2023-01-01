import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import json
import sys

'''
im in a rush make this better later
breakdown for CS1, SF1000, catalog_sales, noduck; updated 11/14, using iq2 and
all associated costs (api, storage, loading, movement)
'''
arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"
baseline = "#a2c0c7"

cs = [duck_c_color, duck_color, bq_color]

arachne_data = pd.DataFrame({
    "Dataset 3":  [24.21, 1.93, 7.42], # catalog_sales
    "Dataset 16": [50.64, 4.37, 2.20], # store_returns
  # "Dataset 19": [55.15, 5.35, 0.33], # warehouse
    "Dataset 22": [24.22, 1.93, 14.05] # web_sales
    }, index=["Arachne Migration Costs", "Arachne RS Query Cost", "Arachne BQ Query Cost"]
)

baseline_data = pd.DataFrame({
    # "catalog_sales": [0.0, 34.12, 7.42],
    # "store_returns": [0.0, 71.96, 2.20],
    # "warehouse":     [0.0, 92.29, 0.33]
    "Dataset 3":  [41.54], # catalog_sales
    "Dataset 16": [74.16], # store_returns
  # "Dataset 19": [92.61], # warehouse
    "Dataset 22": [48.17]  # web_sales
    }, index=["BigQuery Baseline Costs"]
)

arachne_data = arachne_data.T
baseline_data = baseline_data.T

fig = plt.figure(figsize=(9,3))
ax = fig.subplots()
baseline_data.plot(kind="bar", stacked=True, width=0.4, 
                  ax=ax, position=0, rot=0, color=[duck_no_cut_color])
arachne_data.plot(kind="bar", stacked=True, width=0.4, 
                   ax=ax, position=1, hatch='//', rot=0, color=cs)

ax.set_xlim(right=len(baseline_data)-0.5)
# ax.set_aspect(0.025)
# ax.set_aspect(0.015)
plt.legend()

plt.ylabel("Cost ($)")

# plt.show()
outfile = f"graphs/sf1000_rs1_breakdown.png"
# figure = plt.gcf()
# figure.set_size_inches(8, 6)
plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(),
        edgecolor='#d5d4c2', bbox_inches='tight')
