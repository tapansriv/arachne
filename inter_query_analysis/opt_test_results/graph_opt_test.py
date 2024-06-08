import matplotlib.pyplot as plt
import json
import sys

arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

qs = [100, 1000, 10000, 50000, 100000]
t = 100
cs = [0.3, 0.4, 0.5, 0.6, 0.7]


greedy_times = []
opt_times = []
c = 0.5
for q in qs:
    f = open(f"out_{q}_{t}_{c}.txt")

    data = f.readlines()
    assert len(data) == 1
    vals = data[0].strip().split(",")
    ot = float(vals[0]) / 1000
    gt = float(vals[1]) / 1000
    opt_times.append(ot)
    greedy_times.append(gt)

font = {'size' : 19}
plt.rc('font', **font)

fig = plt.figure(figsize=(6.5,3.5))
ax = fig.subplots()

ax.set_xscale('log')
ax.set_yscale('log')
ax.scatter(qs, greedy_times, c=arachne_color, label="Arachne", marker='D')
ax.scatter(qs, opt_times, c=bq_color, label="Optimal", marker='x')

plt.xlabel("Number of Queries")
plt.ylabel("Runtime (seconds)")
plt.legend(loc='upper left')

outfile = f"opt_query.pdf"
plt.savefig(outfile, edgecolor='#d5d4c2',
        bbox_inches='tight', dpi=1200)
plt.close()
plt.clf()


greedy_times = []
opt_times = []
q = 10000
for c in cs:
    f = open(f"out_{q}_{t}_{c}.txt")

    data = f.readlines()
    assert len(data) == 1
    vals = data[0].strip().split(",")
    ot = float(vals[0]) / 1000
    gt = float(vals[1]) / 1000
    opt_times.append(ot)
    greedy_times.append(gt)

fig = plt.figure(figsize=(6.5,3.5))
ax = fig.subplots()

ax.scatter(cs, greedy_times, c=arachne_color, label="Arachne", marker='D')
ax.scatter(cs, opt_times, c=bq_color, label="Optimal", marker='x')

plt.xlabel("Complexity Ratio")
plt.ylabel("Runtime (seconds)")
plt.legend(loc='upper left')

outfile = f"opt_complexity.pdf"
plt.savefig(outfile, edgecolor='#d5d4c2',
        bbox_inches='tight', dpi=1200)
plt.close()
plt.clf()

