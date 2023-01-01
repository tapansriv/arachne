import re
import os


# lines = ["message_prep", "message,", "message ", "message"]
tables = ["organisation", "place", "tag", "message",
        "message_tag", "forum", "forum_person", "forum_tag", "person",
        "person_tag", "knows", "likes", "person_university", "person_company"]
assert len(tables) == 15

base = "."
files = os.listdir(base)

for f in files:
    if not f.endswith("sql"):
        continue
    lines = open(os.path.join(base, f)).readlines()
    fp = open(f, 'w')
    for l in lines:
        x = l
        find = rf'\"tag\"'
        replace = rf'tag'
        x = re.sub(find, replace, x)

        for tbl in tables:
            find = rf'(?<!ldbc)([^_]){tbl}([^a-zA-Z0-9_.]|$)'
            replace = rf'\1ldbc.{tbl}\2' 
            x = re.sub(find, replace, x)
        fp.write(x)
    fp.close()
