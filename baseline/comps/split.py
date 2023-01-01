f = open("../duck_comp")
lines = [x.strip() for x in f.readlines()]

for i in range(4):
    start = 8*i
    end = start + 8
    part = lines[start:end]
    qry = "\n".join(part)
    fp = open(f"duck_comp{i+1}", "w")
    fp.write(qry)
    fp.close()
