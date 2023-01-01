import json

duck = json.load(open("duck_baseline.json"))
duck_c = json.load(open("duck_c_baseline.json"))

duck_keys = duck.keys()
duck_c_keys = duck_c.keys()

y = duck_keys & duck_c_keys
print(y == duck_keys)
print(y == duck_c_keys)

rs = json.load(open("rs_baseline.json"))
rs_c = json.load(open("rs_c_baseline.json"))

y = rs.keys() & rs_c.keys()
print(y == rs.keys())
print(y == rs_c.keys())

duck_comp = []
duck_c_comp = []
rs_comp = []
rs_c_comp = []

for i in range(1, 100):
    key = str(i)
    if i < 10:
        key = "0" + key

    if key not in duck:
        duck_comp.append(key)
    if key not in duck_c:
        duck_c_comp.append(key)
    if key not in rs:
        rs_comp.append(key)
    if key not in rs_c:
        rs_c_comp.append(key)

files = ["rs_comp", "rs_c_comp", "duck_comp", "duck_c_comp"]
arrays = [rs_comp, rs_c_comp, duck_comp, duck_c_comp]

for i in range(4):
    f = open(files[i], "w")
    qry = "\n".join(arrays[i])
    f.write(qry)
    f.close()







