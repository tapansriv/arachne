tables=("catalog_page" "catalog_returns" "catalog_sales" "customer" "customer_address" "customer_demographics" "date_dim" "household_demographics" "income_band" "inventory" "item" "promotion" "reason" "ship_mode" "store" "store_returns" "store_sales" "time_dim" "warehouse" "web_page" "web_returns" "web_sales" "web_site")

for tbl in ${tables[@]}
do
    gsutil mv gs://arachne_tpcds_2tb/"$tbl".parquet gs://arachne_tpcds_2tb/"$tbl"/"$tbl".parquet
done
