import numpy as np
import csv
import matplotlib.pyplot as plt

# prices = np.array([1.086, 3.26, 13.04])

prices = np.array([1])
# labels = ["ra3.xlplus", "ra3.4xlarge", "ra3.16xlarge"]
xs = np.linspace(0, 10.5, 36000)

presentation_color = "#DFE5D2"
# plt.rcParams['axes.facecolor'] = presentation_color
# plt.rcParams['savefig.facecolor'] = presentation_color
fig, ax = plt.subplots()
for i, p in enumerate(prices):
    ys = (xs * p / 6.25)
    plt.plot(xs, ys)

runtimes = [0.5, 5.5]
sizes = [1.9, 0.5]

plt.rcParams.update({'font.size': 12})

plt.scatter(runtimes[0], sizes[0], color='r', label="Query A")
plt.text(runtimes[0]+0.15, sizes[0]-0.2, f"Query A: ({runtimes[0]:.1f}hrs, {sizes[0]:.1f}TB)")

plt.scatter(runtimes[1], sizes[1], color='g', label="Query B")
plt.text(runtimes[1]+0.2, sizes[1], f"Query B: ({runtimes[1]:.1f}hrs, {sizes[1]:.1f}TB)")

plt.xlabel("Query Runtime (hours)", fontsize=12)
plt.ylabel("Data Scanned (TB)", fontsize=12)
plt.xlim([0, 10.2])
plt.ylim([0, 2.2])

# plt.legend()
ax.set_aspect(2)
# fig.set_size_inches(0.65, 0.5)
plt.savefig("opportunity.pdf", dpi=1200, bbox_inches='tight')
plt.clf()

paths = ["parquet_1000/real_data_rs1", "parquet_1000/real_data_rs4",
         "parquet_2000/real_data_rs1", "parquet_2000/real_data_rs4"]

labels = ["1TB RS1", "1TB RS4", "2TB RS1", "2TB RS4"]
files = ["opp_1000_1.pdf", "opp_1000_4.pdf", "opp_2000_1.pdf", "opp_2000_4.pdf"]

prices = np.array([1.086, 4.344, 1.086, 4.344]) # price per hour

for i, p in enumerate(paths):
    runtimes = []
    sizes = []
    with open(f"../inter_query_analysis/{p}/workload.csv") as fp:
        reader = csv.reader(fp)
        for row in reader: 
            name = row[0]
            r = (float(row[1]) / 3600) # hours
            s = float(row[2]) # TB
            runtimes.append(r)
            sizes.append(s)
    

    xs = np.linspace(0, max(runtimes), 3600 * int(max(runtimes)))
    ys = (xs * prices[i] / 6.25)
    plt.plot(xs, ys)

    plt.scatter(runtimes, sizes, color='r')
    # plt.text(runtimes[0]+0.15, sizes[0]-0.2, f"Query A: ({runtimes[0]:.1f}hrs, {sizes[0]:.1f}TB)")

    # plt.scatter(runtimes[1], sizes[1], color='g', label="Query B")
    # plt.text(runtimes[1]+0.2, sizes[1], f"Query B: ({runtimes[1]:.1f}hrs, {sizes[1]:.1f}TB)")

    plt.xlabel("Query Runtime (hours)", fontsize=12)
    plt.ylabel("Data Scanned (TB)", fontsize=12)
    plt.title(f"Runtime vs. Cost for all 24 Workloads: {labels[i]}")

    # plt.legend()
    ax.set_aspect(2)
    # fig.set_size_inches(0.65, 0.5)
    plt.savefig(files[i], dpi=1200, bbox_inches='tight')
    plt.clf()

        







