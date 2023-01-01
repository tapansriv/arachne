#!/bin/bash

cid=$1
path=$2
key=$3

echo $cid
echo $path
echo $key


# python3 bq_batch.py --cid $cid --outfile "$key"_gcp_bq gcp $path &

python3 load_batch.py --cid $cid --outfile "$key"_gcp_load 1 gcp $path 
python3 query_batch.py --cid $cid --outfile "$key"_gcp_query gcp $path 

wait
echo "finished GCP plan"

