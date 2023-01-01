import numpy as np

# bqs = np.linspace(5.25, 10, 20)
# bqs = np.linspace(0.25, 5, 20)
bqs = np.linspace(0.25, 10, 40)
# egresses = np.linspace(0.125, 0.24, 24)
egresses  = np.linspace(0, 0.115, 24)
egresses2 = np.linspace(0.125, 0.24, 24)


for bq in bqs:
    if bq == 5:
        continue
    print(f"./gen_what_if.sh parquet_1000/real_data_rs1 1 0.12 1.086 {bq} 1.48")
    print(f"./gen_what_if.sh parquet_1000/real_data_rs4 4 0.12 1.086 {bq} 1.48")
    print(f"./gen_what_if.sh parquet_2000/real_data_rs1 1 0.12 1.086 {bq} 1.48")
    print(f"./gen_what_if.sh parquet_2000/real_data_rs4 4 0.12 1.086 {bq} 1.48")


for e2 in egresses:
    e = np.round(e2, 3)
    print(f"./gen_what_if.sh parquet_1000/real_data_rs1 1 {e} 1.086 5 1.48")
    print(f"./gen_what_if.sh parquet_1000/real_data_rs4 4 {e} 1.086 5 1.48")
    print(f"./gen_what_if.sh parquet_2000/real_data_rs1 1 {e} 1.086 5 1.48")
    print(f"./gen_what_if.sh parquet_2000/real_data_rs4 4 {e} 1.086 5 1.48")

for e2 in egresses2:
    e = np.round(e2, 3)
    print(f"./gen_what_if.sh parquet_1000/real_data_rs1 1 {e} 1.086 5 1.48")
    print(f"./gen_what_if.sh parquet_1000/real_data_rs4 4 {e} 1.086 5 1.48")
    print(f"./gen_what_if.sh parquet_2000/real_data_rs1 1 {e} 1.086 5 1.48")
    print(f"./gen_what_if.sh parquet_2000/real_data_rs4 4 {e} 1.086 5 1.48")
