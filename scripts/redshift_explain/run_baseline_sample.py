import redshift_connector
import re
import os
import sys
from jproperties import Properties
import time
import pandas as pd 
import json

def run_qry(key, name, calcite):
    config = Properties()
    home = os.path.expanduser("~")
    with open(f"{home}/arachneDB/config/config.properties", "rb") as f:
        config.load(f)

    conn = redshift_connector.connect(
        host=f"{name}.cm5xisyashnz.us-east-2.redshift.amazonaws.com",
        port=5439,
        database='dev',
        user=config.get('user').data,
        password=config.get('password').data
    )
    cursor = conn.cursor()
    cursor.execute("SET enable_result_cache_for_session TO OFF")

    home = os.path.expanduser("~")
    qfile = f"{home}/arachneDB/redshift_queries/{key}.sql"
    if calcite: 
        qfile = f"{home}/arachneDB/c_queries/rs/{key}.sql"

    f = open(qfile)

    qry = "".join(f.readlines())
    print(qry)
    print(f"starting original query {key}; {name}")
    start = time.time()
    try:
        cursor.execute(qry)
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
    assert len(sys.argv) >= 4
    key = sys.argv[1]
    s = float(sys.argv[2])
    name = sys.argv[3]
    calcite = (len(sys.argv) == 5)
    assert s < 1 and s > 0
    assert re.match("redshift-cluster-[0-9]", name)

    print(f"{key}, {s}, {name}, {calcite}")
    runtime = run_qry(key, name, calcite)
    if runtime != -1:
        home = os.path.expanduser("~")
        x = None
        outfile = f"{home}/arachneDB/data/rs_baseline_1_{s}.json" 
        if calcite:
            outfile = f"{home}/arachneDB/data/rs_c_baseline_1_{s}.json" 
        try:
            with open(outfile) as fp:
                x = json.load(fp)
        except Exception as e: 
            x = {}

        x[key] = runtime
        with open(outfile, "w") as fp:
            json.dump(x, fp, indent=4, sort_keys=True)
