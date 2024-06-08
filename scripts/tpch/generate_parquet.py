import duckdb
import os
from schemas import *
import sys

home_dir = os.path.expanduser("~") + "/"

def convert_tpch_to_parquet(base_path: str):
    """
    Convert TPC-H files from .tbl to .parquet through DuckDB

    Args:
        base_path: either absolute or relative path to directory containing tbl
        files.
    """

    # make sure base_path ends in slash
    if base_path[-1] != '/':
        base_path += '/'

    conn = duckdb.connect(database=':memory:', read_only=False)
    schema_commands = [customer_table, lineitem_table, nation_table, orders_table,
            part_table, psupp_table, region_table, supplier_table]
    tables = ["customer", "lineitem", "nation", "orders", "part", "partsupp", "region", "supplier"]

    print("creating tables")
    for cmd in schema_commands:
        conn.execute(cmd)
    print("tables created")

    for tbl in tables:
        print(f"starting {tbl}")
        load = f"COPY {tbl} FROM '{base_path}{tbl}.csv' (DELIMITER '|');"
        store = f"COPY (SELECT * FROM {tbl}) TO '{base_path}{tbl}.parquet' (FORMAT 'parquet')"

        print(f"{load}")
        conn.execute(load)
        print(f"{store}")
        conn.execute(store)
        print(f"finishing {tbl}")

def convert_tpch_to_csv(base_path: str, out_path: str = home_dir):
    """
    Convert TPC-H files from .tbl to .parquet through DuckDB

    Args:
        base_path: either absolute or relative path to directory containing tbl
        files.
    """

    # make sure base_path ends in slash
    if base_path[-1] != '/':
        base_path += '/'

    conn = duckdb.connect(database=':memory:', read_only=False)
    schema_commands = [customer_table, lineitem_table, nation_table, orders_table,
            part_table, psupp_table, region_table, supplier_table]
    tables = ["customer", "lineitem", "nation", "orders", "part", "partsupp", "region", "supplier"]

    for tbl in tables:
        if os.path.isfile(f"{base_path}{tbl}.tbl"):
            print(f"renaming {tbl}.tbl to {tbl}.csv")
            os.rename(f"{base_path}{tbl}.tbl", f"{base_path}{tbl}.csv")


    print("creating tables")
    for cmd in schema_commands:
        conn.execute(cmd)
    print("tables created")

    for tbl in tables:
        print(f"starting {tbl}")
        load = f"COPY {tbl} FROM '{base_path}{tbl}.csv' (DELIMITER '|');"
        store = f"COPY (SELECT * FROM {tbl}) TO '{out_path}{tbl}.csv' (FORMAT 'csv', HEADER)"

        print(f"{load}")
        conn.execute(load)
        print(f"{store}")
        conn.execute(store)
        print(f"finishing {tbl}")

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("ERROR invalid number of arguments")
        exit(1)

    base_path = sys.argv[1] 
    if len(sys.argv) > 2:
        out_path = sys.argv[2]
        convert_tpch_to_csv(base_path, out_path)
    else:
        convert_tpch_to_csv(base_path)
