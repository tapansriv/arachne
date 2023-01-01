import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys 
import os

def graph_broken(df, labels, colors, vals, keys, title, outfile):
    num_qs = len(df)
    ind = np.arange(num_qs)
    width = 0.18

    plt.rcParams['xtick.labelsize'] = 6
    plt.rcParams['ytick.labelsize'] = 8
    fig, (ax1, ax2) = plt.subplots(2, 1, sharex=True)
    fig.subplots_adjust(hspace=0.05)  # adjust space between axes

    rect1 = ax1.bar(ind, df[vals[0]], width, color=colors[0], label=labels[0])
    rect2 = ax1.bar(ind + width, df[vals[1]], width, color=colors[1], label=labels[1])
    rect3 = ax1.bar(ind + 2*width, df[vals[2]], width, color=colors[2], label=labels[2])
    if len(labels) == 4:
        rect4 = ax1.bar(ind + 3*width, df[vals[3]], width, color=colors[3], label=labels[3])

    rect1 = ax2.bar(ind, df[vals[0]], width, color=colors[0], label=labels[0])
    rect2 = ax2.bar(ind + width, df[vals[1]], width, color=colors[1], label=labels[1])
    rect3 = ax2.bar(ind + 2*width, df[vals[2]], width, color=colors[2], label=labels[2])
    if len(labels) == 4:
        rect4 = ax2.bar(ind + 3*width, df[vals[3]], width, color=colors[3], label=labels[3])

    plt.xticks(ind + 3*width/2)
    ax1.set_title(title)
    ax2.set_xlabel('Query Number')
    ax2.set_xticklabels(df['keys'])

    ax1.legend()

    # zoom-in / limit the view to different portions of the data
    ax1.set_ylim(3900, 55000)  # outliers only
    ax2.set_ylim(0, 2000)  # most of the data

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

def graph_runtime(arr, labels, colors, keys, title, outfile):
    num_qs, num_cols = arr.shape
    ind = np.arange(num_qs)
    width = 0.3
    fig, ax = plt.subplots()

    for i in range(num_cols):
        rects = ax.bar(ind + i*width, arr[:,i], width, color=colors[i], label=labels[i])
    
    # add some text for labels, title and axes ticks
    ax.set_xticks(ind + width/3)
    ax.set_title(title)
    ax.set_xlabel('Query Number')

    ax.set_xticklabels(keys)
    ax.legend(loc='center left', bbox_to_anchor=(1, 0.5))
    
    figure = plt.gcf()
    figure.set_size_inches(16, 9)
    plt.savefig(outfile, dpi=100, facecolor=fig.get_facecolor(), edgecolor='#d5d4c2')
    plt.close()

def graph_df(df, labels, colors, vals, keys, title, outfile):
    num_qs = len(df)
    ind = np.arange(num_qs)
    width = 0.18

    plt.rcParams['xtick.labelsize'] = 6
    plt.rcParams['ytick.labelsize'] = 8
    fig, ax = plt.subplots()

    rect1 = ax.bar(ind, df[vals[0]], width, color=colors[0], label=labels[0])
    rect2 = ax.bar(ind + width, df[vals[1]], width, color=colors[1], label=labels[1])
    rect3 = ax.bar(ind + 2*width, df[vals[2]], width, color=colors[2], label=labels[2])
    if len(labels) == 4:
        rect4 = ax.bar(ind + 3*width, df[vals[3]], width, color=colors[3], label=labels[3])

    # add some text for labels, title and axes ticks
    ax.set_xticks(ind + 3*width/2)
    ax.set_title(title)
    ax.set_ylabel("Runtime (s)")
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
    f = open("processed_runtime.json")
    raw = json.load(f)

    label = None
    fkey = None
    if dir_.startswith("gcp"):
        label = "DuckDB"
        fkey = "gcp"
    elif dir_.startswith("rs"):
        label = "Redshift"
        fkey = "rs"
        
    keys = []

    arachne_times = []
    bq_times = []
    baseline_times = []
    baseline_c_times = []
    failed_vals = []

    for k in raw:
        keys.append(k)
        perf = raw[k]
        arachne_time = perf["arachne_time"]
        baseline_time = perf["baseline_time"]
        baseline_c_time = perf["baseline_calcite_time"]
        bq_time = perf["bq_time"]
        failed = perf["failed"]
        # print(f"{k}: {arachne_time}, {baseline_time}, {bq_time}")

        arachne_times.append(arachne_time)
        bq_times.append(bq_time)
        baseline_times.append(baseline_time)
        baseline_c_times.append(baseline_c_time)
        failed_vals.append(failed)

    dic = {"keys":keys, "bq": bq_times, "baseline": baseline_times,
            "arachne":arachne_times, "baseline_calcite": baseline_c_times, 
            "failed": failed_vals}
    df = pd.DataFrame(dic)
    print(len(df))

    df_static = df[df.failed == 1]
    df_hybrid = df[df.failed == 0]
    # df_hybrid = df_hybrid[df_hybrid['keys'] != '67']
    print(len(df_hybrid))
    print(len(df_static))

    arachne_color = "#ecae17"
    bq_color = "#455984"
    b_color = "#a12721"
    b_c_color = "#577836"

    labels = None
    title = None
    colors = None
    vals = None
    if dir_.startswith("gcp"):
        labels = ["Arachne", label, "BigQuery", f"{label}-Calcite"]
        vals = ["arachne", "baseline", "bq", "baseline_calcite"]
        title = f"Arachne, BigQuery, {label}, and {label}-Calcite runtime per query (seconds)"
        colors = [arachne_color, b_color, bq_color, b_c_color]
    else:
        labels = ["Arachne", label, f"{label}-Calcite"]
        vals = ["arachne", "baseline", "baseline_calcite"]
        title = f"Arachne, {label}, and {label}-Calcite runtime per query (seconds)"
        colors = [arachne_color, b_color, b_c_color]

    outfile = f"{fkey}_times_hybrids.png"
    graph_df(df_hybrid, labels, colors, vals, keys, title, outfile)
    # graph_broken(df_hybrid, labels, colors, keys, title, outfile)

    outfile = f"{fkey}_times_statics.png"
    graph_df(df_static, labels, colors, vals, keys, title, outfile)

    # labels = ["BigQuery", "Arachne"]
    # title = "Arachne versus BigQuery time per query (seconds)"
    # outfile = "times_a_bq.png"
    # colors = [bq_color, arachne_color]
    # graph_runtime(a_bq, labels, colors, keys, title, outfile)

    # labels = ["DuckDB", "Arachne"]
    # title = "Arachne versus DuckDB cost per query ($)"
    # outfile = "raw_a_duck.png"
    # colors = [rs_color, arachne_color]
    # graph_runtime(a_rs, labels, colors, keys, title, outfile)


