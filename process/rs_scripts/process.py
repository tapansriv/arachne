import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import json
import os
import sys

def get_totals(df: pd.DataFrame):
    a_cost = df.arachne.sum()
    rs_cost = df.rs.sum()
    rs_c_cost = df.rs_c_costs.sum()

    return (a_cost, rs_cost, rs_c_cost)


def get_savings(df: pd.DataFrame, prefix: str):
    a, rs, rs_c = get_totals(df)
    print(f"{a} {rs} {rs_c}")
    # print(f"{prefix} Arachne Cost: {a}")
    # print(f"{prefix} DuckDB Cost: {rs}; DuckDB Savings: {rs - a}")
    # print(f"{prefix} DuckDB-Calcite Cost: {rs_c}; DuckDB-Calcite Savings: {rs_c - a}")
    # print(f"{prefix} BigQuery Cost: {bq}; BigQuery Savings: {bq - a}")

    # print(f"{prefix} DuckDB Savings: {rs - a}")
    # print(f"{prefix} DuckDB-Calcite Savings (DuckDB): {rs_c - a}")
    # print(f"{prefix} BigQuery Savings: {bq - a}")


if __name__ == '__main__':
    dir_ = sys.argv[1]
    home = os.path.expanduser("~")
    os.chdir(f"{home}/arachneDB/{dir_}/worked")
    f = open("processed_data.json")
    raw = json.load(f)

    keys = []
    arachne_costs = []
    rs_c_costs = []
    rs_costs = []
    min_baselines = []

    for k in raw:
        keys.append(k)
        perf = raw[k]
        arachne = perf["arachne_cost"]
        rs_cost = perf["rs_cost"]
        rs_c_cost = perf["rs_c_cost"]

        min_baseline = min(rs_cost, rs_c_cost)
        if arachne == -1:
            arachne = min_baseline

        arachne_costs.append(arachne)
        rs_costs.append(rs_cost)
        rs_c_costs.append(rs_c_cost)
        min_baselines.append(min_baseline)

    dic = {"keys":keys, "rs": rs_costs,
            "arachne":arachne_costs, "rs_c_costs": rs_c_costs, 
            "min_baselines": min_baselines}

    df = pd.DataFrame(dic)
    df_hybrid = df[df.arachne != df.min_baselines]

    get_savings(df, "Total")
    get_savings(df_hybrid, "Hybrid Queries")
