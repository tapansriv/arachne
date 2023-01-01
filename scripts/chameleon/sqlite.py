import pandas as pd
import numpy as np
import pyarrow.parquet as pq
import sqlite3

con = sqlite3.connect("slite")

files = ["customer", "nation", "part", "region", "lineitem", "orders",
        "partsupp", "supplier"]


# for f in files:
#     print(f'starting {f}')
#     pq.read_table(f"{f}.parquet").to_pandas().to_sql(f, con)
#     print(f'ending {f}')


with open("/home/cc/arachneDB/arachne/tests/table_queries/18.sql") as f:
    qry = "".join(f.readlines())
    print(qry)
    res = con.execute(f"EXPLAIN QUERY PLAN {qry}")
    print(res.fetchall())
