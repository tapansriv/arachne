#!/bin/bash

ss=("0.15" "0.25" "0.5")
tpcds_names=("call_center" "catalog_page" "catalog_returns" "catalog_sales" "customer" "customer_address" "customer_demographics" "date_dim" "household_demographics" "income_band" "inventory" "item" "promotion" "reason" "ship_mode" "store" "store_returns" "store_sales" "time_dim" "warehouse" "web_page" "web_returns" "web_sales" "web_site") 


echo "" > cmds.txt
for s in ${ss[@]}
do
    p="baseline_$s"
    echo $p
    mkdir -p "$p"/outputs
    for tbl in ${tpcds_names[@]}
    do
        outfile="../$p/outputs/$tbl.output"
        cmd="python3 profiling_cost.py --no_calcite --exclude_table $tbl --cluster_size 1 $s $p > $outfile"
        echo $cmd >> cmds.txt
    done
done


