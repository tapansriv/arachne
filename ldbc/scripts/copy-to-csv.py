import duckdb
con = duckdb.connect("ldbc-new.db")

entities = ["organisation", "place", "tag", "tagclass", "comment", "message_tag", "forum", "forum_person",
        "forum_tag", "person", "person_tag", "knows", "likes",
        "person_university", "person_company", "post"]
    

for entity in entities:
    print(f"copying {entity}")
    con.execute(f"COPY {entity} TO '{entity}.csv' (DELIMITER ',', HEADER)")

