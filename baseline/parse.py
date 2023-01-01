import json

f = open("tpcds_old.out")
lines = [x.rstrip() for x in f.readlines()]
missed = []
next_expected = 1
output = {}
for line in lines:
    if line[2:6] != ".sql":
        continue
    key = line[:2]
    index = int(line[:2])
    time = float(line[8:])
    output[key] = time
    if index != next_expected:
        diff = index - next_expected
        while diff > 0:
            missed.append(next_expected)
            next_expected += 1
            diff -= 1
    next_expected = index + 1

for m in missed:
    mkey = str(m)
    if m < 10:
        mkey = "0" + mkey
    output[mkey] = -1

with open("times", "w") as fp:
    json.dump(output, fp, sort_keys=True)
