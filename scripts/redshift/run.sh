cid=$1
size=$2
# path="redshift_queries"
# path="runtime_estimation/queries"
path="custom_workload/redshift_queries"
# python3 load_tpcds.py $size $cid # > "$cid"_load.out
# python3 query_workload.py --cid "$cid" $path #> "$cid"_query.out
python3 explain.py --cid "$cid" $path #> "$cid"_query.out

