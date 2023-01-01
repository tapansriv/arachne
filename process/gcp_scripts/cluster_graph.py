import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys
import os

def graph_broken(df, labels, colors, keys, title, outfile):
    arachne_color = "#ecae17"
    bq_color = "#455984"
    duck_color = "#a12721"
    duck_c_color = "#577836"
    duck_no_cut_color = "#c85327"

    num_qs = len(df)
    ind = np.arange(num_qs)
    width = 0.18

    plt.rcParams['xtick.labelsize'] = 6
    plt.rcParams['ytick.labelsize'] = 8
    fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
    fig.subplots_adjust(hspace=0.05)  # adjust space between axes
    rect1 = ax1.bar(ind, df.arachne, width, color=arachne_color, label="Arachne")
    rect2 = ax1.bar(ind + width, df.duck, width, color=duck_color, label="DuckDB")
    rect3 = ax1.bar(ind + 2*width, df.bq, width, color=bq_color, label="BigQuery")
    rect4 = ax1.bar(ind + 3*width, df.duck_c_costs, width, color=duck_c_color, label="DuckDB-Calcite")
    if "show" not in outfile:
        rect5 = ax1.bar(ind + 4*width, df.duck_cut_no_hybrid, width, color=duck_no_cut_color, label="DuckDB-Cut")

    rect1 = ax2.bar(ind, df.arachne, width, color=arachne_color, label="Arachne")
    rect2 = ax2.bar(ind + width, df.duck, width, color=duck_color, label="DuckDB")
    rect3 = ax2.bar(ind + 2*width, df.bq, width, color=bq_color, label="BigQuery")
    rect4 = ax2.bar(ind + 3*width, df.duck_c_costs, width, color=duck_c_color, label="DuckDB-Calcite")
    if "show" not in outfile:
        rect5 = ax2.bar(ind + 4*width, df.duck_cut_no_hybrid, width, color=duck_no_cut_color, label="DuckDB-Cut")

    # ax1.set_ylabel("Cost ($)")
    plt.xticks(ind + 2*width)
    ax1.set_title(title)
    ax2.set_xlabel('Query Number')
    ax2.set_xticklabels(df['keys'])

    ax1.legend()

    # zoom-in / limit the view to different portions of the data
    ax1.set_ylim(4.6, 22)  # outliers only
    ax2.set_ylim(0, 1.85)  # most of the data

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
    duck_color = "#a12721"
    duck_c_color = "#577836"
    duck_no_cut_color = "#c85327"

    num_qs = len(df)
    ind = np.arange(num_qs)
    width = 0.18

    plt.rcParams['xtick.labelsize'] = 6
    plt.rcParams['ytick.labelsize'] = 8
    fig, ax = plt.subplots()

    rect1 = ax.bar(ind, df.arachne, width, color=arachne_color, label="Arachne")
    rect2 = ax.bar(ind + width, df.duck, width, color=duck_color, label="DuckDB")
    rect3 = ax.bar(ind + 2*width, df.bq, width, color=bq_color, label="BigQuery")
    rect4 = ax.bar(ind + 3*width, df.duck_c_costs, width, color=duck_c_color, label="DuckDB-Calcite")
    if "show" not in outfile:
        rect5 = ax.bar(ind + 4*width, df.duck_cut_no_hybrid, width, color=duck_no_cut_color, label="DuckDB-Cut")
    
    # add some text for labels, title and axes ticks
    # ax.set_ylabel("Cost ($)")
    ax.set_xticks(ind + 2*width)
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
    f = open("processed_data.json")
    raw = json.load(f)

    keys = []

    arachne_costs = []
    bq_costs = []
    duck_costs = []
    duck_c_costs = []
    duck_cut_no_hybrid_costs = []
    cheapest_baseline_costs = []

    for k in raw:
        keys.append(k)
        perf = raw[k]
        arachne_cost = perf["arachne_cost"]
        duck_cost = perf["duck_cost"]
        bq_cost = perf["bq_cost"]
        duck_c_cost = perf["duck_c_cost"]
        duck_cut_no_hybrid = perf["duck_cut_no_hybrid"]
        # print(f"{k}: {arachne_cost}, {rs_cost}, {bq_cost}")
        cheapest_baseline = min(bq_cost, duck_cost, duck_c_cost)

        if arachne_cost == -1:
            arachne_cost = cheapest_baseline

        arachne_costs.append(arachne_cost)
        bq_costs.append(bq_cost)
        duck_costs.append(duck_cost)
        cheapest_baseline_costs.append(cheapest_baseline)
        duck_c_costs.append(duck_c_cost)
        duck_cut_no_hybrid_costs.append(duck_cut_no_hybrid)

    arachne_color = "#ecae17"
    bq_color = "#455984"
    duck_color = "#a12721"

    # maxs = []
    # N = len(bq_costs)
    # for i in range(N):
    #     m = max(bq_costs[i], rs_costs[i], arachne_costs[i])
    #     maxs.append(m)

    # total_data = np.array([keys, bq_costs, rs_costs, arachne_costs, maxs]).T

    dic = {"keys":keys, "bq": bq_costs, "duck": duck_costs,
            "arachne":arachne_costs, "duck_c_costs": duck_c_costs,
            "duck_cut_no_hybrid": duck_cut_no_hybrid_costs, 
            "min_baseline": cheapest_baseline_costs}
    df = pd.DataFrame(dic)
    print(len(df))
    # df_small = df[df.maxs < 0.6]
    # df_big = df[df.maxs >= 0.6]
    # print(len(df_small))
    # print(len(df_big))

    df_static = df[df.arachne == df.min_baseline]
    df_hybrid = df[df.arachne != df.min_baseline]

    print(len(df_hybrid))
    print(len(df_static))
    df_true = df[df.arachne < df.duck_cut_no_hybrid]
    print(len(df_true))

    labels = ["BigQuery", "DuckDB", "DuckDB-Calcite", "DuckDB-Cut", "Arachne"]
    title = "Final Plan Costs for Each System per query ($)--No Hybrid Plan"
    colors = [bq_color, duck_color, arachne_color]
    outfile = "gcp_static_show.png"
    graph_df(df_static, labels, colors, keys, title, outfile)

    title = "Final Plan Costs for Each System per query ($)--Hybrid Plans"
    outfile = "gcp_hybrids_show.png"
    graph_broken(df_hybrid, labels, colors, keys, title, outfile)

