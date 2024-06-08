from argparse import ArgumentParser
import os

parser = ArgumentParser(description="Parse ouptut of DSQGEN from TPC-DS")
parser.add_argument("--input", type=str, default="raw", help="Input file (output of DSQGEN)")
parser.add_argument("--out-dir", type=str, default=None, help="where to put query outputs")
parser.add_argument("--num-variants", type=int, default=10, help="Number of query variants to expect")
args = parser.parse_args()


n = args.num_variants

f = open(args.input)
queries = f.read().split(";")
f.close()

for k in range(len(queries)):
    if queries[k].strip() == "":
        continue
    i = int(k / n) + 1
    j = (k % n) + 1
    
    key_i = str(i+103)
    if (103+i) < 10:
        key_i = f"0{i}"
    out_name = f"query{key_i}_{j}.sql"
    outfile = out_name
    if args.out_dir:
        outfile = os.path.join(args.out_dir, out_name)
    with open(outfile, 'w') as fp:
        fp.write(queries[k])
