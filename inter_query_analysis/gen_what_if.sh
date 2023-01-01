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

cluster_size="--cluster_size $cs"

v1=iq3.2_duck_what_if
v2=iq3.2_no_duck_what_if
for p in ${paths[@]}
do
    mkdir -p "$p"/"$v1"
    mkdir -p "$p"/"$v2"
    # cmd="python3 inter_query.py --rs_cost $rs --bq_cost $bq --egress $egress $cluster_size tpcds gcp $p > $p/$v2/algo.output"
    # echo $cmd >> what_if_cmds.txt
    cmd="python3 inter_query.py --rs_cost $rs --bq_cost $bq --egress $egress $cluster_size tpcds aws $p > $p/$v2/algo.output"
    echo $cmd >> what_if_cmds.txt
    # for tbl in ${tpcds_names[@]}
    # do
    #     # cmd="python3 inter_query3.py --rs_cost $rs --bq_cost $bq --egress $egress --exclude_table $tbl --base_two $cluster_size tpcds $p > $p/$v2/algo_$tbl.output"
    #     cmd="python3 inter_query.py --rs_cost $rs --bq_cost $bq --egress $egress --exclude_table $tbl $cluster_size tpcds gcp $p > $p/$v2/algo_$tbl.output"
    #     echo $cmd >> what_if_cmds.txt
    #     cmd="python3 inter_query.py --rs_cost $rs --bq_cost $bq --egress $egress --exclude_table $tbl $cluster_size tpcds aws $p > $p/$v2/algo_$tbl.output"
    #     echo $cmd >> what_if_cmds.txt
    # done
done


