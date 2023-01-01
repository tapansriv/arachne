#!/bin/bash

src=$1
key=$2

orig_file="$key"_orig
c_file="$key"_calcite
if [ $src == "duck" ]
then 
    orig_file="$key"_orig_1
    c_file="$key"_calcite_1
fi
file1="$src"_query_plans/"$orig_file"
file2="$src"_c_query_plans/"$c_file"

diff $file1 $file2

