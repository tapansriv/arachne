#!/bin/bash
# IMPORTANT: this script should be called from the  launch script

if [ $# -ne 6 ]
then
    echo "not enough arguments"
    exit
fi

key=$1
src=$2
schema=$3
cost=$4
mvmt=$5
iter=$6

cd ~/arachne/sqlconverter
# mvn compile

fname=~/arachne/data/"$key".done

if [ "$schema" == "tpcds" ] 
then
    if [ $key -lt 10 ]
    then
        key=0"$key"
    fi
fi
echo $key

args="-Dexec.args=\"single $src $schema $key $cost $mvmt $iter\""
echo $args
echo $args >> ~/arachne/data/$key.output 2>&1 

if [ ! -f "$fname" ] ;
then
    args="-Dexec.args=\"single $src $schema $key $cost $mvmt $iter\""
    echo $args

    mvn exec:java -Dexec.mainClass=org.arachne.ArachneQueryProcessor -Dexec.args="single $src $schema $key $cost $mvmt $iter" >> ~/arachne/data/$key.output 2>&1
fi
