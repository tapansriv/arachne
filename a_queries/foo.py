f = open("skipped")
lines = [x.strip() for x in f.readlines()]
print(lines)

for i in range(2,100):
    key = i
    if i < 10:
        key = f"0{i}"
    if str(key) in lines:
        continue
    else:
        print(f"\"{key}\"", end = " ")

print("")
