# qs=(100 1000 10000 50000 100000)
qs=(100 500 1000 2500 5000 7500 10000 12500 15000 20000 50000 75000 100000)
ts=(100)


for q in ${qs[@]}
do
    for t in ${ts[@]}
    do
        echo "$q, $t"
        python3 parquet_1000/opt_test/resize.py --num_queries $q --num_tables $t

        start_time=`date +%s%3N`
        python3 inter_query_opt.py --no_calcite --cluster_size 1 opt_test parquet_1000/opt_test
        end_time=`date +%s%3N`
        opt_runtime=$(($end_time - $start_time))
        echo "Optimal: $opt_runtime"

        start_time=`date +%s%3N`
        python3 inter_query.py --no_calcite --cluster_size 1 opt_test gcp parquet_1000/opt_test
        end_time=`date +%s%3N`
        gdy_runtime=$(($end_time - $start_time))
        echo "Greedy: $gdy_runtime"

        f=out_"$q"_"$t"_"$c".txt
        echo "$opt_runtime, $gdy_runtime" > $f
    done
done
