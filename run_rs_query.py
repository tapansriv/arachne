import redshift_connector
import os
import sys
from jproperties import Properties
import time
import pandas as pd 
import json

def run_qry(fname):
    config = Properties()
    home = os.path.expanduser("~")
    with open(f"{home}/arachneDB/config/config.properties", "rb") as f:
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
    cursor.execute("SELECT * FROM rs_table_60_0;")

    home = os.path.expanduser("~")

    f = open(fname)
    q_all = "".join(f.readlines())
    qs = q_all.split(";")
    qs = [i.strip() for i in qs if i.strip()]
    total_runtime = 0
    print(f"starting query at {fname}")
    for i, q in enumerate(qs):
        print(q)
        start = time.time()
        cursor.execute(q)
        runtime = time.time() - start
        total_runtime += runtime
        if i == (len(qs) - 1):
            test: pandas.DataFrame = cursor.fetch_dataframe()
            print(test)
    print(f"starting query at {fname}; elapsed time: {total_runtime}")
    cursor.close()
    conn.close()
    return runtime

if __name__ == '__main__':
    fname = sys.argv[1]
    runtime = run_qry(fname)
