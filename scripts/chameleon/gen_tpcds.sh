#!/bin/bash

for i in {1..40}
do
	./dsdgen -SCALE 100 -PARALLEL 40 -CHILD $i &
done
wait
