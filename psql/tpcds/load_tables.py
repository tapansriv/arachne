import os
import duckdb

tables = ["call_center", "catalog_page", "catalog_returns", "catalog_sales",
        "customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item",
        "promotion", "reason", "ship_mode", "store", "store_returns",
        "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
        "web_sales", "web_site"]

assert len(tables) == 24
# tables = ["store_sales", "store_returns"]


path = f"/mnt/disks/data/DSGen-software-code-3.2-2.0rc1/tools/data"

# for fname in glob.glob("*.dat"):
drop = open("drop.sql", "w")
for tname in tables: 
    print(f"DROP TABLE {tname};", file = drop)
    print(f"load table {tname}")
    with open(f"/home/cc/arachneDB/psql/{tname}.sql", "w") as f:
        if os.path.exists(f"{path}/{tname}_1_40.dat") and not os.path.exists(f"{path}/{tname}_2_40.dat"):
            fname = f"{tname}_1_40.dat"
            print(f"load table {fname}")
            cmd = f"COPY {tname} FROM '{path}/{fname}' DELIMITER '|' CSV;\n"
            f.write(cmd)
        else:
            for i in range(1,41):
                fname = f"{tname}_{i}_40.dat"
                print(f"load table {fname}")
                cmd = f"COPY {tname} FROM '{path}/{fname}' DELIMITER '|' CSV;\n"
                f.write(cmd)

