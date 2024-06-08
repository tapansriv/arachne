#!/bin/bash
# IMPORTANT: this script should be called from the  launch script

if [ $# -ne 4 ]
then
    echo "not enough arguments"
    exit
fi

key=$1
src=$2
cost=$3
mvmt=$4

cd ~/arachneDB/sqlconverter
# mvn compile

fname=/home/cc/arachneDB/data/"$key".done

if [ $key -lt 10 ]
then
    key=0"$key"
fi
echo $key

iter=0
args="-Dexec.args=\"single $src $key $cost $mvmt $iter\""
echo $args
echo $args > ~/arachneDB/data/$key.output 2>&1 

while [ ! -f "$fname" ] ;
do
    args="-Dexec.args=\"single $src $key $cost $mvmt $iter\""
    echo $args

    mvn exec:java -Dexec.mainClass=org.arachne.ArachneQueryProcessor -Dexec.args="single $src $key $cost $mvmt $iter" >> ~/arachneDB/data/$key.output 2>&1
    iter=$(($iter+1))
done
