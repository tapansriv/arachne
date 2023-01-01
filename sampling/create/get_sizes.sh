#!/bin/zsh 
#
gsutil du "gs://arachne-tpcds/sample_0.15/*.parquet" > file_sizes_0.15.out
gsutil du "gs://arachne-tpcds/sample_0.25/*.parquet" > file_sizes_0.25.out
gsutil du "gs://arachne-tpcds/sample_0.5/*.parquet" > file_sizes_0.5.out

python3 get_sizes.py
