import json
import sys

keys = [2, 3, 4, 7, 11, 12, 13, 15, 19, 20, 21, 22, 26, 27, 28, 31, 33, 34, 36, 37, 38, 39, 40, 42, 43, 46, 47, 48, 49, 50, 52, 53, 55, 56, 57, 59, 60, 62, 63, 66, 67, 68, 70, 73, 74, 77, 79, 82, 83, 84, 86, 87, 88, 89, 90, 91, 93, 96, 98, 99]

for k in keys:
    key = f"{k}"
    if k < 10:
        key = f"0{k}"

    f = open(f"{key}_profile.json")
    lines = f.readlines()
    f.close()

    size = len(lines)

    i = 0
    while i < size:
        l = lines[i]
        line = l.strip()
        if line.startswith("\"extra-info\""):
            lines.remove(l)
            break
        i += 1

    with open(f"{key}_profile.json", "w") as fp:
        s = "".join(lines)
        fp.write(s)

