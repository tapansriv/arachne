import os
import sys
import duckdb

if len(sys.argv) < 2:
    exit("Not enough arguments")

key = sys.argv[1]
if len(sys.argv) >= 3:
    dir_ = sys.argv[2]
else:
    dir_ = "p_queries"

if dir_[-1] == '/':
    dir_ = dir_[:-1]

orig_only = False
if len(sys.argv) == 4:
    orig_only = True

con = duckdb.connect(f"/mnt/disks/tpcds/dbs/{key}.db")
home = os.path.expanduser("~")
os.chdir("/mnt/disks/tpcds/parquet")

basepath = f"{home}/arachne/{dir_}"
outpath = f"{home}/arachne/data"

num = 0
for i in range(4, 0, -1):
    fname = f"{basepath}/{key}_{i}.sql"
    if os.path.exists(fname):
        num = i
        break

print(f"starting {key}, {num}")
orig_path = f"{basepath}/{key}.sql"
f = open(orig_path)
orig_all = "".join(f.readlines())
qs = orig_all.split(";")

for i, q in enumerate(qs):
    if not q.strip():
        continue
    res = con.execute("EXPLAIN " + q)
    x = res.fetchall()
    outfile = f"{outpath}/{key}_orig_{i+1}"
    fp = open(outfile, "w")
    fp.write(x[0][1])


print("finished explaining original")
if not orig_only:
    for cut in range(1, num+1):
        print(f"starting {cut}")
        con = duckdb.connect(f"/mnt/disks/tpcds/dbs/{key}_{cut}.db")
        path = f"{basepath}/{key}_{cut}.sql"
        f = open(path)
        q_all = "".join(f.readlines())
        qs = q_all.split(";")
        for i, q in enumerate(qs):
            if not q.strip():
                continue
            res = con.execute("EXPLAIN " + q)
            x = res.fetchall()
            outfile = f"{outpath}/{key}_{cut}_{i+1}"
            fp = open(outfile, "w")
            fp.write(x[0][1])
