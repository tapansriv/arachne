#!/bin/bash

for f in ./schema/*.sql
do
    psql -f "$f"
done
