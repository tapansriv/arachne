import matplotlib.pyplot as plt
import numpy as np
import json
import sys
import os

dir_ = sys.argv[1]
home = os.path.expanduser("~")
os.chdir(f"{home}/arachneDB/{dir_}/worked")

f = open("processed_data.json")
raw = json.load(f)

data = {}

keys = []
abs_savings = []
rel_savings = []
abs_bq_savings = []
rel_bq_savings = []

abs_rs_savings = []
rel_rs_savings = []

for k in raw:
    perf = raw[k]
    arachne = perf["arachne_cost"]
    rs_cost = perf["rs_cost"]
    bq_cost = perf["bq_cost"]
    if rs_cost < 0: 
        continue
    if arachne == -1:
        arachne = perf["rs_cost"]
    print(f"{k}: {arachne}, {rs_cost}, {bq_cost}")

    keys.append(k)
    baseline = min(bq_cost, rs_cost)
    raw_save = baseline - arachne
    percent = 100 * ((baseline - arachne) / baseline)

    bq_save = bq_cost - arachne
    bq_percent = 100 * ((bq_cost - arachne) / bq_cost)
    rs_save = rs_cost - arachne
    rs_percent = 100 * ((rs_cost - arachne) / rs_cost)

    abs_savings.append(raw_save)
    rel_savings.append(percent)
    abs_bq_savings.append(bq_save)
    rel_bq_savings.append(bq_percent)
    abs_rs_savings.append(rs_save)
    rel_rs_savings.append(rs_percent)


def graph(X, keys, values, ylabel, title, filename):
    plt.bar(X, values)
    plt.xticks(X, keys)
    plt.xlabel("Query Number")
    plt.ylabel(ylabel)
    plt.title(title)
    figure = plt.gcf()
    figure.set_size_inches(16, 9)
    plt.savefig(filename, dpi=100)
    plt.clf()

X = np.arange(len(keys))
graph(X, keys, abs_savings, "Absolute Savings ($)", 
        "Absolute Savings wrt Cheapest Baseline Per Query, Redshift vs BQ", "abs_all.png")
graph(X, keys, rel_savings, "Percent Savings (%)", 
        "Relative Savings wrt Cheapest Baseline Per Query, Redshift vs BQ", "rel_all.png")
graph(X, keys, abs_bq_savings, "Absolute Savings ($)", 
        "Absolute Savings wrt BigQuery Per Query, Redshift vs BQ", "abs_bq.png")
graph(X, keys, rel_bq_savings, "Percent Savings (%)", 
        "Relative Savings wrt BigQuery Per Query, Redshift vs BQ", "rel_bq.png")
graph(X, keys, abs_rs_savings, "Absolute Savings ($)", 
        "Absolute Savings wrt Redshift Per Query, Redshift vs BQ", "abs_rs.png")
graph(X, keys, rel_rs_savings, "Percent Savings (%)", 
        "Relative Savings wrt Redshift Per Query, Redshift vs BQ", "rel_rs.png")

