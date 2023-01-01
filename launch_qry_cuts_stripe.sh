if [ $# -ne 5 ]
then
    echo "not enough arguments"
    exit
fi

file=$1
src=$2
schema=$3
cost=$4
mvmt=$5

nums=$(cat $file)
cd sqlconverter
mvn compile
cd ..
pwd


iter=0
while [ $iter -lt 20 ]
do
    for i in ${nums[@]}
    do
        ./run_one_iter.sh $i $src $schema $cost $mvmt $iter
    done
    iter=$(($iter+1))
done
