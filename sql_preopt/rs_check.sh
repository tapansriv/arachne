#!/bin/bash

nums=$(seq 1 99)

cnt=0
to_check=()
for n in ${nums[@]}
do
    key="$n"
    if [ $n -lt 10 ]
    then
        key="0$n"
    fi
    # echo "std/$key"
    if [ -s rs_std_query_plans/"$key"_std ] ; 
    then
        if [ -s rs_c_query_plans/"$key"_calcite ] 
        then
            to_check+=( $n )
            cnt=$(($cnt +1))
        fi
    fi
done
echo "num checking: $cnt"

num_diff=0
for n in ${to_check[@]}
do
    key="$n"
    if [ $n -lt 10 ]
    then
        key="0$n"
    fi
    o=$(diff rs_std_query_plans/"$key"_std rs_c_query_plans/"$key"_calcite)
    if [ ! -z "$o" ]
    then
        echo "$key different"
        num_diff=$(($num_diff + 1))
    fi
done
echo "number diff: $num_diff"
