#!/bin/bash
tpcds_names=("call_center" "catalog_page" "catalog_returns" "catalog_sales" "customer" "customer_address" "customer_demographics" "date_dim" "household_demographics" "income_band" "inventory" "item" "promotion" "reason" "ship_mode" "store" "store_returns" "store_sales" "time_dim" "warehouse" "web_page" "web_returns" "web_sales" "web_site") 

path="/mnt/test/parquet"

# ------------------------------------------
# create selectivity = 0.25
for tbl in ${tpcds_names[@]}
do
    python3 sample.py -S 0.25 /mnt/test/parquet "$tbl" create &
done
wait
echo "finished creating sample for 0.25"

# check selectivity = 0.25
for tbl in ${tpcds_names[@]}
do
    python3 sample.py -S 0.25 /mnt/test/parquet "$tbl" check > outputs/"$tbl"_0.25.output &
done
wait
echo "finished checking samples for 0.25"

# ------------------------------------------
# create selectivity = 0.15
for tbl in ${tpcds_names[@]}
do
    python3 sample.py -S 0.15 /mnt/test/parquet "$tbl" create &
done
wait
echo "finished creating sample for 0.15"

# check selectivity = 0.15
for tbl in ${tpcds_names[@]}
do
    python3 sample.py -S 0.15 /mnt/test/parquet "$tbl" check > outputs/"$tbl"_0.15.output &
done
wait
echo "finished checking samples for 0.15"

# ------------------------------------------
# create selectivity = 0.50
for tbl in ${tpcds_names[@]}
do
    python3 sample.py -S 0.50 /mnt/test/parquet "$tbl" create &
done
wait
echo "finished creating sample for 0.50"

# check selectivity = 0.50
for tbl in ${tpcds_names[@]}
do
    python3 sample.py -S 0.50 /mnt/test/parquet "$tbl" check > outputs/"$tbl"_0.50.output &
done
wait
echo "finished checking samples for 0.50"

