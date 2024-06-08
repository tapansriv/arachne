import json

tables = ["call_center", "catalog_page", "catalog_returns", "catalog_sales",
        "customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item",
        "promotion", "reason", "ship_mode", "store", "store_returns",
        "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
        "web_sales", "web_site"]

keys = {t: [] for t in tables}


for tbl_name in tables:
    f = open(f"{tbl_name}.sql")
    lines = [x.strip() for x in f.readlines()]

    lines = lines[1:]
    lines = lines[:-1]
    for line in lines:
        vals = line.split(" ")
        col_name = vals[0]
        keys[tbl_name].append(col_name)

print(json.dumps(keys, indent=4, sort_keys=True))
with open("tpcds_cols.json", 'w') as fp:
    json.dump(keys, fp, indent=4, sort_keys=True)
