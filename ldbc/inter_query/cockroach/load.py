import sys
import os
import time

print("Load initial snapshot")

# initial snapshot
data_path = "/mnt/ldbc/bi-sf300-composite-merged-fk/graphs/csv/bi/composite-merged-fk/initial_snapshot/"
url = "http://localhost:3000"
static_path = f"{data_path}static"
dynamic_path = f"{data_path}dynamic"

static_entities = ["organisation", "place", "tag", "tagclass"]

dynamic_entities = ["comment", "message_tag", "forum", "forum_person",
        "forum_tag", "person", "person_tag", "knows", "likes",
        "person_university", "person_company", "post"]

entity_set = {"static": static_entities, 
             "dynamic": dynamic_entities}

entity_map = {
        "comment": ["Comment"],
        "message_tag": ["Comment_hasTag_Tag", "Post_hasTag_Tag"],
        "forum": ["Forum"],
        "forum_person": ["Forum_hasMember_Person"],
        "forum_tag": ["Forum_hasTag_Tag"],
        "person": ["Person"],
        "person_tag": ["Person_hasInterest_Tag"],
        "knows": ["Person_knows_Person"],
        "likes": ["Person_likes_Post", "Person_likes_Comment"],
        "person_university": ["Person_studyAt_University"],
        "person_company": ["Person_workAt_Company"],
        "post": ["Post"],

        "organisation": ["Organisation"],  
        "place": ["Place"],
        "tag": ["Tag"], 
        "tagclass": ["TagClass"],
}





for key in entity_set:
    entities = entity_set[key]
    for entity in entities:
        fp = open(f"{entity}.sql", 'w')
        for dir_ in entity_map[entity]:
            for csv_file in [f for f in os.listdir(f"{data_path}{key}/{dir_}") if f.startswith("part") and f.endswith(".gz")]:
                csv_path = f"{dir_}/{csv_file}"
                print(f"- {csv_path}")
                print(f"IMPORT INTO {entity} CSV DATA ('{url}/{key}/{dir_}/{csv_file}') WITH delimiter='|', skip='1';", 
                        file = fp)
                if entity == "knows":
                    print(f"IMPORT INTO {entity}(k_creationdate, k_person2id, k_person1id) CSV DATA ('{url}/{key}/{dir_}/{csv_file}') WITH delimiter='|', skip='1';", 
                            file = fp)
        fp.close()



# for entity in static_entities:
#     fp = open(f"{entity}.sql", 'w')
#     for dir_ in entity_map[entity]:
#         for csv_file in [f for f in os.listdir(f"{static_path}/{dir_}") if f.startswith("part") and f.endswith(".gz")]:
# 
#             csv_path = f"{dir_}/{csv_file}"
#             print(f"- {csv_path}")
#             print(f"IMPORT INTO {entity} CSV DATA ('{url}/static/{dir_}/{csv_file}') WITH delimiter='|';", 
#                     file = fp)
#     fp.close()
# print("Loaded static entities.")
# 
# 
# 
# 
# print("## Dynamic entities")
# for entity in dynamic_entities:
#     print(entity)
#     fp = open(f"{entity}.sql", 'w')
#     for dir_ in entity_map[entity]:
#         for csv_file in [f for f in os.listdir(f"{dynamic_path}/{dir_}") if f.startswith("part") and f.endswith(".gz")]:
#             csv_path = f"{dir_}/{csv_file}"
#             print(f"- {csv_path}")
#             print(f"IMPORT INTO {entity} CSV DATA ('{url}/dynamic/{dir_}/{csv_file}') WITH delimiter='|';", 
#                 file = fp)
# 
#             if entity == "knows":
#                 print(f"IMPORT INTO {entity}(k_creationdate, k_person2id, k_person1id) CSV DATA ('{dynamic_path}/{dir_}/{csv_file}') WITH delimiter='|';", 
#                     file = fp)
#     fp.close()
# print("Loaded dynamic entities.")
