import json

bq_parquet = json.load(open("bigquery_parquet_baseline_1tb.json"))
# bq_parquet = json.load(open("bigquery_baseline_2tb.json"))
bq_internal = json.load(open("bigquery_internal_baseline_1tb.json"))

keys = sorted(bq_parquet.keys() & bq_internal.keys())

num_diff = 0
num_big_diff = 0
num_small_diff = 0
for k in keys:
    pv = bq_parquet[k]
    iv = bq_internal[k]

    byte_diff = pv["bytes"] - iv["bytes"]
    cost_diff = 5 * (byte_diff / 1_000_000_000_000)
    percent_byte_diff = 100* (byte_diff / pv["bytes"])
    time_diff = pv["time"] - iv["time"] # seconds
    percent_time_diff = time_diff / pv["time"]

    output_byte = f"{k}: byte_diff: {byte_diff}, cost_diff: ${cost_diff}, % diff: {percent_byte_diff}"
    if k == "67":
        pvcost = 5 * (pv["bytes"] / 1_000_000_000_000)
        ivcost = 5 * (iv["bytes"] / 1_000_000_000_000)
        print(f"{k}: parquet cost: ${pvcost}, internal cost: ${ivcost}")

    print(output_byte)

    if byte_diff != 0:
        num_diff += 1
        if percent_byte_diff > 1:
            num_big_diff += 1
        else: 
            num_small_diff += 1

    # output_time = f"{k}: time_diff: {time_diff}, % diff: {percent_time_diff}"
    # print(output_time)

print(f"Keys: {len(keys)}, Number Different: {num_diff}, Num >1%: {num_big_diff}, Num <1%: {num_small_diff}")

# print("\n ===================================== \n")
# for k in keys:
#     pv = bq_parquet[k]
#     iv = bq_internal[k]
# 
#     byte_diff = pv["bytes"] - iv["bytes"]
#     cost_diff = 5 * (byte_diff / 1_000_000_000_000)
#     percent_byte_diff = byte_diff / pv["bytes"]
#     time_diff = pv["time"] - iv["time"] # seconds
#     percent_time_diff = time_diff / pv["time"]
# 
#     # output_byte = f"{k}: byte_diff: {byte_diff}, cost_diff: ${cost_diff}, % diff: {percent_byte_diff}"
#     # print(output_byte)
# 
#     output_time = f"{k}: time_diff: {time_diff}, % diff: {percent_time_diff}"
#     print(output_time)


