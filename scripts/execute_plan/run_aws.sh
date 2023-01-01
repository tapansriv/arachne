#!/bin/bash

path=$1
key=$2


# python3 bq_batch.py --cid $cid --outfile "$key"_aws_bq aws $path &

# assume data already loaded
# python3 load_batch.py --cid $cid --outfile "$key"_aws_load aws $path 
python3 query_batch.py --cid rs4-1tb-2 --outfile "$key"_aws_query aws $path 

wait
echo "Done"


