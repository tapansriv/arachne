outdir=/home/cc/arachneDB/psql_query_plans/orig
for i in {1..99}
do
    key="$i"
    if [ $i -lt 10 ]
    then
        key="0$i"
    fi
    outfile="$outdir"/"$key"
    file=/home/cc/arachneDB/a_queries/"$key".sql
    txt=$(cat $file)
    cmd="EXPLAIN $txt"
    echo $file
    echo "$cmd" > tmp
    psql -f tmp > $outfile
    rm tmp
done

outdir=/home/cc/arachneDB/psql_query_plans/calcite
for i in {1..99}
do
    key="$i"
    if [ $i -lt 10 ]
    then
        key="0$i"
    fi
    outfile="$outdir"/"$key"
    file=/home/cc/arachneDB/c_queries/psql/"$key".sql
    txt=$(cat $file)
    cmd="EXPLAIN $txt"
    echo $file
    echo "$cmd" > tmp
    psql -f tmp > $outfile
    rm tmp
done
