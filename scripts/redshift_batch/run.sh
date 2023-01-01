cid=$1
python3 load_serial.py 1 rs1-1tb  > rs1_load_1tb.out
python3 query_serial.py --cid "$cid" > "$cid"_query.out
