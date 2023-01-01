import sys
'''
CREATE OR REPLACE EXTERNAL TABLE tpcds.catalog_sales
OPTIONS (
    format = 'PARQUET',
    uris = ['gs://arachne_tpcds_2tb/catalog_sales/catalog_sales.parquet']
);
'''
sf = sys.argv[1]
tables = ["organisation", "place", "tag", "tagclass", "comment", "message",
        "message_tag", "forum", "forum_person", "forum_tag", "person",
        "person_tag", "knows", "likes", "person_university", "person_company",
        "post"]

for tbl in tables:
    print(f"CREATE OR REPLACE EXTERNAL TABLE ldbc.{tbl}")
    print("OPTIONS (")
    print(f"    format = 'PARQUET',")
    print(f"    uris = ['gs://ldbc/parquet_{sf}/{tbl}.parquet']")
    print(");")
