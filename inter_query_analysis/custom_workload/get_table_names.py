import json

tpcds_names = ["call_center", "catalog_page", "catalog_returns",
        "catalog_sales", "customer", "customer_address",
        "customer_demographics", "date_dim", "household_demographics",
        "income_band", "inventory", "item", "promotion", "reason", "ship_mode",
        "store", "store_returns", "store_sales", "time_dim", "warehouse",
        "web_page", "web_returns", "web_sales", "web_site"]


dirs = ["cpu_0.5", "io_2", "mixed"]


for dir_ in dirs:
    query_bit_vecs = json.load(open(f"{dir_}/query_bit_vec.json"))
    bq = json.load(open(f"{dir_}/bigquery_baseline.json"))
    rs = json.load(open(f"{dir_}/rs_baseline.json"))
    keys = bq.keys() & rs.keys()

    seen = set()
    for i in range(len(tpcds_names)):
        for k in keys:
            vec = query_bit_vecs[k]
            tbl_name = tpcds_names[i]
            res = (vec >> i) & 1
            if res == 1:
                seen.add(tbl_name)

    print(f"{dir_}: {len(seen)}; {seen}")
