import duckdb

con = duckdb.connect("test", read_only=False)
con.execute("PRAGMA enable_profiling='json'")
con.execute("PRAGMA profile_output='out.json'")
con.execute("PRAGMA threads=48")

files = ["customer", "nation", "part", "region", "lineitem", "orders",
        "partsupp", "supplier"]

# for f in files:
#     print(f"starting {f}")
#     con.execute(f"CREATE TABLE {f} AS SELECT * FROM '{f}.parquet'")
#     print(f"ending {f}")


with open("final_queries/18.sql") as f:
    qry = "".join(f.readlines())
    res = con.execute(f"{qry}")
    # print(res.fetchall()[0][1])
