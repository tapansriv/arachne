import os
import sys
import time
import pandas as pd 
import json
import duckdb

def run_c_q(key):
    home = os.path.expanduser("~")
    con = duckdb.connect(f"/mnt/disks/tpcds/dbs/{key}.db")
    con.execute("PRAGMA memory_limit='185G'")
    # con.execute("PRAGMA enable_profiling='json'")
    # con.execute(f"PRAGMA profile_output='/home/tapansriv/{key}_profile.json'")
    os.chdir("/mnt/disks/tpcds/parquet")

    f = open(f"{home}/arachne/c_queries/duck/{key}.sql")
    orig_qry = "".join(f.readlines())
    start = time.time()
    con.execute(orig_qry)
    runtime = time.time() - start
    print(f"finished query {key}; elapsed time: {runtime}")
    return runtime

def run_original(key):
    home = os.path.expanduser("~")
    con = duckdb.connect(f"/mnt/disks/tpcds/dbs/{key}.db")
    con.execute("PRAGMA memory_limit='185G'")
    # con.execute("PRAGMA enable_profiling='json'")
    # con.execute(f"PRAGMA profile_output='/home/tapansriv/{key}_profile.json'")
    os.chdir("/mnt/disks/tpcds/parquet")

    f = open(f"{home}/arachne/p_queries/{key}.sql")
    orig_qry = "".join(f.readlines())
    start = time.time()
    con.execute(orig_qry)
    runtime = time.time() - start
    print(f"finished query {key}; elapsed time: {runtime}")
    return runtime

if __name__ == '__main__':
    key = sys.argv[1]
    fname = sys.argv[2]
    home = os.path.expanduser("~")
    print(f"{home}/arachne/baseline_1tb/{fname}.json")

    runtime = None
    if "_c" in fname:
        print('run_c', flush=True)
        runtime = run_c_q(key)
    else:
        print('orig', flush=True)
        runtime = run_original(key)
    x = None
    with open(f"{home}/arachne/baseline_1tb/{fname}.json") as fp:
        x = json.load(fp)

    x[key] = runtime
    with open(f"{home}/arachne/baseline_1tb/{fname}.json", "w") as fp:
        json.dump(x, fp, indent=4, sort_keys=True)
