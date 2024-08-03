import duckdb
import os
import sys
import time
import pandas as pd


def run_original(key):
    con1 = duckdb.connect(f"orig_{key}.db")
    home = os.path.expanduser("~")
    f = open(f"{home}/arachne/p_queries/{key}.sql")
    orig_qry = "".join(f.readlines())
    print(f"starting original query {key}")
    start = time.time()
    res = con1.execute(orig_qry)
    runtime = time.time() - start
    df_orig = res.fetchdf()
    print(f"finished original query {key}; elapsed time: {runtime}")
    return df_orig


def run_cut(key, num):
    home = os.path.expanduser("~")
    dfs = []
    for i in range(1, num + 1):
        trial_val = f"{key}_{i}"
        con2 = duckdb.connect(f"cut_{trial_val}.db")

        ft = open(f"{home}/arachne/p_queries/{trial_val}.sql")
        qry = "".join(ft.readlines())
        print(f"starting cut query {trial_val}")
        start = time.time()
        res = con2.execute(qry)
        runtime = time.time() - start
        test = res.fetchdf()
        print(f"finished cut query {trial_val}; elapsed time: {runtime}")

        dfs.append(test)
    return dfs

def validate_dfs(df_orig, dfs):
    for trial_val, df in enumerate(dfs):
        val = df_orig.equals(df)
        print(f"{trial_val+1} is same as original result: {val}")



if __name__ == '__main__':
    key = sys.argv[1]
    num = int(sys.argv[2]) # how many cuts were tried. how many sql files to look for
    order = int(sys.argv[3]) # 0 -> original first,  1 -> cut first
    os.chdir("/mnt/disks/tpcds/parquet")

    if order == 0:
        print("running original first")
        df_orig = run_original(key)
        dfs = run_cut(key, num)
        validate_dfs(df_orig, dfs)
    elif order == 1:
        dfs = run_cut(key, num)
        df_orig = run_original(key)
        validate_dfs(df_orig, dfs)
    else:
        exit("invalid order argument")
