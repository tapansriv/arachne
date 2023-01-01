from table_names import tpcds_names
import json

samples = ["0.15", "0.25", "0.5"]

for s in samples:
    file_sizes = {}
    f = open(f"file_sizes_{s}.out")
    lines = [x.strip() for x in f.readlines()]
    for l in lines:
        vals = [x for x in l.split(" ") if x != '']
        print(vals)
        size_in_bytes = int(vals[0].strip())
        path_components = vals[1].split("/")
        print(path_components)
        tbl_name = path_components[-1].split(f"_{s}.parquet")[0]
        file_sizes[tbl_name] = size_in_bytes

    with open(f"table_sizes_{s}.json", 'w') as fp:
        json.dump(file_sizes, fp, indent=4, sort_keys=True)

