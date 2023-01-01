#!/bin/bash

if [ $# -lt 1 ]
then
    echo "no path provided"
    exit
fi

tpcds_names=("call_center" "catalog_page" "catalog_returns" "catalog_sales" "customer" "customer_address" "customer_demographics" "date_dim" "household_demographics" "income_band" "inventory" "item" "promotion" "reason" "ship_mode" "store" "store_returns" "store_sales" "time_dim" "warehouse" "web_page" "web_returns" "web_sales" "web_site") 

paths=$1
cs=$2
egress=$3
rs=$4
bq=$5
duck=$6

cluster_size=""
if [ $cs -eq 4 ]
then
    cluster_size="--cluster_size $cs"
fi
v1=iq3_duck_what_if
v2=iq3_no_duck_what_if
for p in ${paths[@]}
do
    mkdir -p "$p"/"$v1"
    mkdir -p "$p"/"$v2"
    for tbl in ${tpcds_names[@]}
    do
        # cmd="python3 inter_query3.py --duck --duck_cost $duck --rs_cost $rs --bq_cost $bq --egress $egress --exclude_table $tbl --base_two $cluster_size tpcds $p > $p/$v1/algo_$tbl.output"
        # echo $cmd >> what_if_cmds.txt
        cmd="python3 inter_query3.py --rs_cost $rs --bq_cost $bq --egress $egress --exclude_table $tbl --base_two $cluster_size tpcds $p > $p/$v2/algo_$tbl.output"
        echo $cmd >> what_if_cmds.txt
    done
done


