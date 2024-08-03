if [ $# -ne 1 ]
then
    echo "not enough arguments"
    exit
fi

file=$1
nums=$(cat $file)

for i in ${nums[@]}
do
    key="$i"
    if [ $i -lt 10 ]
    then
        key=0"$i"
    fi
    if [ $i -lt 4 ]
    then
        continue
    fi

    echo $key
    python3 test_cache.py "$key" 0 > ~/arachne/data/"$key"
done
