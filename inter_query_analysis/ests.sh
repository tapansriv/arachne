#!/bin/bash

tpcds_names=("call_center" "catalog_page" "catalog_returns" "catalog_sales" "customer" "customer_address" "customer_demographics" "date_dim" "household_demographics" "income_band" "inventory" "item" "promotion" "reason" "ship_mode" "store" "store_returns" "store_sales" "time_dim" "warehouse" "web_page" "web_returns" "web_sales" "web_site") 

# p=estimation/100_est
# for tbl in ${tpcds_names[@]}
# do
#     cluster_size="--cluster_size 4"
#     cmd="python3 inter_query.py --no_calcite --egress 0.12 --exclude_table $tbl $cluster_size tpcds gcp estimation/100_est > $p/iq3.2_no_duck/algo_$tbl.output"
#     echo $cmd >> algo_cmds3.txt
#     cmd="python3 inter_query.py --no_calcite --egress 0.12 --exclude_table $tbl $cluster_size tpcds gcp estimation/100_true > $p/iq3.2_no_duck/algo_$tbl.output"
#     echo $cmd >> algo_cmds3.txt
#     cmd="python3 check_plan_costs.py --no_calcite --egress 0.12 --exclude_table $tbl $cluster_size tpcds gcp estimation/100_true estimation/100_est > $p/iq3.2_no_duck/algo_$tbl.output"
#     echo $cmd >> algo_cmds3.txt
# 
#     cluster_size="--cluster_size 1"
#     cmd="python3 inter_query.py --no_calcite --egress 0.12 --exclude_table $tbl $cluster_size tpcds gcp estimation/1000_est > $p/iq3.2_no_duck/algo_$tbl.output"
#     echo $cmd >> algo_cmds3.txt
#     cmd="python3 inter_query.py --no_calcite --egress 0.12 --exclude_table $tbl $cluster_size tpcds gcp estimation/1000_true > $p/iq3.2_no_duck/algo_$tbl.output"
#     echo $cmd >> algo_cmds3.txt
#     cmd="python3 check_plan_costs.py --no_calcite --egress 0.12 --exclude_table $tbl $cluster_size tpcds gcp estimation/1000_true estimation/1000_est > $p/iq3.2_no_duck/algo_$tbl.output"
#     echo $cmd >> algo_cmds3.txt
# done



paths=("mixed")
for p in ${paths[@]}
do
    mkdir -p estimation/"$p"_true/iq3.2_no_duck
    mkdir -p estimation/"$p"_true/iq3.2_duck
    cluster_size="--cluster_size 1"
    cmd="python3 inter_query.py --no_calcite $cluster_size tpcds gcp estimation/"$p"_est > $p/iq3.2_no_duck/algo_$tbl.output"
    echo $cmd >> algo_cmds3.txt
    cmd="python3 inter_query.py --no_calcite $cluster_size tpcds gcp estimation/"$p"_true > $p/iq3.2_no_duck/algo_$tbl.output"
    echo $cmd >> algo_cmds3.txt
    cmd="python3 check_plan_costs.py --no_calcite $cluster_size tpcds gcp estimation/"$p"_true estimation/"$p"_est > $p/iq3.2_no_duck/algo_$tbl.output"
    echo $cmd >> algo_cmds3.txt

    cmd="python3 inter_query.py --no_calcite $cluster_size tpcds aws estimation/"$p"_est > $p/iq3.2_no_duck/algo_$tbl.output"
    echo $cmd >> algo_cmds3.txt
    cmd="python3 inter_query.py --no_calcite $cluster_size tpcds aws estimation/"$p"_true > $p/iq3.2_no_duck/algo_$tbl.output"
    echo $cmd >> algo_cmds3.txt
    cmd="python3 check_plan_costs.py --no_calcite $cluster_size tpcds aws estimation/"$p"_true estimation/"$p"_est > $p/iq3.2_no_duck/algo_$tbl.output"
    echo $cmd >> algo_cmds3.txt
done


