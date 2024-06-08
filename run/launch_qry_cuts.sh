if [ $# -ne 4 ]
then
    echo "not enough arguments"
    exit
fi

file=$1
src=$2
cost=$3
mvmt=$4

nums=$(cat $file)
cd sqlconverter
mvn compile
cd ..
pwd

for i in ${nums[@]}
do
    ./run_qry_cuts.sh $i $src $cost $mvmt
done
