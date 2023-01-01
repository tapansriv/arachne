#!/bin/bash

tpcds_names=("call_center" "catalog_page" "catalog_returns" "catalog_sales" "customer" "customer_address" "customer_demographics" "date_dim" "household_demographics" "income_band" "inventory" "item" "promotion" "reason" "ship_mode" "store" "store_returns" "store_sales" "time_dim" "warehouse" "web_page" "web_returns" "web_sales" "web_site") 

p=$1

stat $p > /dev/null 2>&1
x=$?
if [ $x -eq 1 ]
then
    echo "invalid path provided $p"
    exit 1
fi

echo "$p"
pre="$p"/inter_query_outputs
for tbl in ${tpcds_names[@]}
do
    f1="$pre"/algo_"$tbl".output
    o1=$(grep "Optimal Subset" "$f1")
    o2=$(grep "Final cost" "$f1")

    echo ""
    echo "$tbl"
    echo "$o1"
    echo "$o2"
    echo ""
done
