import json
tables = ["call_center", "catalog_page", "catalog_returns", "catalog_sales",
        "customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item",
        "promotion", "reason", "ship_mode", "store", "store_returns",
        "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
        "web_sales", "web_site"]

sizes = {}
for tbl_name in tables:
    f = open(f"{tbl_name}.sql")
    lines = [x.strip() for x in f.readlines()]

    # purge first and last line
    # print(tbl_name)
    lines = lines[1:]
    lines = lines[:-1]
    # print(len(lines))

    row_size = 0
    for line in lines:
        vals = line.split(" ")
        col_name = vals[0]
        col_type = vals[1]
        size = 4
        if "integer" in col_type:
            size = 8
        elif "decimal" in col_type:
            size = 8
        elif "varchar" in col_type:
            val = col_type.split("(")[1].split(")")[0]
            size = int(val) + 2
            col_type = "SqlTypeName.VARCHAR"
        elif "date" in col_type:
            size = 8
        elif "double" in col_type:
            size = 8
        else: 
            print(f"ERROR: {col_type}")
        row_size += size

    sizes[tbl_name] = row_size

print(sizes)


with open("row_sizes.json", "w") as fp:
    json.dump(sizes, fp, indent=4)
