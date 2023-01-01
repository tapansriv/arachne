if [ $# -ne 3 ]
then
    echo "not enough arguments"
    exit
fi

file=$1
src=$2
schema=$3
nums=$(cat $file)
cd sqlconverter
mvn compile

for i in ${nums[@]}
do
    key="$i"
    if [ $i -lt 10 ]
    then
        key=0"$i"
    fi
    echo $key
    args="-Dexec.args=\"calcify $src $i\""
    echo $args
    echo $args > ~/arachneDB/data/$key.output 2>&1 
    mvn exec:java -Dexec.mainClass=org.arachne.ArachneQueryProcessor -Dexec.args="calcify $src $schema $i" >> ~/arachneDB/data/$key.output 2>&1
done
