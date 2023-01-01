import duckdb
import time
import sys
import os 

os.chdir("/mnt/disks/tpcds/parquet")
con = duckdb.connect("/mnt/disks/tpcds/arachne36.db")
# key = sys.argv[1]

con.execute("PRAGMA memory_limit='50G'")
con.execute("PRAGMA temp_directory='/mnt/disks/tpcds/duck_tmp'")


f1 = open("/home/cc/arachneDB/p_queries/22_1.sql")
f2 = open("/home/cc/arachneDB/p_queries/22_2.sql")
f3 = open("/home/cc/arachneDB/p_queries/22_3.sql")
# f4 = open("/home/cc/arachneDB/p_queries/36_4.sql")
q1 = "".join(f1.readlines())
q2 = "".join(f2.readlines())
q3 = "".join(f3.readlines())
# q4 = "".join(f4.readlines())

start = time.time()
con.execute(q1)
end = time.time() - start
print(f"phase 1 took {end} seconds")
print(con.execute("SELECT COUNT(*) FROM results").fetchdf())

start = time.time()
con.execute(q2)
end = time.time() - start
print(f"phase 2 took {end} seconds")
# print(con.execute("SELECT COUNT(*) FROM results2").fetchdf())
print(con.execute("SELECT COUNT(*) FROM results_rollup").fetchdf())

start = time.time()
con.execute(q3)
end = time.time() - start
print(f"phase 3 took {end} seconds")
# print(con.execute("SELECT COUNT(*) FROM results_rollup").fetchdf())
# 
# start = time.time()
# con.execute(q4)
# end = time.time() - start
# print(f"phase 4 took {end} seconds")

