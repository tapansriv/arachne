import duckdb
import sys

sf = sys.argv[1]
con = duckdb.connect(f"ldbc-sf{sf}.db")

tables = ["organisation", "place", "tag", "tagclass", "comment",
        "message_tag", "forum", "forum_person", "forum_tag", "person",
        "person_tag", "knows", "likes", "person_university", "person_company",
        "post"]

for tbl in tables:
    qry = f"COPY {tbl} TO 'parquet_{sf}/{tbl}.parquet' (FORMAT 'parquet')"
    con.execute(qry)
