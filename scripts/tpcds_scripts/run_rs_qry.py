import os
import time
from jproperties import Properties
import redshift_connector
import sys
from argparse import ArgumentParser

parser = ArgumentParser(description="Run SQL against Redshift instance; requires that you have run create_redshift.py")

parser.add_argument("--explain", action="store_const", const="EXPLAIN ", default="", help="Explain query")

group = parser.add_mutually_exclusive_group(required=True)
group.add_argument("--tpcds", type=str, required=False, help="Run query N from tpcds suite")
group.add_argument("--qry", type=str, required=False, help="Run any sql")
args = parser.parse_args()

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

if args.tpcds:
    fname = f"{os.path.expanduser('~')}/arachne/redshift_queries/{args.tpcds}.sql"
    print(f"Running TPCDS: {fname}")
    try:
        f = open(fname)
        qry = "".join(f.readlines())
        cursor = conn.cursor()

        qs = qry.split(";")
        qs = [i for i in qs if i.strip()]
        try:
            runtime = 0
            for i, q in enumerate(qs):
                q1 = q.strip()
                if not q1:
                    continue

                start = time.time()
                cursor.execute(args.explain + q1)
                runtime += (time.time() - start)
                if args.explain:
                    res = cursor.fetchall()
                    for t in res:
                        print(t[0])
            print(f"{args.tpcds}: {runtime}")
        finally:
            n = len(qs) - 1
            for i in range(n):
                tbl = f"rs_table_{args.tpcds}_{i}"
                cursor.execute(f"DROP TABLE {tbl}")
            cursor.close()
            conn.close()

        start = time.time()
        cursor.execute(qry)
        runtime = time.time() - start
        print(f"{args.tpcds}: {runtime}")
        if args.explain:
            res = cursor.fetchall()
            print(res)
        cursor.close()
        conn.close()
    except Exception as e:
        raise e

elif args.qry:
    print(f"Running custom SQL query")
    qry = args.explain + args.qry
    qry1 = "SELECT * FROM date_dim LIMIT 5"
    qry2 = "SELECT COUNT(*) FROM date_dim"
    print(qry)
    cursor = conn.cursor()
    cursor.execute(qry1)
    cursor.execute(qry2)
    res = cursor.fetchall()
    print(res)
    for t in res:
        print(t[0])
    cursor.close()
    conn.close()
else:
    raise ValueError("Invalid arguments")
