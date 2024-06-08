if [ $# -ne 3 ]
then
    echo "not enough arguments"
    exit
fi

file=$1
s=$2
name=$3
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
    python3 run_baseline_sample.py $key $s $name calcite > ~/arachneDB/data/"$key"_"$s".output 2>&1
done
