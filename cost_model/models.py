import numpy as np
import matplotlib.pyplot as plt

# prices = np.linspace(0.25, 5.25, 11)
# prices = np.array([0.25, 0.5, 0.75, 1.0, 1.5, 2, 2.5, 5])
prices = np.array([1.086, 3.26, 13.04])
labels = ["ra3.xlplus", "ra3.4xlarge", "ra3.16xlarge"]
xs = np.linspace(0, 10, 36000)

plt.clf()
for i, p in enumerate(prices):
    ys = (xs * p / 5)
    # plt.xticks(np.arange(0, 11, step=1))
    # plt.yticks(np.arange(0, 11, step=0.5))
    # plt.plot(xs, ys, label = f"${p}/hr")
    plt.plot(xs, ys, label = labels[i])
plt.xlabel("Query Runtime (hours)")
plt.ylabel("Data Scanned (TB)")
# plt.title("Decision Point Without Movement Costs")
plt.legend()
plt.savefig("no_move.png")

plt.clf()
for p in prices:
    const = 5 + 1000*0.09
    ys1 = (xs * p) / const
    # plt.xticks(np.arange(0, 11, step=1))
    # plt.yticks(np.arange(0, 0.6, step=0.05))
    plt.plot(xs, ys1, label = f"${p}/hr")
plt.xlabel("Runtime of rest of query (hours)")
plt.ylabel("Size of data at this point (TB)")
plt.title("Decision Point With Movement Costs (AWS to GCP, $0.09/GB)")
plt.legend()
plt.savefig("aws_gcp.png")

# plt.clf()
# for p in prices:
#     const = 1000*0.09
#     ys1 = (xs * p) / const
#     # plt.xticks(np.arange(0, 11, step=1))
#     # plt.yticks(np.arange(0, 0.6, step=0.05))
#     plt.plot(xs, ys1, label = f"${p}/hr")
# plt.xlabel("Runtime of rest of query (hours)")
# plt.ylabel("Size of data at this point (TB)")
# plt.title("Decision Point With Movement Costs (Spectrum to GCP, $0.09/GB)")
# plt.legend()
# plt.savefig("spectrum_gcp.png")

plt.clf()
for p in prices:
    const = 5 + 1000*0.12
    ys1 = (xs * p) / const
    # plt.xticks(np.arange(0, 11, step=1))
    # plt.yticks(np.arange(0, 0.6, step=0.05))
    plt.plot(xs, ys1, label = f"${p}/hr")
plt.xlabel("Runtime of rest of query (hours)")
plt.ylabel("Size of data at this point (TB)")
plt.title("Decision Point With Movement Costs (GCP to AWS, $0.12/GB)")
plt.legend()
plt.savefig("gcp_aws.png")






# same plots but zoomed in between 0 and 1 hour 
# xs = np.linspace(0, 1, 3600)
# 
# plt.clf()
# for p in prices:
#     ys = (xs * p / 5)
#     plt.xticks(np.arange(0, 1.1, step=0.1))
#     # plt.yticks(np.arange(0, 11, step=0.5))
#     plt.plot(xs, ys, label = f"${p}/hr")
# plt.xlabel("Runtime of rest of query (hours)")
# plt.ylabel("Size of data at this point (TB)")
# plt.title("No Movement Cost (0 to 1 hours)")
# plt.legend()
# plt.savefig("no_move_zoom.png")
# 
# plt.clf()
# for p in prices:
#     const = 5 + 1000*0.09
#     ys1 = (xs * p) / const
#     plt.xticks(np.arange(0, 1.1, step=0.1))
#     # plt.yticks(np.arange(0, 0.6, step=0.05))
#     plt.plot(xs, ys1, label = f"${p}/hr")
# plt.xlabel("Runtime of rest of query (hours)")
# plt.ylabel("Size of data at this point (TB)")
# plt.title("Boundary w/ Movement Costs (AWS to GCP, $0.09/GB) (0 to 1 hours)")
# plt.legend()
# plt.savefig("aws_gcp_zoom.png")
# 
# plt.clf()
# for p in prices:
#     const = 1000*0.09
#     ys1 = (xs * p) / const
#     plt.xticks(np.arange(0, 1.1, step=0.1))
#     # plt.yticks(np.arange(0, 0.6, step=0.05))
#     plt.plot(xs, ys1, label = f"${p}/hr")
# plt.xlabel("Runtime of rest of query (hours)")
# plt.ylabel("Size of data at this point (TB)")
# plt.title("Boundary w/ Movement Costs (Spectrum to GCP, $0.09/GB) (0 to 1 hours)")
# plt.legend()
# plt.savefig("spectrum_gcp_zoom.png")
# 
# plt.clf()
# for p in prices:
#     const = 5 + 1000*0.12
#     ys1 = (xs * p) / const
#     plt.xticks(np.arange(0, 1.1, step=0.1))
#     # plt.yticks(np.arange(0, 0.6, step=0.05))
#     plt.plot(xs, ys1, label = f"${p}/hr")
# plt.xlabel("Runtime of rest of query (hours)")
# plt.ylabel("Size of data at this point (TB)")
# plt.title("Boundary w/ Movement Costs (GCP to AWS, $0.12/GB) (0 to 1 hours)")
# plt.legend()
# plt.savefig("gcp_aws_zoom.png")
# 
# 
# 
