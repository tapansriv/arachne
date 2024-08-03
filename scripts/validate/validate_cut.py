import duckdb
import os
import sys

key = sys.argv[1]
num = int(sys.argv[2]) # how many cuts were tried. how many sql files to look for

con1 = duckdb.connect(f"orig_{key}.db")

os.chdir("/mnt/disks/tpcds/parquet")

home = os.path.expanduser("~")
f = open(f"{home}/arachne/p_queries/{key}.sql")
orig_qry = "".join(f.readlines())
# orig_qry = f"CREATE TABLE orig AS {orig_qry}"
print(f"starting original query {key}")
res = con1.execute(orig_qry)
df_orig = res.fetchdf()
print(f"finished original query {key}")

for i in range(1, num + 1):
    trial_val = f"{key}_{i}"
    con2 = duckdb.connect(f"cut_{trial_val}.db")

    ft = open(f"{home}/arachne/p_queries/{trial_val}.sql")
    qry = "".join(ft.readlines())
    print(f"starting cut query {trial_val}")
    res = con2.execute(qry)
    test = res.fetchdf()
    print(f"finished cut query {trial_val}")

    val = df_orig.equals(test)
    print(f"{trial_val} is same as original result: {val}")
