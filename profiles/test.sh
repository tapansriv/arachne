for i in {10..99}
do
    fname="$i"/"$i"_final.json
    if [ ! -f "$fname" ] 
    then
        echo $i
    fi
done

