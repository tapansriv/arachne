#!/bin/bash

if [ $# -lt 1 ]
then
    echo "no path provided"
    exit
fi

tpcds_names=("call_center" "catalog_page" "catalog_returns" "catalog_sales" "customer" "customer_address" "customer_demographics" "date_dim" "household_demographics" "income_band" "inventory" "item" "promotion" "reason" "ship_mode" "store" "store_returns" "store_sales" "time_dim" "warehouse" "web_page" "web_returns" "web_sales" "web_site") 

paths=$1
cluster_size="--cluster_size $2"


o=workload.csv

# for p in ${paths[@]}
# do
#     mkdir -p "$p"/iq3.2_no_duck
#     mkdir -p "$p"/iq3.2_duck
#     for tbl in ${tpcds_names[@]}
#     do
#         cmd="python3 inter_query.py --egress 0.09 --duck --exclude_table $tbl $cluster_size tpcds aws $p > $p/iq3.2_duck/algo_$tbl.output"
#         cmd="python3 inter_query.py --egress 0.09 --exclude_table $tbl $cluster_size tpcds aws $p > $p/iq3.2_duck/algo_$tbl.output"
#         cmd="python3 inter_query.py --workload_outfile $o --egress 0.09 --exclude_table $tbl $cluster_size tpcds aws $p"
#         echo $cmd >> algo_cmds3.txt
#     done
# done

for p in ${paths[@]}
do
    mkdir -p "$p"/iq3.2_no_duck
    mkdir -p "$p"/iq3.2_duck
    # cmd="python3 inter_query.py --egress 0.12 $cluster_size tpcds gcp $p > $p/iq3.2_no_duck/algo_all.output"
    # echo $cmd >> algo_cmds3.txt
    for tbl in ${tpcds_names[@]}
    do
        # cmd="python3 inter_query.py --no_calcite --egress 0.12 --duck --exclude_table $tbl $cluster_size tpcds gcp $p > $p/iq3.2_duck/algo_$tbl.output"
        cmd="python3 inter_query.py --no_calcite --egress 0.12 --exclude_table $tbl $cluster_size tpcds gcp $p > $p/iq3.2_no_duck/algo_$tbl.output"
        # cmd="python3 time_series.py --no_calcite --egress 0.12 --exclude_table $tbl $cluster_size tpcds gcp $p > $p/iq3.2_no_duck/algo_$tbl.output"
        # cmd="python3 check_plan_costs.py --no_calcite --egress 0.12 --exclude_table $tbl $cluster_size tpcds gcp estimation/100_true $p > $p/iq3.2_no_duck/algo_$tbl.output"
        echo $cmd >> algo_cmds3.txt
    done
done

# for p in ${paths[@]}
# do
#     mkdir -p "$p"/iqopt_no_duck
#     mkdir -p "$p"/iqopt_duck
#     for tbl in ${tpcds_names[@]}
#     do
#         cmd="python3 inter_query_opt.py --no_calcite --duck --exclude_table $tbl $cluster_size tpcds $p > $p/iqopt_duck/algo_$tbl.output"
#         echo $cmd >> algo_cmds_opt.txt
#         cmd="python3 inter_query_opt.py --no_calcite --exclude_table $tbl $cluster_size tpcds $p > $p/iqopt_no_duck/algo_$tbl.output"
#         echo $cmd >> algo_cmds_opt.txt
#     done
# done



