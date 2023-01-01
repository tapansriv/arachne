# Arachne

This is a proof-of-concept prototype middleware which contains a great deal of logic to build execution plans for batch analytical workloads and analytical queries across multiple cloud databases and pricing models. There are modules and scripts to collect profiling information from various databases, such as BigQuery scripts in the `bq_queries` folder which also contains BigQuery compatible SQL for each TPC-DS query. It contains logic to perform the inter-query algorithm in `inter_query_analysis/inter_query.py` and the Java project utilizing Apache Calcite to perform intra-query analysis in `intra_query_analysis`. 

