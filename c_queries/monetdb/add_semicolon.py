import glob

for fname in glob.glob("*.sql"):
    f = open(fname)
    qry = f.read()
    f.close()
    qry += ";"
    f = open(fname, 'w')
    f.write(qry)
    f.close()


