import sys
import os
import duckdb
from argparse import ArgumentParser

parser = ArgumentParser(description="Run inter-query analysis")

parser.add_argument("--data-dir", default="data", help="Data directory")
parser.add_argument("tbl", help="Table name")
parser.add_argument("index", help="Which index this is")
parser.add_argument("dir", help="Directory with data in it")
args = parser.parse_args()

# tbl = sys.argv[1]
# i = int(sys.argv[2])
# dir_ = sys.argv[3]
path = f"/mnt/{args.dir}"
con = duckdb.connect(f"/mnt/{args.dir}/dbs/{args.tbl}.db")
data_path = os.path.join(path, args.data_dir)
os.chdir(data_path)

# fname = f"{tbl}.dat"
# print(f"load table {fname}")
# qry = f"COPY {tbl} FROM '{fname}' (DELIMITER '|')"
# con.execute(qry)

tname = tbl
if os.path.exists(f"{tname}_1_40.dat") \
        and not os.path.exists(f"{tname}_2_40.dat") \
        and args.index == 1:
    fname = f"{tname}_1_40.dat"
    print(f"load table {fname}")
    with open(fname) as f:
        qry = f"COPY {tname} FROM '{fname}' (DELIMITER '|')"
        con.execute(qry)
elif os.path.exists(f"{tname}_1_40.dat") and \ 
        not os.path.exists(f"{tname}_2_40.dat") and args.index != 1:
    print("Already handled")
else:
    fname = f"{tname}_{args.index}_40.dat"
    if tbl == "customer":
        fname = f"{tname}2_{args.index}_40.dat"
    print(f"load table {fname}")
    try: 
        with open(fname) as f:
            qry = f"COPY {tname} FROM '{fname}' (DELIMITER '|')"
            con.execute(qry)
    except Exception as e: 
        print(e)


