tables = ["call_center", "catalog_page", "catalog_returns", "catalog_sales",
        "customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item",
        "promotion", "reason", "ship_mode", "store", "store_returns",
        "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
        "web_sales", "web_site"]

# cmd = ""
# for tbl in tables:
#     cmd = cmd + f".addTable(Tables.{tbl})\n"
# print(cmd)


col_size = "public static final Map<String, Integer> colSizes = ImmutableMap.<String, Integer>builder()\n"

for tbl_name in tables:
    f = open(f"{tbl_name}.sql")
    lines = [x.strip() for x in f.readlines()]
    # tbl_name = lines[0].split(" ")[2][:-1]
    cmd = f'public static final ArachneTable {tbl_name} = ArachneTable.newBuilder("{tbl_name}")\n'

    # purge first and last line
    # print(tbl_name)
    lines = lines[1:]
    lines = lines[:-1]
    # print(len(lines))
    for line in lines:
        vals = line.split(" ")
        col_name = vals[0]
        col_type = vals[1]
        size = 4
        if "integer" in col_type:
            col_type = "SqlTypeName.INTEGER"
            size = 4
        elif "decimal" in col_type:
            vals = col_type.split("(")[1].split(",")
            vals[1] = vals[1][:-1]
            vals = [int(vals[i]) for i in range(0, 2)]
            if vals[0] <= 4:
                size = 2
            elif vals[0] <= 9:
                size = 4
            elif vals[0] <= 18:
                size = 8
            else: 
                size = 16
            col_type = "SqlTypeName.DECIMAL"
        elif "varchar" in col_type:
            val = col_type.split("(")[1].split(")")[0]
            size = int(val)
            col_type = "SqlTypeName.VARCHAR"
        elif "date" in col_type:
            size = 4
            col_type = "SqlTypeName.DATE"


        newline = f'.addField("{col_name}", {col_type})\n'
        newsize = f'.put("{col_name}", {size}L)\n'
        cmd = cmd + newline
        col_size = col_size + newsize

    row_count = ".withRowCount(1L)\n"
    cmd = cmd + row_count
    cmd = cmd + ".build();\n"
    # print(cmd)
col_size = col_size + ".build();\n"
print(col_size)

