#!/bin/bash

# for k in custom_workload/to_verify/*.sql
for k in "10a" "10b" "10c" "11a" "11b" "11c"
do
    echo $k
    python3 run_qry.py --outfile "$k.out" --cid rs4-1tb-2 "custom_workload/redshift_queries/$k.sql"
done

python3 cluster_funcs.py --cid rs4-1tb-2 pause
