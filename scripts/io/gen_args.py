import os

f = open("/home/cc/arachneDB/gcp_bq_v3/gen_weird")
foos = [int(x.strip()) for x in f.readlines()]

for qry in foos:
    key = str(qry)
    if qry < 10:
        key = "0" + key
    print(key)


for qry in foos:
    key = str(qry)
    if qry < 10:
        key = "0" + key

    num = 0
    for i in range(4, 0, -1):
        fname = f"/home/cc/arachneDB/p_queries/{key}_{i}.sql"
        if os.path.exists(fname):
            num = i
            break
    
    for i in range(1, num+1):
        print(f"{key}_{i}")

