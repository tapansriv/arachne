python3 get_max.py --cluster_size 1 gcp parquet_1000/batch_rs1 
python3 get_max.py --cluster_size 4 gcp parquet_1000/batch_rs4 
python3 get_max.py --cluster_size 8 gcp parquet_1000/batch_rs8 
python3 get_max.py --cluster_size 1 gcp parquet_2000/batch_rs1 
python3 get_max.py --cluster_size 4 gcp parquet_2000/batch_rs4 
python3 get_max.py --cluster_size 8 gcp parquet_2000/batch_rs8 

# python3 get_max.py --cluster_size 1 --no_calcite gcp parquet_1000/batch_rs1 
# python3 get_max.py --cluster_size 4 --no_calcite gcp parquet_1000/batch_rs4 
# python3 get_max.py --cluster_size 8 --no_calcite gcp parquet_1000/batch_rs8 
# python3 get_max.py --cluster_size 1 --no_calcite gcp parquet_2000/batch_rs1 
# python3 get_max.py --cluster_size 4 --no_calcite gcp parquet_2000/batch_rs4 
# python3 get_max.py --cluster_size 8 --no_calcite gcp parquet_2000/batch_rs8 

# python3 get_max.py --cluster_size 1 --no_calcite gcp parquet_1000/internal2024_rs1
# python3 get_max.py --cluster_size 4 --no_calcite gcp parquet_1000/internal2024_rs4
# python3 get_max.py --cluster_size 8 --no_calcite gcp parquet_1000/internal2024_rs8
# python3 get_max.py --cluster_size 1 --no_calcite gcp parquet_2000/internal2024_rs1
# python3 get_max.py --cluster_size 4 --no_calcite gcp parquet_2000/internal2024_rs4
# python3 get_max.py --cluster_size 8 --no_calcite gcp parquet_2000/internal2024_rs8

# python3 get_max.py custom_workload/cpu_0.5 1000 4 no
# python3 get_max.py custom_workload/mixed 1000 4 no
# python3 get_max.py custom_workload/io_2    1000 4 no



