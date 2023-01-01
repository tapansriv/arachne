import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import sys
import os

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

    dic = {"keys":keys, "bq": bq_costs, "duck": duck_costs,
            "arachne":arachne_costs, "duck_c_costs": duck_c_costs,
            "duck_cut_no_hybrid": duck_cut_no_hybrid_costs, 
            "min_baseline": cheapest_baseline_costs}
    df = pd.DataFrame(dic)
    print(len(df))

    df_static = df[df.arachne == df.min_baseline]
    df_hybrid = df[df.arachne != df.min_baseline]

    print(len(df_hybrid))
    print(len(df_static))
    print('------')
    df_true = df[df.arachne < df.duck_cut_no_hybrid]
    print(len(df_true))
    print(df_true)
