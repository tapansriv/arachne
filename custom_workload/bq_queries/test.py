import re
import os


tables = ["call_center", "catalog_page", "catalog_returns",
        "catalog_sales", "customer", "customer_address",
        "customer_demographics", "date_dim", "household_demographics",
        "income_band", "inventory", "item", "promotion", "reason", "ship_mode",
        "store", "store_returns", "store_sales", "time_dim", "warehouse",
        "web_page", "web_returns", "web_sales", "web_site"]
assert len(tables) == 24

base = "../bq_queries2"
files = os.listdir(base)

for f in files:
    if not f.endswith("sql"):
        continue
    lines = open(os.path.join(base, f)).readlines()
    fp = open(f, 'w')
    for l in lines:
        x = l
        for tbl in tables:
            find = rf'(?<!tpcds)([^_]){tbl}([^a-zA-Z0-9_.]|$)'
            replace = rf'\1tpcds.{tbl}\2' 
            x = re.sub(find, replace, x)
        fp.write(x)
    fp.close()
