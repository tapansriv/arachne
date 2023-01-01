import numpy as np
import matplotlib.patches as mpatches
import matplotlib.pyplot as plt
import json

# arachne_color  = "#ecae17"
# bq_color = "#455984"
rs_color = "#a12721"
duck_color = "#577836"
# duck_no_cut_color = "#c85327"

duck = json.load(open('duck_calcite_data.json'))
rs = json.load(open('rs_calcite_data.json'))

font = {'size' : 15, }
plt.rc('font', **font)
# plt.rc('xtick', labelsize=14)

duck_keys = list(sorted(duck.keys()))
print(duck_keys)
print('-----')
rs_keys = list(sorted(rs.keys()))
print(rs_keys)
print('-----')
total_keys = sorted(duck_keys + rs_keys)
print(total_keys)


duck_values = []
for k in duck_keys:
    duck_values.append(duck[k])

rs_values = []
for k in rs_keys:
    rs_values.append(rs[k])

duck_ptr = 0
rs_ptr = 0
total_values = []
colors = []
for i, k in enumerate(total_keys):
    if  duck_ptr < len(duck_keys) and duck_keys[duck_ptr] == k:
        print(f"{i}, {k}, duck")
        total_values.append(duck_values[duck_ptr])
        colors.append(duck_color)
        duck_ptr += 1
    elif rs_keys[rs_ptr] == k:
        print(f"{i}, {k}, rs")
        total_values.append(rs_values[rs_ptr])
        colors.append(rs_color)
        rs_ptr += 1
    else:
        raise ValueError("y'all fucked up assumptions")

num_qs = len(total_keys)
ind = np.arange(num_qs)
width = 0.5
    
fig = plt.figure(figsize=(13,4))
ax = fig.add_subplot(111)    # The big subplot
ax1 = fig.add_subplot(211)
ax2 = fig.add_subplot(212)

ax.spines['top'].set_color('none')
ax.spines['bottom'].set_color('none')
ax.spines['left'].set_color('none')
ax.spines['right'].set_color('none')
ax.tick_params(labelcolor='w', top=False, bottom=False, left=False, right=False)

ax1.bar(ind, total_values, width, color=colors)
ax2.bar(ind, total_values, width, color=colors)

ax.set_xlabel('Query Number', labelpad=10)
ax.set_ylabel('% Speedup', labelpad=10)
ax2.set_xticks(ind)
ax2.set_xticklabels(total_keys)

# rotates xlabels
plt.setp(ax2.get_xticklabels(), rotation=90)


duck_patch = mpatches.Patch(color=duck_color, label='DuckDB')
rs_patch   = mpatches.Patch(color=rs_color, label='Redshift')
ax2.legend(handles=[duck_patch, rs_patch])

# ax1.legend()
ax1.set_ylim(-75, 100)
ax1.set_xlim(-0.5, ind.size-0.5)
ax2.set_ylim(-400, -75)
ax2.set_xlim(-0.5, ind.size-0.5)

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
plt.savefig("preopt.png", dpi=200, facecolor=fig.get_facecolor(),
        edgecolor='#d5d4c2', bbox_inches='tight')
plt.clf()
    


