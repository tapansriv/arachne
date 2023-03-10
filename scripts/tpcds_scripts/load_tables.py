import os
import duckdb

# tables = ["call_center", "catalog_page", "catalog_returns", "catalog_sales",
#         "customer", "customer_address", "customer_demographics", "date_dim",
#         "household_demographics", "income_band", "inventory", "item",
#         "promotion", "reason", "ship_mode", "store", "store_returns",
#         "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
#         "web_sales", "web_site"]

# tables = ["store_sales", "time_dim", "warehouse", "web_page", "web_returns",
#         "web_sales", "web_site"]

tables = ["store_sales", "store_returns"]

con = duckdb.connect("tpcds.db")

path = f"{os.path.expanduser('~')}/data"
os.chdir(path)

# for fname in glob.glob("*.dat"):
for tname in tables: 
    if os.path.exists(f"{tname}.dat"):
        fname = f"{tname}.dat"
        print(f"load table {fname}")
        with open(fname) as f:
            qry = f"COPY {tname} FROM '{fname}' (DELIMITER '|')"
            con.execute(qry)
    else:
        for i in range(1,40):
            fname = f"{tname}_{i}_40.dat"
            print(f"load table {fname}")
            try: 
                with open(fname) as f:
                    qry = f"COPY {tname} FROM '{fname}' (DELIMITER '|')"
                    con.execute(qry)
                    os.remove(fname)
            except Exception as e: 
                print(e)
                continue

