if [ $# -ne 5 ]
then
    echo "not enough arguments"
    exit
fi

cd sqlconverter
mvn compile
start=$1
end=$2
src=$3
cost=$4
mvmt=$5
nums=$(seq $start $end)

for i in ${nums[@]}
do
    key="$i"
    if [ $i -lt 10 ]
    then
        key=0"$i"
    fi
    echo $key

    if [ $i -eq 72 ] || [ $i -eq 18 ] || [ $i -eq 61 ] || [ $i -eq 64 ] || [ $i -eq 78 ] || [ $i -eq 85 ] || [ $i -eq 95 ] || [ $i -eq 97 ]
    then
        echo "Skipping $i"
        echo "Skipping $i" > ~/arachneDB/data/$key.output
        continue
    fi
    args="-Dexec.args=\"single $src $i $cost $mvmt\""
    echo $args
    echo $args > ~/arachneDB/data/$key.output 2>&1 
    mvn exec:java -Dexec.mainClass=org.arachne.ArachneQueryProcessor -Dexec.args="single $src $i $cost $mvmt" >> ~/arachneDB/data/$key.output 2>&1
done
