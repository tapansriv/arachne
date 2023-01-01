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
abs_bq_savings = []
rel_savings = []
rel_bq_savings = []
abs_duck_savings = []
rel_duck_savings = []

for k in raw:
    perf = raw[k]
    arachne = perf["arachne_cost"]
    duck_cost = perf["duck_cost"]
    if duck_cost < 0:
        continue
    keys.append(k)
    bq_cost = perf["bq_cost"]
    if arachne == -1:
        arachne = duck_cost
    baseline = min(bq_cost, duck_cost)

    raw_save = baseline - arachne
    percent = 100 * ((baseline - arachne) / baseline)

    bq_save = bq_cost - arachne
    bq_percent = 100 * ((bq_cost - arachne) / bq_cost)
    duck_save = duck_cost - arachne
    duck_percent = 100 * ((duck_cost - arachne) / duck_cost)

    abs_savings.append(raw_save)
    abs_bq_savings.append(bq_save)
    rel_savings.append(percent)
    rel_bq_savings.append(bq_percent)
    abs_duck_savings.append(duck_save)
    rel_duck_savings.append(duck_percent)

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
        "Absolute Savings wrt Cheapest Baseline Per Query, DuckDB vs BQ", "abs_all.png")
graph(X, keys, rel_savings, "Percent Savings (%)", 
        "Relative Savings wrt Cheapest Baseline Per Query, DuckDB vs BQ", "rel_all.png")
graph(X, keys, abs_bq_savings, "Absolute Savings ($)", 
        "Absolute Savings wrt BigQuery Per Query, DuckDB vs BQ", "abs_bq.png")
graph(X, keys, rel_bq_savings, "Percent Savings (%)", 
        "Relative Savings wrt BigQuery Per Query, DuckDB vs BQ", "rel_bq.png")
graph(X, keys, abs_duck_savings, "Absolute Savings ($)", 
        "Absolute Savings wrt DuckDB Per Query, DuckDB vs BQ", "abs_duck.png")
graph(X, keys, rel_duck_savings, "Percent Savings (%)", 
        "Relative Savings wrt DuckDB Per Query, DuckDB vs BQ", "rel_duck.png")
