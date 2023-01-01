import numpy as np

bqs = np.linspace(0.25, 12.5, 50)
egresses = np.linspace(0, 0.24, 49)


for bq in bqs:
    print(f"./gen_what_if.sh custom_workload/cpu_0.5 4 0.09 1.086 {bq} 1.48")
    print(f"./gen_what_if.sh custom_workload/mixed   4 0.09 1.086 {bq} 1.48")
    print(f"./gen_what_if.sh custom_workload/io_2    4 0.09 1.086 {bq} 1.48")
    # print(f"./gen_what_if.sh parquet_2000/batch_rs1 1 0.12 1.086 {bq} 1.48")
    # print(f"./gen_what_if.sh parquet_2000/batch_rs4 4 0.12 1.086 {bq} 1.48")
    # print(f"./gen_what_if.sh parquet_2000/batch_rs8 8 0.12 1.086 {bq} 1.48")


for e2 in egresses:
    e = np.round(e2, 3)
    # print(f"./gen_what_if.sh custom_workload/cpu_0.5 4 {e} 1.086 6.25 1.48")
    # print(f"./gen_what_if.sh custom_workload/mixed   4 {e} 1.086 6.25 1.48")
    # print(f"./gen_what_if.sh custom_workload/io_2    4 {e} 1.086 6.25 1.48")

    # print(f"./gen_what_if.sh parquet_1000/batch_rs1 1 {e} 1.086 6.25 1.48")
    # print(f"./gen_what_if.sh parquet_1000/batch_rs4 4 {e} 1.086 6.25 1.48")
    # print(f"./gen_what_if.sh parquet_1000/batch_rs8 8 {e} 1.086 6.25 1.48")
    # print(f"./gen_what_if.sh parquet_2000/batch_rs1 1 {e} 1.086 6.25 1.48")
    # print(f"./gen_what_if.sh parquet_2000/batch_rs4 4 {e} 1.086 6.25 1.48")
    # print(f"./gen_what_if.sh parquet_2000/batch_rs8 8 {e} 1.086 6.25 1.48")

