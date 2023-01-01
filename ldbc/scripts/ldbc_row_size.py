import json
sizes = {}


f = open("schema.sql")
lines = [x.strip() for x in f.readlines()]


tbl_name = None
row_size = 0
for line in lines:
    if "create table" in line:
        vals = line.split(" ")
        tbl_name = vals[2].lower()
        row_size = 0
    elif line.startswith(")"):
        # end condition
        print(f"end {tbl_name}: {row_size}")
        sizes[tbl_name] = row_size
    elif not line or line.startswith("--"): 
        continue
    else:
        vals = line.split(" ")
        col_name = vals[0]
        col_type = vals[1]
        size = 4
        if "int" in col_type or "bigint" in col_type:
            size = 8
        elif "decimal" in col_type:
            size = 8
        elif "varchar" in col_type:
            val = col_type.split("(")[1].split(")")[0]
            size = int(val) + 2
            col_type = "SqlTypeName.VARCHAR"
        elif "date" in col_type or "timestamp" in col_type:
            size = 8
        elif "double" in col_type:
            size = 8
        else: 
            print(f"ERROR: {col_type}")
        row_size += size

print(sizes)

with open("ldbc_row_sizes.json", "w") as fp:
    json.dump(sizes, fp, indent=4)
