import json

f = open('times')
x = json.load(f)
for k in x:
    if x[k] == -1:
        print(k)
