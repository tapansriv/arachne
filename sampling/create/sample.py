import sys
import os
import numpy as np
import pyarrow as pa
import pyarrow.parquet as pq
import duckdb
from argparse import ArgumentParser
from table_names import tpcds_names


def create_sample(tbl, s):
    f = pq.ParquetFile(f"{tbl}.parquet")
    out = pq.ParquetWriter(f"{tbl}_{s}.parquet", f.schema_arrow)

    bs = f.iter_batches()
    for b in bs:
        n = b.num_rows
        quarter = int(np.ceil(n * s))
        a = np.zeros(n)
        a[:quarter] = 1
        np.random.shuffle(a)
        a = a.astype(bool)
        mask = pa.array(a)
        y = b.filter(mask)
        out.write(y)
    out.close()

def check_sample(tbl, s):
    con = duckdb.connect()
    full_card = con.execute(f"SELECT COUNT(*) FROM '{tbl}.parquet'").fetchall()[0][0]
    sample_card = con.execute(f"SELECT COUNT(*) FROM '{tbl}_{s}.parquet'").fetchall()[0][0]
    ratio = sample_card / full_card
    print(f"Real: {ratio}; Expected: {s}; Full card {full_card}; Sample card: {sample_card}")

tbl = sys.argv[1]
selectivity = sys.argv[2]

parser = ArgumentParser(description="Generate random sample of parquet file")
parser.add_argument("-S", "--selectivity", type=float, default=0.25, help="Selectivity of sample")
parser.add_argument("path", help="Path where data is")
parser.add_argument("tbl", choices=tpcds_names, help="Name of table")
parser.add_argument("op", choices=["create", "check"], default="check", type=str, help="Operation to perform; either create new sample or check cardinalities of existing samples")
args = parser.parse_args()

if args.selectivity > 1 or args.selectivity < 0:
    raise ValueError(f"Invalid selectivity provided {args.selectivity}; must be between 0 and 1")

os.chdir(args.path)
if args.op == "create":
    create_sample(args.tbl, args.selectivity)
elif args.op == "check":
    check_sample(args.tbl, args.selectivity)
else:
    raise ValueError("Invalid op; should've been caught by argparse")

