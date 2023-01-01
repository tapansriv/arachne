import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys
import os

def graph_broken(df, labels, colors, keys, title, outfile):
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
    rect1 = ax1.bar(ind, df.rs, width, color=arachne_color, label="Arachne wrt Redshift")
    rect2 = ax1.bar(ind + width, df.bq, width, color=rs_color, label="Arachne Savings wrt BigQuery")

    rect1 = ax2.bar(ind, df.arachne, width, color=arachne_color, label="Arachne")
    rect2 = ax2.bar(ind + width, df.rs, width, color=rs_color, label="Redshift")
    rect3 = ax2.bar(ind + 2*width, df.bq, width, color=bq_color, label="BigQuery")

    # ax1.set_ylabel("Cost ($)")
    plt.xticks(ind + width)
    ax1.set_title(title)
    ax2.set_xlabel('Query Number')
    ax2.set_xticklabels(df['keys'])

    ax1.legend()

    # zoom-in / limit the view to different portions of the data
    ax1.set_ylim(3, 25)  # outliers only
    ax2.set_ylim(0, 3)  # most of the data

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

    rs_rel_color = "#c85327"
    bq_rel_color = "#577836"

    num_qs = len(df)
    ind = np.arange(num_qs)
    width = 0.25

    plt.rcParams['xtick.labelsize'] = 6
    plt.rcParams['ytick.labelsize'] = 8
    fig, ax = plt.subplots()

    rect1 = ax.bar(ind, df.rs, width, color=rs_rel_color, label="Arachne wrt Redshift")
    rect2 = ax.bar(ind + width, df.bq, width, color=bq_rel_color, label="Arachne Savings wrt BigQuery")
    
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
    f = open("processed_data.json")
    raw = json.load(f)

    keys = []
    bq_savings = []
    rs_savings = []
    for k in raw:
        keys.append(k)
        perf = raw[k]
        arachne_cost = perf["arachne_cost"]
        if arachne_cost == -1:
            arachne_cost = perf["rs_cost"]
        rs_cost = perf["rs_cost"]
        bq_cost = perf["bq_cost"]
        # print(f"{k}: {arachne_cost}, {rs_cost}, {bq_cost}")
        bq_percent = 100 * ((bq_cost - arachne_cost) / bq_cost)
        rs_percent = 100 * ((rs_cost - arachne_cost) / rs_cost)
        bq_savings.append(bq_percent)
        rs_savings.append(rs_percent)

    arachne_color = "#ecae17"
    bq_color = "#455984"
    rs_color = "#a12721"

    dic = {"keys":keys, "bq": bq_savings, "rs": rs_savings}
    df = pd.DataFrame(dic)
    print(len(df))

    df_static = df[df.rs == 0]
    df_hybrid = df[df.rs != 0]
    print(len(df_hybrid))
    print(len(df_static))

    labels = ["BigQuery", "Redshift", "Arachne"]
    title = "Arachne Percent Savings versus Redshift, BigQuery"
    colors = [bq_color, rs_color, arachne_color]
    outfile = "rs_rel_cluster1.png"
    graph_df(df_static, labels, colors, keys, title, outfile)

    outfile = "rs_rel_cluster2.png"
    graph_df(df_hybrid, labels, colors, keys, title, outfile)

