import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import os
import sys

def get_totals(df: pd.DataFrame):
    a_cost = df.arachne.sum()
    bq_cost = df.bq.sum()
    duck_cost = df.duck.sum()
    duck_c_cost = df.duck_c_costs.sum()
    min_baseline = df.min_baselines.sum()

    return (a_cost, bq_cost, duck_cost, duck_c_cost, min_baseline)


def get_savings(df: pd.DataFrame, prefix: str):
    a, bq, duck, duck_c, min_baseline = get_totals(df)
    print(f"{prefix}: {a} {duck} {duck_c} {bq} {min_baseline}")
    # print(f"{prefix} Arachne Cost: {a}")
    # print(f"{prefix} DuckDB Cost: {duck}; DuckDB Savings: {duck - a}")
    # print(f"{prefix} DuckDB-Calcite Cost: {duck_c}; DuckDB-Calcite Savings: {duck_c - a}")
    # print(f"{prefix} BigQuery Cost: {bq}; BigQuery Savings: {bq - a}")

    # print(f"{prefix} DuckDB Savings: {duck - a}")
    # print(f"{prefix} DuckDB-Calcite Savings (DuckDB): {duck_c - a}")
    # print(f"{prefix} BigQuery Savings: {bq - a}")


if __name__ == '__main__':

    ok = [2, 3, 7, 11, 12, 13, 15, 19, 20, 22, 26, 27, 28, 31, 33, 34, 37, 38, 39, 40, 42, 43, 46, 47, 48, 49, 50, 52, 53, 55, 56, 57, 59, 60, 62, 63, 66, 67, 68, 70, 73, 77, 79, 82, 83, 84, 87, 88, 89, 90, 91, 93, 96, 98, 99]

    other_keys = ["0"+str(x) if x < 10 else str(x) for x in ok]

    dir_ = sys.argv[1]
    home = os.path.expanduser("~")
    os.chdir(f"{home}/arachneDB/{dir_}/worked")
    f = open("processed_data.json")
    raw = json.load(f)

    keys = []
    arachne_costs = []
    duck_c_costs = []
    duck_costs = []
    bq_costs = []
    min_baselines = []

    for k in raw:
        keys.append(k)
        perf = raw[k]
        arachne = perf["arachne_cost"]
        duck_cost = perf["duck_cost"]
        duck_c_cost = perf["duck_c_cost"]
        bq_cost = perf["bq_cost"]

        min_baseline = min(duck_cost, duck_c_cost, bq_cost)
        if bq_cost < min(duck_cost, duck_c_cost):
            print(k)
        if arachne == -1:
            arachne = min_baseline

        arachne_costs.append(arachne)
        duck_costs.append(duck_cost)
        duck_c_costs.append(duck_c_cost)
        bq_costs.append(bq_cost)
        min_baselines.append(min_baseline)

    dic = {"keys":keys, "bq": bq_costs, "duck": duck_costs,
            "arachne":arachne_costs, "duck_c_costs": duck_c_costs, 
            "min_baselines": min_baselines}


    print(set(keys) - set(other_keys))
    print(set(other_keys) - set(keys))
    df = pd.DataFrame(dic)
    # print(df)
    print(df['keys'].isin(other_keys))
    df_final_results = df[df['keys'].isin(other_keys)]
    print(len(other_keys))
    print(df_final_results)
    df_hybrid = df[df.arachne != df.min_baselines]
    df_not_outlier = df[df['keys'] != '67']
    df2 = df_not_outlier[df.arachne != df.min_baselines]
    
    get_savings(df_final_results, "Final Results")
    get_savings(df_not_outlier, "Total (not 67)")
    get_savings(df, "Total")
    get_savings(df_hybrid, "Hybrid Queries")
    get_savings(df2, "Hybrid (not 67)")





