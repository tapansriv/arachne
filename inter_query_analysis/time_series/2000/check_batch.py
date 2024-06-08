import json
query_keys = ["03", "06", "07", "08", "09", "13", "19", "21", "22", "27", "28","34", "36",
              "39", "42", "43", "44", "46", "47", "48", "52", "53", "55", "59", "61", "63",
              "65", "67", "68", "70", "73", "79", "82", "88", "89", "96", "98"]

rs = json.load(open("rs_baseline.json"))
rs_c = json.load(open("rs_c_baseline.json"))

serial_time = 0
for q in query_keys: 
    if q not in rs_c:
        serial_time += rs[q]
    elif rs_c[q] < rs[q]:
        serial_time += rs_c[q]
    else: 
        serial_time += rs[q]

print(f"Serial time: {serial_time} seconds")
print("1321.775420665741")
