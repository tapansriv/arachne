import json

f1 = open("rs_baseline.json")
f2 = open("../real_data_rs8/rs_baseline.json")
rs4 = json.load(f1)
rs8 = json.load(f2)

keys = sorted(rs4.keys() & rs8.keys())

neg = []
pos = []
for k in keys:
    time1 = rs4[k]
    time2 = rs8[k]

    diff = (time1 - time2) 
    pdiff = 100 * (diff / time1)

    x = (f"{k}: {diff} seconds; {pdiff:.2f}%")
    if diff > 0:
        pos.append(x)
    else:
        neg.append(x)

print(f"8 Nodes Faster: {len(pos)}")
for s in pos:
    print(s)

print(f"8 Nodes Slower: {len(neg)}")
for s in neg:
    print(s)


