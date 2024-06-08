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
parser.add_argument("--dir", help="Directory")
parser.add_argument("--legend", action="store_true", help="Print legend flag")
args = parser.parse_args()

CS = 1

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

font = {'size' : 19}

filename = f"estimation/{args.dir}/outputs_NOCALCITE_{fname}_{start}_{egress}_{rs_cost}_6.25{duck_txt}.json"
# data = pd.read_json(filename).T
prof_data = json.load(open(filename))

filename = f"estimation/{args.dir}/outputs_NOPROFILE_NOCALCITE_{fname}_{start}_{egress}_{rs_cost}_6.25{duck_txt}.json"
# data = pd.read_json(filename).T
est_data = json.load(open(filename))

data = []
if "io" in args.dir or "cpu" in args.dir or "mixed" in args.dir:
    arachne_prof = []
    arachne_est = []

    prof_pt = prof_data['all']["arachne"]
    est_pt = est_data['all']["arachne"]
    baseline_pt = prof_data['all']["baseline_cost"]
    arachne_prof.append(prof_pt)
    arachne_est.append(est_pt)
    
    data.append((prof_pt, est_pt))
    print(f"{baseline_pt}, {prof_pt} {est_pt}, {est_pt - prof_pt}, {est_pt / prof_pt} ")
else:
    for tbl in tpcds_names:
        # if tbl != "store_sales":
        #     continue
        arachne_prof = []
        arachne_est = []

        prof_pt = prof_data[tbl]["arachne"]
        est_pt = est_data[tbl]["arachne"]
        baseline_pt = prof_data[tbl]["baseline_cost"]
        arachne_prof.append(prof_pt)
        arachne_est.append(est_pt)
        
        data.append((prof_pt, est_pt))
        print(f"{baseline_pt}, {prof_pt} {est_pt}, {est_pt - prof_pt}, {est_pt / prof_pt} ")

    plt.rc('font', **font)

    # fig = plt.figure(figsize=(6.5,3.5))
    # ax = fig.subplots()
    # ax.plot(xs, arachne_opt, c=duck_color, label="Arachne (Profiling)", marker='D', zorder=1)
    # ax.plot(xs, arachne_est, c=arachne_color, label="Arachne (Estimation)", marker='x', zorder=3)
    # plt.xlabel("Data Size (GB)")
    # plt.ylabel("Cost ($)")


    x = np.arange(len(tpcds_names))  # the label locations
    width = 0.25  # the width of the bars
    multiplier = 0

    fig, ax = plt.subplots()

    offset = width * multiplier
    rects = ax.bar(x + offset, arachne_prof, width, label="Profiling")
    # ax.bar_label(rects, padding=3)
    multiplier += 1

    offset = width * multiplier
    rects = ax.bar(x + offset, arachne_est, width, label="Estimation")
    # ax.bar_label(rects, padding=3)
    multiplier += 1

    # Add some text for labels, title and custom x-axis tick labels, etc.
    # ax.set_ylabel('Length (mm)')
    # ax.set_title('Penguin attributes by species')
    ax.set_xticks(x + width, tpcds_names)
    # ax.set_ylim(0, 250)


    # upper_limit = max(max(baseline_costs), max(arachne_opt), max(arachne_no_prof)) + 15
    # plt.ylim([0, upper_limit])

    if args.legend:
        ax.legend(loc='upper left', ncols=3)
    plt.show()
    # outfile = f"graphs/estimation.pdf"
    # plt.savefig(outfile, edgecolor='#d5d4c2',
    #         bbox_inches='tight', dpi=1200)
    # plt.close()




