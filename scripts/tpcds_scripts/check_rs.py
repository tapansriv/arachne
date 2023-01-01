import json
f = open('redshift.json')
foo = json.load(f)

nums = [n for n in range(1,100)]
for n in nums:
    key = str(n)
    if n < 10:
        key = "0" + key

    if key not in foo:
        print(key)
