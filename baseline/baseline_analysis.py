import json
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

def graph_df(keys, vals, title, outfile):
    arachne_color = "#ecae17"
    # bq_color = "#455984"
    # duck_color = "#a12721"

    # duck_rel_color = "#c85327"
    # bq_rel_color = "#577836"

    num_qs = len(keys)
    ind = np.arange(num_qs)
    width = 0.25

    plt.rcParams['xtick.labelsize'] = 4
    plt.rcParams['ytick.labelsize'] = 8
    fig, ax = plt.subplots()
    rect1 = ax.bar(ind, vals, width, color=arachne_color, label="Arachne wrt DuckDB")
    
    # add some text for labels, title and axes ticks
    ax.set_ylabel("Price Difference Raw versus Calcite ($)")
    ax.set_xticks(ind + width/2)
    ax.set_title(title)
    ax.set_xlabel('Query Number')

    ax.set_xticklabels(keys)
    ax.legend()

    # plt.show()
    figure = plt.gcf()
    figure.set_size_inches(8, 6)
    plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
    plt.close()

def analyze_single_system(f, exclude=False):
    print(f"-----------{f}-----------")
    if f == "rs":
        cost = 1.086
    else: 
        cost = 1.48

    duck = json.load(open(f"{f}_baseline.json"))
    duck_c = json.load(open(f"{f}_c_baseline.json"))
    bq = json.load(open("bigquery_baseline.json"))
    
    
    duck_total = 0
    duck_c_total = 0
    bq_total = 0
    min_total = 0
    
    duck_better = []
    duck_better2 = []
    duck_c_better = []
    bq_better = []
    
    count = 0

    query_labels = []
    diffs = []
    for k in duck:
        if k not in duck_c or k not in bq:
            continue
        if exclude and k == "67":
            continue
        count += 1
        r1 = duck[k]
        r2 = duck_c[k]
        s = bq[k]["bytes"] / 1_000_000_000_000
        c1 = (r1 / 3600) * cost
        c2 = (r2 / 3600) * cost

        diff = (c1 - c2)
        pdiff = 100 * ((c1 - c2) / c1)
        query_labels.append(k)
        diffs.append(diff)

        cs = s * 5
        m = min(c1, c2, cs)
        print(f"{k}: {c1}, {c2}, {cs}, {pdiff}%, {diff}")
        duck_total += c1
        duck_c_total += c2
        bq_total += cs
        min_total += m
    
        if c1 < cs:
            duck_better.append(k)
        elif cs < c1: 
            bq_better.append(k)
        else:
            print(f"{k} equal")

        if c2 < c1:
            duck_c_better.append(k)
        else: 
            duck_better2.append(k)

    print(f"{duck_total}, {duck_c_total}, {bq_total}, {min_total}")
    print(count)
    print(len(duck_better))
    print(len(bq_better))

    print(len(duck_better2))
    print(len(duck_c_better))
    if f == "rs":
        title = "Redshift Savings (Raw - Calcite) per Query"
        outfile = "rs_savings.png"
        graph_df(query_labels, diffs, title, outfile)
    else:
        title = "DuckDB Savings (Raw - Calcite) per Query"
        outfile = "duck_savings.png"
        graph_df(query_labels, diffs, title, outfile)

def compare_rs_duck(exclude=False):
    if exclude: 
        print("only looking at raw")
    duck = json.load(open(f"duck_baseline.json"))
    duck_c = json.load(open(f"duck_c_baseline.json"))
    rs = json.load(open(f"rs_baseline.json"))
    rs_c = json.load(open(f"rs_c_baseline.json"))
    bq = json.load(open("bigquery_baseline.json"))
    
    duck_total = 0
    duck_c_total = 0
    bq_total = 0
    rs_total = 0
    rs_c_total = 0
    min_total = 0
    
    duck_better = []
    rs_better = []

    keys = duck.keys() & duck_c.keys() & rs.keys() & rs_c.keys()
    if exclude: 
        keys = duck.keys() & rs.keys()
    print(len(keys))
    for k in keys:
        dr1 = duck[k]
        rsr1 = rs[k]
        cd1 = (dr1 / 3600) * 1.48
        crs1 = (rsr1 / 3600) * 1.086
        s = bq[k]["bytes"] / 1_000_000_000_000
        cs = s * 5
        vals = [cd1, crs1, cs]
        if not exclude: 
            dr2 = duck_c[k]
            rsr2 = rs_c[k]
            cd2 = (dr2 / 3600) * 1.48
            crs2 = (rsr2 / 3600) * 1.086
            vals.extend([cd2, crs2])
            duck_c_total += cd2
            rs_c_total += crs2
            
        m = min(vals)
        if exclude: 
            print(f"{k}: {cd1}, {crs1}, {cs}")
        else:
            print(f"{k}: {cd1}, {cd2}, {crs1}, {crs2}, {cs}")

        duck_total += cd1
        rs_total += crs1
        bq_total += cs
        min_total += m
    
        if cd1 < crs1:
            duck_better.append(k)
        elif crs1 < cd1: 
            rs_better.append(k)
        else:
            print(f"{k} equal")
    
    if exclude:
        print(f"{duck_total}, {rs_total}, {bq_total}, {min_total}")
    else: 
        print(f"{duck_total}, {duck_c_total}, {rs_total}, {rs_c_total}, {bq_total}, {min_total}")
    print(len(duck_better))
    print(len(rs_better))

if __name__ == '__main__':
    compare_rs_duck()
    compare_rs_duck(exclude=True)
    analyze_single_system("duck")
    analyze_single_system("duck", exclude=True)
    analyze_single_system("rs")

