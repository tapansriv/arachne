import matplotlib.pyplot as plt
from itertools import accumulate
import numpy as np
import pandas as pd
import json
import sys
from table_names import tpcds_names
from argparse import ArgumentParser

parser = ArgumentParser(description="Graph Time Series")
parser.add_argument("--duck", action="store_true", help="Use DuckDB in Analysis")
parser.add_argument("--aws", action="store_true", help="Egress cost")
parser.add_argument("--legend", action="store_true", help="Print legend flag")
args = parser.parse_args()

dirs = ["100", "800", "900", "1000", "1100", "1200", "2000"]
prof_data = {}
no_prof_data = {}
CS = 4

start = "GCP"
egress = 0.12
if args.aws:
    start = "AWS"
    egress = 0.09

presentation_color = "#DFE5D2"
# plt.rcParams['axes.facecolor'] = presentation_color
# plt.rcParams['savefig.facecolor'] = presentation_color

fname = "noduck"
duck_txt = ""
if args.duck:
    fname = "duck"
    duck_txt = "_1.48"

rs_cost = int(CS) * 1.086

arachne_color  = "#ecae17"
bq_color = "#455984"
duck_color = "#a12721"
duck_c_color = "#577836"
duck_no_cut_color = "#c85327"

font = {'size' : 12}

for dir_ in dirs:
    filename = f"time_series/{dir_}/outputs_NOCALCITE_{fname}_{start}_{egress}_{rs_cost}_6.25{duck_txt}.json"
    # data = pd.read_json(filename).T
    data = json.load(open(filename))
    prof_data[dir_] = data

    filename = f"time_series/{dir_}/outputs_NOPROFILE_NOCALCITE_{fname}_{start}_{egress}_{rs_cost}_6.25{duck_txt}.json"
    # data = pd.read_json(filename).T
    data = json.load(open(filename))
    no_prof_data[dir_] = data


# for tbl in tpcds_names:
for tbl in ["catalog_returns"]:
    baseline_costs = []
    arachne_prof = []
    arachne_no_prof = []

    arachne_no_prof_np = []
    arachne_prof_np = []

    data_size = [int(d) for d in dirs]
    time = [i for i in range(len(dirs))]

    # xs = [int(x) for x in dirs]

    # print(tbl)
    for dir_ in dirs:
        bc   = prof_data[dir_][tbl]["baseline_cost"]
        pc   = prof_data[dir_][tbl]["arachne"] + prof_data[dir_][tbl]["profiling_cost"]
        pcnp = prof_data[dir_][tbl]["arachne"] 
        npc  = no_prof_data[dir_][tbl]["arachne"]
        arachne_no_prof_np.append(npc)
        print(f"{dir_}: {pcnp - npc}")
        if dir_ == "100":
            npc += no_prof_data[dir_][tbl]["profiling_cost"]
        # if dir_ != "100" and npc != pcnp:

        baseline_costs.append(bc)
        arachne_prof.append(pc)
        arachne_no_prof.append(npc)
        arachne_prof_np.append(pcnp)

    plt.rc('font', **font)

    fig = plt.figure(figsize=(6.5,2))
    ax1 = fig.subplots()
    ax2 = ax1.twiny()

    ax1.plot(time, arachne_prof_np, c=duck_color, 
             label="A-RP (No Profiling Costs)", marker='D', zorder=1, 
             linestyle='dashed')
    ax1.plot(time, baseline_costs, c=bq_color, marker='o', label="BQ", zorder=2)
    ax1.plot(time, arachne_prof, c=duck_color, label="A-RP", marker='D', zorder=1)
    ax1.plot(time, arachne_no_prof, c=arachne_color, label="A-1P", marker='x', zorder=3)

    base_tick_locs = [i for i in range(7)]
    ax1.set_xticks(base_tick_locs)
    ax1.set_xticklabels([i+1 for i in base_tick_locs])
    ax1.set_yticks([0, 100, 200, 300, 400])
    ax1.set_xlabel("Days")
    ax1.set_ylabel("Cost ($)")
    ax2.set_xlabel("Data Size (TB)")

    xts = ax1.get_xticks()
    x_min, x_max = ax1.get_xlim()
    ticks = [(tick - x_min)/(x_max - x_min) for tick in xts]

    ax2.set_xticks(ticks)
    ax2.set_xticklabels([float(x) / 1000 for x in dirs])

    ax1.legend(framealpha=0.5, frameon=False)
    handles, labels = ax1.get_legend_handles_labels()

    l1 = ax1.legend(handles[:1], labels[:1], loc='upper left',
                    bbox_to_anchor=(-0.02, 1.05), frameon=False)
    ax1.add_artist(l1)
    ax1.legend(handles[1:], labels[1:], ncol=2, loc='upper left',
               bbox_to_anchor=(-0.02, 0.92), frameon=False)

    # upper_limit = max(max(baseline_costs), max(arachne_opt), max(arachne_no_prof)) + 15
    # plt.ylim([0, upper_limit])

    outfile = f"graphs/time_series/time_series.pdf"
    plt.savefig(outfile, edgecolor='#d5d4c2',
            bbox_inches='tight')
    plt.close()






    # fig = plt.figure(figsize=(6.5,3.5))
    # ax1 = fig.subplots()
    # ax2 = ax1.twiny()

    # ax1.plot(time, arachne_no_prof_np, c=arachne_color, label="Arachne (Profile Once)", marker='x', 
    #          zorder=3)
    # ax1.plot(time, arachne_prof_np, c=duck_color, label="Arachne (Re-profiling)", marker='D', 
    #          zorder=1, linestyle='dashed')

    # # ax2.plot(time, baseline_costs, c=bq_color, marker='o', label="BigQuery", zorder=2)
    # # ax2.plot(time, arachne_opt, c=duck_color, label="Arachne (Re-profiling)", marker='D', zorder=1)
    # # ax2.plot(time, arachne_no_prof, c=arachne_color, label="Arachne (Profile Once)", marker='x', zorder=3)

    # ax1.set_xticks(base_tick_locs)
    # ax1.set_xticklabels([i+1 for i in base_tick_locs])
    # ax1.set_xlabel("Days")
    # ax1.set_ylabel("Cost ($)")
    # ax2.set_xlabel("Data Size (GB)")

    # xts = ax1.get_xticks()
    # y_min, y_max = ax1.get_xlim()
    # ticks = [(tick - y_min)/(y_max - y_min) for tick in xts]

    # ax2.set_xticks(ticks)
    # ax2.set_xticklabels(dirs)


    # # upper_limit = max(max(baseline_costs), max(arachne_opt), max(arachne_no_prof)) + 15
    # # plt.ylim([0, upper_limit])

    # if args.legend:
    #     plt.legend()

    # outfile = f"graphs/time_series/{tbl}_plan.pdf"
    # plt.savefig(outfile, edgecolor='#d5d4c2',
    #         bbox_inches='tight', dpi=1200)
    # plt.close()




