#!/bin/bash

keys=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12" "13" "14" "15" "16" "17" "18" "19" "20" "21" "22")

# for i in {1..99}
for i in ${keys[@]}
do
    key="$i"
    # if [ $i -lt 10 ]
    # then
    #     key="0$i"
    # fi
    echo "$key"
    cockroach sql --insecure --database=tpch --host=localhost:26257 --file "$key".sql --set show_times > "$key".out 2>&1
done

