import numpy as np
import matplotlib.pyplot as plt

# prices = np.array([1.086, 3.26, 13.04])

prices = np.array([1.086])
labels = ["ra3.xlplus", "ra3.4xlarge", "ra3.16xlarge"]
xs = np.linspace(0, 10, 36000)

fig, ax = plt.subplots()
for i, p in enumerate(prices):
    ys = (xs * p / 5)
    plt.plot(xs, ys)

runtimes = [0.5, 5.5]
sizes = [2, 0.9]

plt.rcParams.update({'font.size': 12})
plt.scatter(runtimes[0], sizes[0], color='r', label="Query A")
plt.text(runtimes[0]+0.15, sizes[0]-0.2, f"Query A: ({runtimes[0]:.1f}hrs, {sizes[0]:.1f}TB)")

plt.scatter(runtimes[1], sizes[1], color='g', label="Query B")
plt.text(runtimes[1]+0.2, sizes[1], f"Query B: ({runtimes[1]:.1f}hrs, {sizes[1]:.1f}TB)")

plt.xlabel("Query Runtime (hours)", fontsize=12)
plt.ylabel("Data Scanned (TB)", fontsize=12)

# plt.legend()
ax.set_aspect(2)
# fig.set_size_inches(0.65, 0.5)
plt.savefig("opportunity.png", dpi=200, bbox_inches='tight')


