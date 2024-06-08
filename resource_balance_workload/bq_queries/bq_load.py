import sys
from argparse import ArgumentParser
from google.cloud import bigquery

tpcds_tables = ["call_center", "catalog_page", "catalog_returns", "catalog_sales",
        "customer", "customer_address", "customer_demographics", "date_dim",
        "household_demographics", "income_band", "inventory", "item",
        "promotion", "reason", "ship_mode", "store", "store_returns",
        "store_sales", "time_dim", "warehouse", "web_page", "web_returns",
        "web_sales", "web_site"]

ldbc_tables = ["organisation", "place", "tag", "tagclass", "message",
        "message_tag", "forum", "forum_person", "forum_tag", "person",
        "person_tag", "knows", "likes", "person_university", "person_company"]

tables = {
            "tpcds": tpcds_tables,
            "ldbc":  ldbc_tables,
         }

parser = ArgumentParser(description="Run inter-query analysis")

parser.add_argument("--sample", type=float, choices=[0.15, 0.25, 0.5], help="Sample ratio")
parser.add_argument("--internal", action="store_true", help="Load data internally")
parser.add_argument("--dataset", choices=["ldbc", "tpcds"], help="BQ Dataset to use")
parser.add_argument("bucket", help="Bucket to load from")
args = parser.parse_args()

dataset = "tpcds"
if args.dataset:
    dataset = args.dataset

bucket = args.bucket
if args.sample:
    bucket = f"{args.bucket}/sample_{args.sample}"

client = bigquery.Client()
for tbl in tables[dataset]:
    table_id = f"arachne-multicloud.{dataset}.{tbl}"
    client.delete_table(table_id, not_found_ok=True)  # Make an API request.
    print("Deleted table '{}'.".format(table_id))


# client = bigquery.Client()
for tbl in tables[dataset]:
    if args.internal:
        # Construct a BigQuery client object.
        # client = bigquery.Client()

        table_id = f"arachne-multicloud.{dataset}.{tbl}"

        job_config = bigquery.LoadJobConfig(
            source_format=bigquery.SourceFormat.PARQUET,
        )
        uri = "gs://{bucket}/{tbl}.parquet"
        load_job = client.load_table_from_uri(
            uri, table_id, job_config=job_config
        )  # Make an API request.

        load_job.result()  # Waits for the job to complete.

        destination_table = client.get_table(table_id)
        print("Loaded {} rows.".format(destination_table.num_rows))
    else:
        # Construct a BigQuery client object.
        # client = bigquery.Client()
        # Set table_id to the ID of the table to create.
        table_id = f"arachne-multicloud.{dataset}.{tbl}"
        external_source_format = "PARQUET"

        # Set the source_uris to point to your data in Google Cloud
        source_uris = [
            f"gs://{bucket}/{tbl}.parquet" 
        ]

        # Create ExternalConfig object with external source format
        external_config = bigquery.ExternalConfig(external_source_format)
        # Set source_uris that point to your data in Google Cloud
        external_config.source_uris = source_uris


        table = bigquery.Table(table_id)
        # Set the external data configuration of the table
        table.external_data_configuration = external_config
        table = client.create_table(table)  # Make an API request.

        print(
            f"Created table {table.table_id} with external source format {table.external_data_configuration.source_format}"
        )
