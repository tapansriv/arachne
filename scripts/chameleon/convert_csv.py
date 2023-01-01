import pyarrow as pa
import pyarrow.parquet as pq
import pandas as pd

files = ["customer", "part", "region", "lineitem", "orders",
        "partsupp", "supplier"]

for f in files:
    print(f"{f}")
    fname = f"./{f}.parquet"
    df1 = pq.read_table(fname).to_pandas() 
    df1.to_csv(
        f'./{f}.csv',
        sep=',',
        index=False,
        mode='w',
        line_terminator='\n',
        encoding='utf-8')

    print(f"end {f}")
