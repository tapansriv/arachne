if [ $# -ne 1 ]
then
    echo "not enough arguments"
    exit
fi

file=$1
nums=$(cat $file)

for key in ${nums[@]}
do
    echo $key
    python3 profile_mem.py "$key" > ~/arachneDB/disk_results/"$key"
done
