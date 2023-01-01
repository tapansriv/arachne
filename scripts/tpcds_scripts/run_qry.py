import os
import shutil
import duckdb
from argparse import ArgumentParser

parser = ArgumentParser(description="Run SQL against TPCDS DuckDB instance; requires that you have run create_schemas.py and load_tables.py")

parser.add_argument("--explain", action="store_const", const="EXPLAIN ", default="", help="Explain query")
parser.add_argument("--profile", action="store_true", help="Enable profiling")

group = parser.add_mutually_exclusive_group(required=True)
group.add_argument("--tpcds", type=str, required=False, help="Run query N from tpcds suite")
group.add_argument("--qry", type=str, required=False, help="Run any sql")
args = parser.parse_args()

print(f"Starting up DB")
con = duckdb.connect("/mnt/disks/tpcds/tpcds.db")
print(f"Start up complete")

if args.profile:
    # con.execute("PRAGMA enable_profiling;")
    con.execute("PRAGMA enable_profiling='json';")
    con.execute(f"PRAGMA profile_output='/home/tapansriv/{args.tpcds}.json';")

if args.explain:
    con.execute("PRAGMA explain_output='all'")

if args.tpcds:
    os.chdir("/mnt/disks/tpcds/parquet")
    fname = f"{os.path.expanduser('~')}/arachneDB/p_queries/{args.tpcds}.sql"
    print(f"Running TPCDS: {fname}")
    try:
        f = open(fname)
        qry = "".join(f.readlines())
        qry = args.explain + qry
        print(f"{qry}")
        result = con.execute(qry)
        if args.explain:
            res = result.fetchall()
            print(res[0][1])
            print(res[1][1])
            print(res[2][1])
            print(res[1][0])
    except Exception as e:
        raise e

elif args.qry:
    print(f"Running custom SQL query")
    qry = args.explain + args.qry
    print(qry)
    res = con.execute(qry)
    print(res.fetchdf())
    pid = os.getpid()
    shutil.copy(f"/proc/{pid}/io", f"/home/cc/{pid}")
else:
    raise ValueError("Invalid arguments")

