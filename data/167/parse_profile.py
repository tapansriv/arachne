import sys

assert len(sys.argv) > 1

key = sys.argv[1]
f = open(f"{key}.profile")
lines = [x.strip() for x in f.readlines()]

total_runtime = 0
for l in lines:
    vals = l.split(",")
    assert vals[0] == "totalProfileRuntime"
    r = float(vals[1])
    total_runtime += r

total_cost = (total_runtime / 3600) * 1.48
print(f"Profiling Cost for {key}: ${total_cost}")

