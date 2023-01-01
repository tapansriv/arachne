import json

swaps = [("1f", "1b", 'r'), ("2e", "2b", ''), ("3e", "3b", 'r'), ("8d", "8c", '')]

dirs = ["all", "cpu_0.5", "io_2", "mixed"]
files = ["bigquery_baseline.json", "rs_baseline.json", "query_bit_vec.json"]

for dir_ in dirs:
    for f in files:
        fname = f"{dir_}/{f}"
        f = open(fname)
        data = json.load(f)
        f.close()
        for k1, k2, _ in swaps:
            if k2 not in data:
                data[k2] = data.pop(k1)
            elif k2 in data:
                tmp = data[k1]
                data[k1] = data[k2]
                data[k2] = tmp
            else:
                raise ValueError()
        with open(fname, 'w') as fp:
            json.dump(data, fp, indent=4)



