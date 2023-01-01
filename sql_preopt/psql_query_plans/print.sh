#!/bin/bash

key=$1

file1=orig/"$key"
file2=calcite/"$key"

diff $file1 $file2

