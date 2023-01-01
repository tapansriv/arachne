from google.cloud import storage
import json

tpcds_names = ["call_center", "catalog_page", "catalog_returns",
        "catalog_sales", "customer", "customer_address",
        "customer_demographics", "date_dim", "household_demographics",
        "income_band", "inventory", "item", "promotion", "reason", "ship_mode",
        "store", "store_returns", "store_sales", "time_dim", "warehouse",
        "web_page", "web_returns", "web_sales", "web_site"]

sizes = [0.15, 0.25, 0.5]

client = storage.Client()
bucket = client.get_bucket(f"arachne_tpcds_1tb")
for s in sizes:
    table_sizes = {}
    for tbl in tpcds_names:
        obj = bucket.get_blob(f"sample_{s}/{tbl}_{s}.parquet")
        if obj is None:
            print('hi')
        table_sizes[tbl] = obj.size
        print(f"Size {s}; {tbl}: {obj.size}")
    with open(f"table_sizes_{s}.json", "w") as fp:
        json.dump(table_sizes, fp, indent=4, sort_keys=True)
