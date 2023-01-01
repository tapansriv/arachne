paths=("mixed" "io_90" "io_5" "io_2" "cpu_0.5" "cpu_0.1")

for p in ${paths[@]}
do
    python3 inter_query.py --cluster_size 4 tpcds gcp "custom_workload/$p"
    python3 inter_query.py --cluster_size 4 tpcds aws "custom_workload/$p"
done
