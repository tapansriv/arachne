import sys
import os
import time
import duckdb

sf = sys.argv[1]
con = duckdb.connect(f"ldbc-sf{sf}.db")
con.execute(f"pragma memory_limit='57g'")

data_dir = f"out-sf{sf}"
print("Load initial snapshot")

# initial snapshot
static_path = f"{data_dir}/graphs/parquet/raw/composite-merged-fk/static"
dynamic_path = f"{data_dir}/graphs/parquet/raw/composite-merged-fk/dynamic"

static_entities = ["organisation", "place", "tag", "tagclass"]

dynamic_entities = ["comment", "message_tag", "forum", "forum_person",
        "forum_tag", "person", "person_tag", "knows", "likes",
        "person_university", "person_company", "post"]

# static_entities = []

# dynamic_entities = ["person", "forum", "knows"]

dbs_data_dir = data_dir

print("## Static entities")
for entity in static_entities:
    for csv_file in [f for f in os.listdir(f"{static_path}/{entity}") if f.startswith("part_") and f.endswith(".parquet")]:
        csv_path = f"{entity}/{csv_file}"
        print(f"- {csv_path}")
        con.execute(f"COPY {entity} FROM '{static_path}/{entity}/{csv_file}' (FORMAT 'parquet')")
print("Loaded static entities.")

print("## Dynamic entities")
for entity in dynamic_entities:
    print(entity)
    if entity == "message_tag":
        for csv_file in [f for f in os.listdir(f"{dynamic_path}/Post_hasTag_Tag") if f.startswith("part_") and f.endswith(".parquet")]:
            csv_path = f"Post_hasTag_Tag/{csv_file}"
            print(f"- {csv_path}")
            con.execute(f"COPY {entity} FROM '{dynamic_path}/Post_hasTag_Tag/{csv_file}' (FORMAT 'parquet')")

        for csv_file in [f for f in os.listdir(f"{dynamic_path}/Comment_hasTag_Tag") if f.startswith("part_") and f.endswith(".parquet")]:
            csv_path = f"Comment_hasTag_Tag/{csv_file}"
            print(f"- {csv_path}")
            con.execute(f"COPY {entity} FROM '{dynamic_path}/Comment_hasTag_Tag/{csv_file}' (FORMAT 'parquet')")

    elif entity == "likes":
        for csv_file in [f for f in os.listdir(f"{dynamic_path}/Person_likes_Post") if f.startswith("part_") and f.endswith(".parquet")]:
            csv_path = f"Person_likes_Post/{csv_file}"
            print(f"- {csv_path} here")
            con.execute(f"COPY {entity} FROM '{dynamic_path}/Person_likes_Post/{csv_file}' (FORMAT 'parquet')")

        for csv_file in [f for f in os.listdir(f"{dynamic_path}/Person_likes_Comment") if f.startswith("part_") and f.endswith(".parquet")]:
            csv_path = f"Person_likes_Comment/{csv_file}"
            print(f"- {csv_path}") 
            con.execute(f"COPY {entity} FROM '{dynamic_path}/Person_likes_Comment/{csv_file}' (FORMAT 'parquet')")
    else:
        for csv_file in [f for f in os.listdir(f"{dynamic_path}/{entity}") if f.startswith("part_") and f.endswith(".parquet")]:
            csv_path = f"{entity}/{csv_file}"
            print(f"- {csv_path}")
            con.execute(f"COPY {entity} FROM '{dynamic_path}/{entity}/{csv_file}' (FORMAT 'parquet')")
            if entity == "knows":
                con.execute(f"COPY {entity} (k_creationdate, k_deletiondate, k_explicitlyDeleted, k_person2id, k_person1id) FROM '{dynamic_path}/{entity}/{csv_file}' (FORMAT 'parquet')")
print("Loaded dynamic entities.")






#     for csv_file in [f for f in os.listdir(f"{dynamic_path}/{entity}") if f.startswith("part-") and f.endswith(".csv")]:
#         csv_path = f"{entity}/{csv_file}"
#         print(f"- {csv_path}")
#         #print(f"- {csv_path}", end='\r')
#         cur.execute(f"COPY {entity} FROM '{dbs_data_dir}/initial_snapshot/dynamic/{entity}/{csv_file}' (DELIMITER '|', HEADER, NULL '', FORMAT text)")
#         if entity == "Person_knows_Person":
#             cur.execute(f"COPY {entity} (creationDate, Person2id, Person1id) FROM '{dbs_data_dir}/initial_snapshot/dynamic/{entity}/{csv_file}' (DELIMITER '|', HEADER, NULL '', FORMAT text)")
#         #print(" " * 120, end='\r')
#         pg_con.commit()
# 
# print("Maintain materialized views . . . ")
# run_script(pg_con, cur, "dml/maintain-views.sql")
# print("Done.")
# 
# print("Create static materialized views . . . ")
# run_script(pg_con, cur, "dml/create-static-materialized-views.sql")
# print("Done.")
# 
# print("Apply precomputation . . . ")
# run_script(pg_con, cur, "dml/apply-precomp.sql")
# print("Done.")
# 
# print("Loaded initial snapshot to Umbra.")
# 
