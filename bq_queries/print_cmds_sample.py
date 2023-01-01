import sys

tables = ["call_center", "catalog_page", "catalog_returns", "catalog_sales",
        "customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item",
        "promotion", "reason", "ship_mode", "store", "store_returns",
        "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
        "web_sales", "web_site"]


assert len(sys.argv) == 2
s = float(sys.argv[1])

for tbl in tables:
    '''
    CREATE OR REPLACE EXTERNAL TABLE tpcds.date_dim
    OPTIONS (
      format = 'PARQUET',
      uris = ['gs://arachne_tpcds_1tb/date_dim/date_dim.parquet']
    );
    '''
    
    qry = f"CREATE OR REPLACE EXTERNAL TABLE tpcds.{tbl}\n"
    qry += '''OPTIONS (
      format = 'PARQUET',
    '''
    qry += f"  uris = ['gs://arachne_tpcds_1tb/sample_{s}/{tbl}_{s}.parquet']\n" 
    qry += '''); '''
    
    print(qry)
