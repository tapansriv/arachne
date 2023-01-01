#!/bin/bash

if [ $# -lt 1 ]
then
    echo "no path provided"
    exit
fi

ldbc_names=("organisation" "place" "tag" "tagclass" "message" "message_tag" "forum" "forum_person" "forum_tag" "person" "person_tag" "knows" "likes" "person_university" "person_company")

paths=$1
cluster_size="--cluster_size $2"


for p in ${paths[@]}
do
    mkdir -p "$p"/iq3.2_no_duck
    mkdir -p "$p"/iq3.2_duck

    for tbl in ${ldbc_names[@]}
    do
        cmd="python3 inter_query.py --egress 0.12 --exclude_table $tbl $cluster_size ldbc gcp $p > $p/iq3.2_no_duck/algo_$tbl.output"
        echo $cmd >> algo_cmds3.txt
    done
done

