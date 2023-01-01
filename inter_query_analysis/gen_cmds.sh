#!/bin/bash

if [ $# -lt 1 ]
then
    echo "no path provided"
    exit
fi

tpcds_names=("call_center" "catalog_page" "catalog_returns" "catalog_sales" "customer" "customer_address" "customer_demographics" "date_dim" "household_demographics" "income_band" "inventory" "item" "promotion" "reason" "ship_mode" "store" "store_returns" "store_sales" "time_dim" "warehouse" "web_page" "web_returns" "web_sales" "web_site") 

paths=$1

cluster_size=""
if [ $# -gt 1 ]
then
    cluster_size="--cluster_size $2"
fi

# echo "" > brute_cmds.txt
# $ for p in ${paths[@]}
# $ do
# $     mkdir -p "$p"/brute_duck
# $     mkdir -p "$p"/brute_no_duck
# $     for tbl in ${tpcds_names[@]}
# $     do
# $         cmd="python3 inter_query_brute.py --duck --exclude_table $tbl --base_two $cluster_size tpcds $p > $p/brute_duck/brute_$tbl.output"
# $         echo $cmd >> brute_cmds.txt
# $         cmd="python3 inter_query_brute.py --exclude_table $tbl --base_two tpcds $cluster_size $p > $p/brute_no_duck/brute_$tbl.output"
# $         echo $cmd >> brute_cmds.txt
# $     done
# $ done

# for p in ${paths[@]}
# do
#     mkdir -p "$p"/iq3.1_no_duck
#     mkdir -p "$p"/iq3.1_duck
#     for tbl in ${tpcds_names[@]}
#     do
#         cmd="python3 inter_query3.py --duck --exclude_table $tbl --base_two $cluster_size tpcds $p > $p/iq3.1_duck/algo_$tbl.output"
#         echo $cmd >> algo_cmds3.txt
#         cmd="python3 inter_query3.py --exclude_table $tbl --base_two $cluster_size tpcds $p > $p/iq3.1_no_duck/algo_$tbl.output"
#         echo $cmd >> algo_cmds3.txt
#     done
# done

for p in ${paths[@]}
do
    mkdir -p "$p"/iqopt_no_duck
    mkdir -p "$p"/iqopt_duck
    for tbl in ${tpcds_names[@]}
    do
        cmd="python3 inter_query_opt.py --duck --exclude_table $tbl --base_two $cluster_size tpcds $p > $p/iqopt_duck/algo_$tbl.output"
        echo $cmd >> algo_cmds_opt.txt
        cmd="python3 inter_query_opt.py --exclude_table $tbl --base_two $cluster_size tpcds $p > $p/iqopt_no_duck/algo_$tbl.output"
        echo $cmd >> algo_cmds_opt.txt
    done
done



