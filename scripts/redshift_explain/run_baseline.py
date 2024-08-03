import redshift_connector
import os
import sys
from jproperties import Properties
import time
import pandas as pd 
import json

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
    f = open(f"{home}/arachne/c_queries/rs/{key}.sql")
    # f = open(f"{home}/arachne/redshift_queries/{key}.sql")

    orig_qry = "".join(f.readlines())
    print(orig_qry)
    print(f"starting original query {key}; redshift-cluster-1")
    start = time.time()
    try:
        cursor.execute(orig_qry)
    except Exception as e:
        print(e)
        print("error rip")
        return -1

    runtime = time.time() - start
    print(f"finished original query {key}; elapsed time: {runtime}")
    cursor.close()
    conn.close()
    return runtime

if __name__ == '__main__':
    key = sys.argv[1]
    runtime = run_original(key)
    if runtime != -1:
        home = os.path.expanduser("~")
        x = None
        with open(f"{home}/arachne/data/rs_c_baseline_1.json") as fp:
            x = json.load(fp)

        x[key] = runtime
        with open(f"{home}/arachne/data/rs_c_baseline_1.json", "w") as fp:
            json.dump(x, fp, indent=4, sort_keys=True)
