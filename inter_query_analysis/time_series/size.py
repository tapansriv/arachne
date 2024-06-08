import os
import json

sizes = ["800", "900", "1100", "1200"]
tpcds_names = ["call_center", "catalog_page", "catalog_returns",
        "catalog_sales", "customer", "customer_address",
        "customer_demographics", "date_dim", "household_demographics",
        "income_band", "inventory", "item", "promotion", "reason", "ship_mode",
        "store", "store_returns", "store_sales", "time_dim", "warehouse",
        "web_page", "web_returns", "web_sales", "web_site"]

for s in sizes:
    data = {}
    for tbl in tpcds_names:
        pth = f"/mnt/{s}/parquet/{tbl}.parquet"
        bytes_size = os.path.getsize(pth)
        data[tbl] = bytes_size

    with open(f"{s}/table_sizes.json", 'w') as fp:
        json.dump(data, fp, indent=4, sort_keys=True)
