if [ $# -ne 2 ]
then
    echo "not enough arguments"
    exit
fi

file=$1
t=$2
nums=$(cat $file)

cd scripts/duckdb

for i in ${nums[@]}
do
    key="$i"
    if [ $i -lt 10 ]
    then
        key=0"$i"
    fi
    echo $key
    python3 run_baseline.py $key $t > ~/arachneDB/data/"$key"_baseline.output 2>&1
done
