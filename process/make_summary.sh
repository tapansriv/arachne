#!/bin/zsh

dir=$1
cd ~/arachneDB/"$dir"/worked
filename="../gen_worked"
numholds=$(cat $filename)
for num ($=numholds)
do
    key="$num"
    if [ $num -lt 10 ]
    then
        key=0"$num"
    fi
    p=$(tail -1 "$key".out)
    # echo "$num,$p"
    echo "$key,$p" >> summary.txt
done
