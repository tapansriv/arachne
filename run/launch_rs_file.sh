
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
cd ../sqlconverter
mvn compile

for i in ${nums[@]}
do
    key="$i"
    if [ $i -lt 10 ]
    then
        key=0"$i"
    fi
    echo $key
    args="-Dexec.args=\"single $src $i $cost $mvmt\""
    echo $args
    echo $args > ~/arachneDB/data/$key.output 2>&1 
    mvn exec:java -Dexec.mainClass=org.arachne.ArachneQueryProcessor -Dexec.args="single $src $i $cost $mvmt" >> ~/arachneDB/data/$key.output 2>&1
done
