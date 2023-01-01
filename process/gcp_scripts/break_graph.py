import matplotlib.pyplot as plt
import numpy as np
import json
import sys
import os
import pandas as pd

dir_ = "gcp_bq_v3"
home = os.path.expanduser("~")
os.chdir(f"{home}/arachneDB/{dir_}/worked")
f = open("processed_data.json")
raw = json.load(f)

keys = []

arachne_costs = []
bq_costs = []
rs_costs = []
cheapest_baseline_costs = []

for k in raw:
    keys.append(k)
    perf = raw[k]
    arachne_cost = perf["arachne_cost"]
    if arachne_cost == -1:
        arachne_cost = perf["duck_cost"]
    rs_cost = perf["duck_cost"]
    bq_cost = perf["bq_cost"]
    cheapest_baseline = min(bq_cost, rs_cost)

    arachne_costs.append(arachne_cost)
    bq_costs.append(bq_cost)
    rs_costs.append(rs_cost)
    cheapest_baseline_costs.append(cheapest_baseline)


maxs = []
N = len(bq_costs)
for i in range(N):
    m = max(bq_costs[i], rs_costs[i], arachne_costs[i])
    maxs.append(m)

total_data = np.array([keys, bq_costs, rs_costs, arachne_costs, maxs]).T

dic = {"keys":keys, "bq": bq_costs, "duck": rs_costs, "arachne":arachne_costs, "maxs":maxs}
df = pd.DataFrame(dic)
print(len(df))
df_base = df[df['maxs'] < df.maxs.quantile(.95)]
df_out = df[df.maxs >= df.maxs.quantile(.95)]
print(len(df_base))
print(len(df_out))
    
arachne_color = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"


# If we were to simply plot pts, we'd lose most of the interesting
# details due to the outliers. So let's 'break' or 'cut-out' the y-axis
# into two portions - use the top (ax1) for the outliers, and the bottom
# (ax2) for the details of the majority of our data

num_qs = len(df)
ind = np.arange(num_qs)
width = 0.25

plt.rcParams['xtick.labelsize'] = 4
plt.rcParams['ytick.labelsize'] = 8

fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
fig.subplots_adjust(hspace=0.05)  # adjust space between axes

rect1 = ax1.bar(ind, df.arachne, width, color=arachne_color, label="Arachne")
rect2 = ax1.bar(ind + width, df.bq, width, color=bq_color, label="BigQuery")
rect3 = ax1.bar(ind + 2*width, df.duck, width, color=duck_color, label="DuckDB")

rect1 = ax2.bar(ind, df.arachne, width, color=arachne_color, label="Arachne")
rect2 = ax2.bar(ind + width, df.bq, width, color=bq_color, label="BigQuery")
rect3 = ax2.bar(ind + 2*width, df.duck, width, color=duck_color, label="DuckDB")

# plt.ylabel("Cost ($)")
plt.xticks(ind + 3*width/2)
# ax1.set_title(title)
ax2.set_xlabel('Query Number')

ax1.set_xticklabels(keys)
ax1.legend()
# ax1.legend(loc='center left', bbox_to_anchor=(1, 0.5))
# ax2.legend(loc='center left', bbox_to_anchor=(1, 0.5))

#     figure = plt.gcf()
#     figure.set_size_inches(16, 9)
#     plt.savefig(outfile, dpi=100, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
#     plt.close()


# zoom-in / limit the view to different portions of the data
ax1.set_ylim(0.8, 25)  # outliers only
ax2.set_ylim(0, 0.8)  # most of the data

# hide the spines between ax and ax2
ax1.spines['bottom'].set_visible(False)
ax2.spines['top'].set_visible(False)
ax1.xaxis.tick_top()
ax1.tick_params(top=False, bottom=False, labeltop=False)  # don't put tick labels at the top
ax2.xaxis.tick_bottom()

# Now, let's turn towards the cut-out slanted lines.
# We create line objects in axes coordinates, in which (0,0), (0,1),
# (1,0), and (1,1) are the four corners of the axes.
# The slanted lines themselves are markers at those locations, such that the
# lines keep their angle and position, independent of the axes size or scale
# Finally, we need to disable clipping.

d = .5  # proportion of vertical to horizontal extent of the slanted line
kwargs = dict(marker=[(-1, -d), (1, d)], markersize=12,
              linestyle="none", color='k', mec='k', mew=1, clip_on=False)
ax1.plot([0, 1], [0, 0], transform=ax1.transAxes, **kwargs)
ax2.plot([0, 1], [1, 1], transform=ax2.transAxes, **kwargs)

figure = plt.gcf()
figure.set_size_inches(8, 6)
plt.savefig("break.png", dpi=200, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
plt.close()
