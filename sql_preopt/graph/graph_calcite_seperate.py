import numpy as np
import matplotlib.pyplot as plt
import json

duck = json.load(open('duck_calcite_data.json'))
rs = json.load(open('rs_calcite_data.json'))

duck_keys = sorted(duck.keys())
duck_values = []
for k in duck_keys:
    duck_values.append(duck[k])

rs_keys = sorted(rs.keys())
rs_values = []
for k in rs_keys:
    rs_values.append(rs[k])

arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

num_qs = len(duck_keys)
ind = np.arange(num_qs)
width = 0.5

fig = plt.figure(figsize=(10,4))
ax = fig.add_subplot(111)    # The big subplot
ax1 = fig.add_subplot(211)
ax2 = fig.add_subplot(212)

ax.spines['top'].set_color('none')
ax.spines['bottom'].set_color('none')
ax.spines['left'].set_color('none')
ax.spines['right'].set_color('none')
ax.tick_params(labelcolor='w', top=False, bottom=False, left=False, right=False)

ax1.bar(ind, duck_values, width, color=duck_c_color, label="DuckDB")
ax2.bar(ind, duck_values, width, color=duck_c_color, label="DuckDB")

ax.set_xlabel('Query Number')
ax.set_ylabel('% Speedup')
ax2.set_xticks(ind)
ax2.set_xticklabels(duck_keys)

ax1.legend()
ax1.set_ylim(0, 100)
ax2.set_ylim(-300, 0)

# hide the spines between ax1 and ax2
# ax1.spines['bottom'].set_visible(False)
# ax2.spines['top'].set_visible(False)
# ax1.set_xticks([])
ax1.xaxis.tick_top()
ax1.tick_params(top=False, bottom=False, labeltop=False)  # don't put tick labels at the top
ax2.xaxis.tick_bottom()

d = .5  # proportion of vertical to horizontal extent of the slanted line
kwargs = dict(marker=[(-1, -d), (1, d)], markersize=12,
              linestyle="none", color='k', mec='k', mew=1, clip_on=False)
ax1.plot([0, 1], [0, 0], transform=ax1.transAxes, **kwargs)
ax2.plot([0, 1], [1, 1], transform=ax2.transAxes, **kwargs)

# plt.show()
plt.savefig("duck_calcite.png", dpi=200, facecolor=fig.get_facecolor(),
        edgecolor='#d5d4c2', bbox_inches='tight')
plt.clf()


num_qs = len(rs_keys)
ind = np.arange(num_qs)
width = 0.5
fig = plt.figure(figsize=(10,4))
ax = fig.add_subplot(111)    # The big subplot
ax1 = fig.add_subplot(211)
ax2 = fig.add_subplot(212)

ax.spines['top'].set_color('none')
ax.spines['bottom'].set_color('none')
ax.spines['left'].set_color('none')
ax.spines['right'].set_color('none')
ax.tick_params(labelcolor='w', top=False, bottom=False, left=False, right=False)

ax1.bar(ind, rs_values, width, color=duck_color, label="Redshift")
ax2.bar(ind, rs_values, width, color=duck_color, label="Redshift")

ax.set_xlabel('Query Number')
ax.set_ylabel('% Speedup')
ax2.set_xticks(ind)
ax2.set_xticklabels(rs_keys)

ax1.legend()
ax1.set_ylim(0, 100)
ax2.set_ylim(-400, 0)

ax1.xaxis.tick_top()
ax1.tick_params(top=False, bottom=False, labeltop=False)  # don't put tick labels at the top
ax2.xaxis.tick_bottom()

d = .5  # proportion of vertical to horizontal extent of the slanted line
kwargs = dict(marker=[(-1, -d), (1, d)], markersize=12,
              linestyle="none", color='k', mec='k', mew=1, clip_on=False)
ax1.plot([0, 1], [0, 0], transform=ax1.transAxes, **kwargs)
ax2.plot([0, 1], [1, 1], transform=ax2.transAxes, **kwargs)

# plt.show()
plt.savefig("rs_calcite.png", dpi=200, facecolor=fig.get_facecolor(),
        edgecolor='#d5d4c2', bbox_inches='tight')




