#!/bin/bash

keys=("17c" "4c" "24a" "11c" "23c" "33c" "8b" "20c" "17e" "29a" "30c" "22b" "15c" "2d" "27c" "23a" "16a" "16c" "13c" "1b" "15b" "19d" "12a" "14c" "21b" "10c" "14b" "18b" "3a" "27a" "22d" "15d" "27b" "28c" "31b" "15a" "7a" "17d" "6e" "22a" "12c" "7b" "31a" "11b" "2b" "9d" "5b" "30a" "29b" "33a" "3c" "31c" "16d" "8a" "18a" "6c" "32b" "6d" "2a" "32a" "17a" "24b" "18c" "3b" "6f" "28b" "20b" "33b" "26a" "25b" "10a" "17f" "1d" "1c" "8d" "19b" "6b" "26c" "17b" "8c" "29c" "26b" "7c" "30b" "11d" "13a" "5a" "10b" "9c" "4b" "5c" "1a" "20a" "21a" "9b" "16b" "19c" "2c" "4a" "22c" "9a" "23b" "11a" "6a" "28a" "12b" "14a" "19a" "21c" "13b" "13d" "25a" "25c")

# for i in {1..99}
for i in ${keys[@]}
do
    key="$i"
    # if [ $i -lt 10 ]
    # then
    #     key="0$i"
    # fi
    echo "$key"
    cockroach sql --insecure --database=imdb --host=localhost:26257 --file "$key".sql --set show_times > "$key".out 2>&1
done

