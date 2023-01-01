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

cs = [duck_c_color, duck_color, bq_color]

cat_sales = [[24.21, 0], [1.93, 34.12], [7.42, 7.42]] # sf1000 rs1 catalog_sales noduck
store = [[0.7799, 0], [0.05211, 0.90056], [53.45778, 53.45778]] # sf1000 rs1 store noduck
store_ret = [[50.638, 0], [4.365, 71.955], [2.20, 2.20]] # sf1000 rs1 catalog_sales noduck

name = sys.argv[1]
x = None
if name == "catalog_sales":
    x = cat_sales
elif name == "store":
    x = store
elif name == "store_returns":
    x = store_ret
else:
    raise ValueError(f"invalid arg {name};")

df = pd.DataFrame(x).T
df.columns = ["Movement Costs", "Cost of Queries Moved to Redshift", "Cost of Queries Remaining in BigQuery"]
print(df)
fig = df.plot(kind='bar', color=cs, stacked=True, rot=0, hatch='*')
fig.set_xticklabels(["Arachne", "BigQuery Baseline"])
fig.set_aspect(150)
plt.ylabel("Cost ($)")

plt.show()
# outfile = f"graphs/{name}_sf1000_rs1_breakdown.png"
# figure = plt.gcf()
# figure.set_size_inches(8, 6)
# plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
