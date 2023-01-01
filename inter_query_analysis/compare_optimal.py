import json
from table_names import tpcds_names

dirs = ["parquet_1000/batch_rs1", "parquet_1000/batch_rs4",
        "parquet_1000/batch_rs8", "parquet_2000/batch_rs1",
        "parquet_2000/batch_rs4", "parquet_2000/batch_rs8",
        "parquet_1000/internal2024_rs1", "parquet_1000/internal2024_rs4",
        "parquet_1000/internal2024_rs8", "parquet_2000/internal2024_rs1",
        "parquet_2000/internal2024_rs4", "parquet_2000/internal2024_rs8"
       ]


i = 0
for dir_ in dirs:
    rs_cost = 1.086
    if "rs4" in dir_:
        rs_cost = rs_cost * 4
    elif "rs8" in dir_:
        rs_cost = rs_cost * 8

    greedy_duck = json.load(open(f"{dir_}/outputs_NOCALCITE_duck_0.12_{rs_cost}_6.25_1.48.json"))
    optimal_duck = json.load(open(f"{dir_}/optimal_NOCALCITE_duck_GCP_0.12_{rs_cost}_6.25_1.48.json"))

    greedy_noduck = json.load(open(f"{dir_}/outputs_NOCALCITE_noduck_GCP_0.12_{rs_cost}_6.25.json"))
    optimal_noduck = json.load(open(f"{dir_}/optimal_NOCALCITE_noduck_GCP_0.12_{rs_cost}_6.25.json"))
    
    for tbl in tpcds_names:
        i += 2
        greedy_tbls = greedy_duck[tbl]['exec_details']['moved_tables'].sort()
        optimal_tables = optimal_duck[tbl]['moved_tables'].sort()

        greedy_tbls = greedy_noduck[tbl]['exec_details']['moved_tables'].sort()
        optimal_tables = optimal_noduck[tbl]['moved_tables'].sort()
        print(greedy_tbls == optimal_tables)


print(i)
