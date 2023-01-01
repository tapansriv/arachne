tables = ["organisation", "place", "tag", "tagclass", "comment",
        "message_tag", "forum", "forum_person", "forum_tag", "person",
        "person_tag", "knows", "likes", "person_university", "person_company",
        "post"]


for tbl in tables: 
    print(f"SELECT COUNT(*) FROM {tbl};")
