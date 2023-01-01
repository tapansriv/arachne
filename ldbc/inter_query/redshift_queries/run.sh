#!/bin/bash

for f in *.sql
do
    echo $f
    start_time=`date +%s%3N`
    cockroach sql --insecure --host=localhost:26257 --file $f > $f.out 2>&1
    end_time=`date +%s%3N`
    runtime=$(($end_time - $start_time))
    echo $runtime
done
