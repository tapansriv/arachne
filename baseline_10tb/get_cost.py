import sys
import math
import json

assert len(sys.argv) == 3
key = sys.argv[1]
system = sys.argv[2]

assert system in ["duck", "duck_c", "bigquery"]

fname = f"{system}_baseline_10tb.json"

data = json.load(open(fname))
if system == "bigquery":
    b = data[key]["bytes"]
    cost = 5 * (b / math.pow(2,40))
    print(f"BigQuery Cost: ${cost}")
elif system == "rs":
    r = data[key]
    cost = 1.086 * (r / 3600)
    print(f"Redshift Cost: ${cost}")
elif system == "duck" or system == "duck_c":
    r = data[key]
    cost = 1.48 * (r / 3600)
    print(f"DuckDB Cost: ${cost}")
else:
    raise ValueError("You fuckup")
