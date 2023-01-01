#!/bin/bash

tpcds_names=("call_center" "catalog_page" "catalog_returns" "catalog_sales" "customer" "customer_address" "customer_demographics" "date_dim" "household_demographics" "income_band" "inventory" "item" "promotion" "reason" "ship_mode" "store" "store_returns" "store_sales" "time_dim" "warehouse" "web_page" "web_returns" "web_sales" "web_site") 

paths=("parquet_1000/real_data_rs1" "parquet_1000/real_data_rs4" "parquet_2000/real_data_rs1" "parquet_2000/real_data_rs4")
paths=("parquet_1000/internal_rs1" "parquet_1000/internal_rs4" "parquet_2000/internal_rs1" "parquet_2000/internal_rs4")

for p in ${paths[@]}
do
    # pre1="$p"/iq3.1_no_duck
    pre1="$p"/iqopt_no_duck
    pre2="$p"/iq3.1_no_duck
    for tbl in ${tpcds_names[@]}
    do
        f1="$pre1"/algo_"$tbl".output
        f2="$pre2"/algo_"$tbl".output
        o="$(diff <(grep "Optimal Subset" "$f1") <(grep "Optimal Subset" "$f2"))"
        echo $o
        if [ ! -z "$o" ] 
        then
            echo "$f1", "$f2"
            echo "$p", "$tbl", noduck misaligned
            echo "Gre:  $(grep "Optimal Subset" "$f1")"
            echo "Opt:  $(grep "Optimal Subset" "$f2")"
        fi

    done
done

for p in ${paths[@]}
do
    # pre1="$p"/iq3.1_duck
    pre1="$p"/iqopt_duck
    pre2="$p"/iq3.1_duck
    for tbl in ${tpcds_names[@]}
    do
        f1="$pre1"/algo_"$tbl".output
        f2="$pre2"/algo_"$tbl".output
        # echo "$f1", "$f2"
        o="$(diff <(grep "Optimal Subset" "$f1") <(grep "Optimal Subset" "$f2"))"
        # echo $o
        if [ ! -z "$o" ] 
        then
            echo "$p", "$tbl", duck misaligned
            echo $(grep "Optimal Subset" "$f1")
            echo $(grep "Optimal Subset" "$f2")
        fi

    done
done


