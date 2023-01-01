if [ $# -ne 1 ]
then
    echo "not enough arguments"
    exit
fi

file=$1
nums=$(cat $file)

cd scripts/redshift_explain

for i in ${nums[@]}
do
    key="$i"
    if [ $i -lt 10 ]
    then
        key=0"$i"
    fi
    echo $key
    python3 run_baseline.py $key > ~/arachneDB/data/$key.output 2>&1
done
