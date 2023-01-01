#!/bin/bash

start_time=`date +%s`
for f in *.sql
do
    echo $f
    cockroach sql --insecure --host=localhost:26257 --file "$f" > "$f.out" 2>&1 &
done
wait 
end_time=`date +%s`
runtime=$(($end_time - $start_time)) 
echo "Elapsed time: $runtime seconds"


