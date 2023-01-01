import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import os
import sys


class Baselines:
    def __init__(self, dir_: str, run_cost: float):
        home = os.path.expanduser("~")
        self.run_cost = run_cost
        f1 = None
        f2 = None
        f3 = open(f"{home}/arachneDB/baseline/bigquery_baseline.json")
        self.bq_baseline = json.load(f3)
        if "rs" in dir_:
            self.duck = False
            f1 = open(f"{home}/arachneDB/baseline/rs_baseline.json")
            f2 = open(f"{home}/arachneDB/baseline/rs_c_baseline.json")
        else:
            self.duck = True
            f1 = open(f"{home}/arachneDB/baseline/duck_baseline.json")
            f2 = open(f"{home}/arachneDB/baseline/duck_c_baseline.json")

        self.baseline = json.load(f1)
        self.baseline_c = json.load(f2)


    def get_baseline_string(self, k):
        c1 = (self.baseline[k] / 3600) * self.run_cost
        c2 = (self.baseline_c[k] / 3600) * self.run_cost
        bq_val = self.bq_baseline[k]["bytes"]
        c3 = (bq_val / 1000000000) * 0.005

        return f"{c3}, {c1}"

    def check_cost(self, k, cost):
        c1 = (self.baseline[k] / 3600) * self.run_cost
        c2 = (self.baseline_c[k] / 3600) * self.run_cost
        bq_val = self.bq_baseline[k]["bytes"]
        c3 = (bq_val / 1000000000) * 0.005
        
        c = min(c1, c2)
        if self.duck:
            c = min(c1, c2, c3)

        if cost < c:
            return True
        else:
            return False


def process_key(k, baselines, run_cost, mv_cost, silent):
    fp = open(f"{k}.data")
    for l in fp.readlines():
        data = json.loads(l)
        new_run_cost = (data["runtime"]/3600) * run_cost
        bq_cost = data["bqCost"]
        new_mvmt_cost = data["compressed"] * mv_cost
        cost = new_run_cost + new_mvmt_cost + bq_cost

        if baselines.check_cost(k, cost):
            baseline_str = baselines.get_baseline_string(k)
            cost_cut_no_hybrid = (data["cutNoHybrid"]/3600) * run_cost
            if not silent:
                print(f"{k}, {cost}, {baseline_str}, {cost_cut_no_hybrid}")
            return True
    return False

if __name__ == '__main__':
    dir_ = sys.argv[1]
    run_cost = float(sys.argv[2])
    mv_cost = float(sys.argv[3])

    silent = False
    if len(sys.argv) > 4:
        silent = (sys.argv[4] == 's')

    baselines = Baselines(dir_, run_cost)

    home = os.path.expanduser("~")
    os.chdir(f"{home}/arachneDB/{dir_}/worked")

    f = open("processed_data.json")
    raw = json.load(f)

    worked = 0
    for k in raw:
        if process_key(k, baselines, run_cost, mv_cost, silent):
            worked += 1
        elif not silent:
            print(f"{k},FAILED TO FIND PLAN")

    print(f"Hybrids Found: {worked}")
