import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys
import os

def graph_broken(df, title, outfile, ylim1, ylim2, ymax):
    arachne_color = "#ecae17"
    bq_color = "#455984"
    rs_color = "#a12721"
    num_qs = len(df)
    ind = np.arange(num_qs)
    width = 0.25

    plt.rcParams['xtick.labelsize'] = 6
    plt.rcParams['ytick.labelsize'] = 8
    fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
    fig.subplots_adjust(hspace=0.05)  # adjust space between axes
    rect1 = ax1.bar(ind, df.arachne, width, color=arachne_color, label="Arachne")
    rect2 = ax1.bar(ind + width, df.baseline, width, color=rs_color, label="Redshift")

    rect1 = ax2.bar(ind, df.arachne, width, color=arachne_color, label="Arachne")
    rect2 = ax2.bar(ind + width, df.baseline, width, color=rs_color, label="Redshift")

    # ax1.set_ylabel("Cost ($)")
    plt.xticks(ind + width/2)
    ax1.set_title(title)
    ax2.set_xlabel('Query Number')
    ax2.set_xticklabels(df['keys'])

    ax1.legend()

    # zoom-in / limit the view to different portions of the data
    ax1.set_ylim(ylim2, ymax)  # outliers only
    ax2.set_ylim(0, ylim1)  # most of the data

    # hide the spines between ax1 and ax2
    ax1.spines['bottom'].set_visible(False)
    ax2.spines['top'].set_visible(False)
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
    figure = plt.gcf()
    figure.set_size_inches(8, 6)
    plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
    plt.close()

def graph_df(df, labels, colors, keys, title, outfile):
    arachne_color = "#ecae17"
    bq_color = "#455984"
    rs_color = "#a12721"
    num_qs = len(df)
    ind = np.arange(num_qs)
    width = 0.25

    plt.rcParams['xtick.labelsize'] = 6
    plt.rcParams['ytick.labelsize'] = 8
    fig, ax = plt.subplots()

    rect1 = ax.bar(ind, df.arachne, width, color=arachne_color, label="Arachne")
    rect2 = ax.bar(ind + width, df.baseline, width, color=rs_color, label="Baseline")
    # rect3 = ax.bar(ind + 2*width, df.bq, width, color=bq_color, label="BigQuery")
    
    # add some text for labels, title and axes ticks
    # ax.set_ylabel("Cost ($)")
    ax.set_xticks(ind + width/2)
    ax.set_title(title)
    ax.set_xlabel('Query Number')

    ax.set_xticklabels(df['keys'])
    ax.legend()
    # ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
    
    # plt.show()
    figure = plt.gcf()
    figure.set_size_inches(8, 6)
    plt.savefig(outfile, dpi=200, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
    plt.close()

if __name__ == '__main__':
    dir_ = sys.argv[1]
    home = os.path.expanduser("~")
    os.chdir(f"{home}/arachneDB/{dir_}/worked")
    f = open("processed_profile.json")
    baselines = json.load(open("processed_data.json"))
    raw = json.load(f)

    keys = []

    arachne_costs = []
    found_hybrid = []
    baseline_costs = []
    for k in raw:
        if k not in baselines:
            continue

        vals = raw[k]
        b = baselines[k]
        keys.append(k)
        
        cost = vals['total'] + b['rs_cost']  + b['rs_c_cost']

        num = vals['len'] + 2
        if num == 4:
            found_hybrid.append(0)
        else: 
            found_hybrid.append(1)

        comp = baselines[k]['rs_cost']
        comp = comp * num

        arachne_costs.append(cost)
        baseline_costs.append(comp)

    total_data = np.array([keys, baseline_costs, arachne_costs]).T
    arachne_color = "#ecae17"
    bq_color = "#455984"
    rs_color = "#a12721"

    dic = {"keys":keys, "baseline": baseline_costs, "arachne":arachne_costs,
            "hybrid": found_hybrid}
    df = pd.DataFrame(dic)
    print(len(df))

    # labels = ["BigQuery", "Redshift", "Arachne"]
    # title = "Arachne, BigQuery, and Redshift Cost per query ($)"
    # colors = [bq_color, rs_color, arachne_color]
    # outfile = "profile_cluster1.png"
    # graph_df(df, labels, colors, keys, title, outfile)
    df_hybrid = df[df.arachne > df.baseline]
    df_static = df[df.arachne <= df.baseline]
    print(len(df_hybrid))
    print(len(df_static))

    print(list(df_static['keys']))

    labels = ["BigQuery", "Redshift", "Arachne"]
    title = "Arachne Profiling Cost ($) versus Equivalent Redshift Runs (Profile More Expensive)"
    colors = [bq_color, rs_color, arachne_color]
    outfile = "rs_profile_expensive.png"
    graph_df(df_hybrid, labels, colors, keys, title, outfile)

    title = "Arachne Profiling Cost ($) versus Equivalent Redshift Runs (Profile Cheaper)"
    outfile = "rs_profile_cheaper.png"
    graph_broken(df_static, title, outfile, .5, .5, 7)

