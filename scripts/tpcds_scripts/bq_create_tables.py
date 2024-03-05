tables = ["call_center", "catalog_page", "catalog_returns", "catalog_sales",
        "customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item",
        "promotion", "reason", "ship_mode", "store", "store_returns",
        "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
        "web_sales", "web_site"]


for tbl in tables:
    qry = f"CREATE OR REPLACE EXTERNAL TABLE tpcds.{tbl} OPTIONS ( format = 'PARQUET', uris = ['gs://arachne_tpcds_1tb/{tbl}/{tbl}.parquet']);"
    print(qry)

