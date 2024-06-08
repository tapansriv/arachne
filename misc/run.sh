#!/bin/bash

tables=("call_center" "catalog_page" "catalog_returns" "catalog_sales" "customer" "customer_address" "customer_demographics" "date_dim" "household_demographics" "income_band" "inventory" "item" "promotion" "reason" "ship_mode" "store" "store_returns" "store_sales" "time_dim" "warehouse" "web_page" "web_returns" "web_sales" "web_site")

x=$1
for tbl in ${tables[@]}
do
    python3 schema.py $tbl $x
    # python3 load.py $tbl $x

    i=1
    n=40
    while [ $i -le $n ]
    do
        python3 load.py $tbl $i $x
        i=$(($i+1))
    done
    echo "$tbl"
    python3 create_parquet.py $tbl $x
done
