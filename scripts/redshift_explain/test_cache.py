import redshift_connector
import duckdb
import os
import sys
from jproperties import Properties
import time
import pandas as pd 
def run_original(key):
    config = Properties()
    home = os.path.expanduser("~")
    with open(f"{home}/arachne/config/config.properties", "rb") as f:
        config.load(f)

    conn = redshift_connector.connect(
        host='redshift-cluster-1.cm5xisyashnz.us-east-2.redshift.amazonaws.com',
        port=5439,
        database='dev',
        user=config.get('user').data,
        password=config.get('password').data
    )
    cursor = conn.cursor()
    cursor.execute("SET enable_result_cache_for_session TO OFF")

    home = os.path.expanduser("~")
    f = open(f"{home}/arachne/redshift_queries/{key}.sql")
    orig_qry = "".join(f.readlines())
    print(f"starting original query {key}")
    start = time.time()
    cursor.execute(orig_qry)
    runtime = time.time() - start
    df_orig: pandas.DataFrame = cursor.fetch_dataframe()
    print(f"finished original query {key}; elapsed time: {runtime}")
    cursor.close()
    conn.close()
    return df_orig


def run_cut(key, num):
    config = Properties()
    home = os.path.expanduser("~")
    with open(f"{home}/arachne/config/config.properties", "rb") as f:
        config.load(f)

    conn = redshift_connector.connect(
        host='redshift-cluster-1.cm5xisyashnz.us-east-2.redshift.amazonaws.com',
        port=5439,
        database='dev',
        user=config.get('user').data,
        password=config.get('password').data
    )
    cursor = conn.cursor()
    cursor.execute("SET enable_result_cache_for_session TO OFF")

    home = os.path.expanduser("~")
    dfs = []
    for i in range(1, num + 1):
        trial_val = f"{key}_{i}"
        print(f"starting cut query {trial_val}")

        ft = open(f"{home}/arachne/redshift_queries/{trial_val}.sql")
        q_all = "".join(ft.readlines())
        qs = q_all.split(";")
        qs = [i for i in qs if i.strip()]
        
        total_runtime = 0
        for i, q in enumerate(qs):
            if not q.strip():
                continue
            start = time.time()
            cursor.execute(q)
            runtime = time.time() - start
            total_runtime += runtime
            if i == (len(qs) - 1):
                test: pandas.DataFrame = cursor.fetch_dataframe()
                dfs.append(test)
        print(f"finished cut query {trial_val}; elapsed time: {total_runtime}")

        n = len(qs) - 1
        for i in range(n):
            tbl = f"rs_table_{key}_{i}"
            cursor.execute(f"DROP TABLE {tbl}")

    cursor.close()
    conn.close()
    return dfs


def validate_dfs(df_orig, dfs):
    for trial_val, df in enumerate(dfs):
        val = df_orig.equals(df)
        print(f"{trial_val+1} is same as original result: {val}")


def infer_num_cuts(key):
    home = os.path.expanduser("~")
    basepath = f"{home}/arachne/redshift_queries"
    for i in range(4, 0, -1):
        fname = f"{basepath}/{key}_{i}.sql"
        if os.path.exists(fname):
            return i


if __name__ == '__main__':
    key = sys.argv[1]
    num = infer_num_cuts(key) # how many cuts were tried. how many sql files to look for
    order = int(sys.argv[2]) # 0 -> original first,  1 -> cut first

    if order == 0:
        print("running original first")
        df_orig = run_original(key)
        dfs = run_cut(key, num)
        validate_dfs(df_orig, dfs)
    elif order == 1:
        print("running original second")
        dfs = run_cut(key, num)
        df_orig = run_original(key)
        validate_dfs(df_orig, dfs)
    else:
        exit("invalid order argument")
