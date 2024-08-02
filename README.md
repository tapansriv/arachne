# Arachne

This is a proof-of-concept prototype middleware which contains a great deal of logic to build execution plans for batch analytical workloads and analytical queries across multiple cloud databases and pricing models. There are modules and scripts to collect profiling information from various databases, such as BigQuery scripts in the `bq_queries` folder which also contains BigQuery compatible SQL for each TPC-DS query. It contains logic to perform the inter-query algorithm in `inter_query_analysis/inter_query.py` and the Java project utilizing Apache Calcite to perform intra-query analysis in `intra_query_analysis`. 






## Queries and Schema

The different databases used in this evaluation have different SQL syntax requirements, so different SQL versions are needed for the same logical queries. These versions are stored in various folders named to somewhat indicate their intended use. 

The `a_queries` folder stores the original query texts before any modification, or "Arachne" versions of these queries. `bq_queries` and `redshift_queries` have versions of queries compatible with BigQuery and Amazon Redshift respectively. Finally, `p_queries` is written so that instead of scanning internal tables, the queries scan Parquet files. This is compatible with DuckDB's parquet scanner. 

Similarly, schema files are stored in `redshift_schema`. As BigQuery can directly interpret schema information from imported/external Parquet files, there are not equivalent schema for other DBs.

## How to reproduce results

For both inter-query and intra-query results, you need a baseline cost and runtime for each query in your workload in each database being considered. For inter-query, you need to also collect the size of each table after compression to track the actual size that would be migrated (and thus billed for egress). Finally, you need to know what queries scan what tables. In Arachne this is represented by a bit map. The list of tables in a workload are sorted alphabetically, and the least significant bit represents whether the first table alphabetically is scanned by a query, and so on. 

For intra-query you must, in addition to baselines, run the intra-query codebase which will iteratively execute different feasible intra-query cuts on cloud databases, comparing to the baseline costs collected earlier, before returning the cheapest cut or the baseline if no cut found is cheaper than the cheapest baseline.


### Credentials
Credentials to access clouds, such as access key ids, secret keys, usernames, and passwords to access Redshift clusters in AWS, *must* be stored in a file named `config.properties` under the `config` directory. That is where scripts are built to look for credentials. This file has been added to gitignore and should *not* be uploaded to Github or shared. 

### Loading Data
First data must be uploaded to blob storage for the cloud database of interest, i.e. Google Cloud Storage for BigQuery. These scripts unless otherwise listed assume TPC-DS is the set of tables being used by this workload.

The `create_tables.py` script under `bq_queries`, usage described by argparse and in the script, will either create external tables in BigQuery to point to blob storage or will load tables directly. 

Similarly, `load_tpcds.py` under `scripts/redshift` will load data into a Redshift cluster specified by the passed in parameters. The naming convention for Redshift buckets is more rigid, as it requires it to be named in the form `arachne-tpcds-SIZE` where SIZE is an integer representing the size of generated dataset in GB. For example, `arachne-tpcds-1100` for a dataset of 1100GB. 

### Inter-Query Analysis
Once baselines are collected, there are specific naming conventions that must be used. Create a folder for a workload that is profiled. Place BigQuery profiles in `bq_baseline.json`, which is formatted as a JSON file where the top level keys are query names (i.e. '01') and the values are a dict with keys "bytes", and "runtime". Redshift times are put in `rs_baseline.json` and are a simple json file with query names and runtimes in seconds. DuckDB baselines work the same in `duck_baseline.json`. Query dependency bit vectors should be stored in `query_bit_vec.json` and table sizes in `table_sizes.json`. Finally, the runtimes to load each table in, collected when profiling data loading earlier, should be stored in `rs_load_times.json`. Examples can be found in the `inter_query_analysis/parquet_1000` folder. 

Once this folder is created, you can run `python3 inter_query.py` with the various appropriate parameters that are visible via `-h` as well as in source code in the `inter_query_analysis` folder. The `--exclude_table` parameter allows you to iteratively remove each table, producing the DS-DERIVED workloads or running on all TPC-DS tables but using the [Resource-Balance-Workload queries](https://github.com/tapansriv/resource-balance-workloads). 

### Intra-Query Analysis
Once baseline runtimes and bytes scanned are collected, they should be stored in a directory in the arachne top level directory. This directory should be manually entered into the `ArachneQueryProcessor.java` file in `sqlconverter/src/main/java/org/arachne/`. 

Put a list of query names in a file one in each line, omitting the extension (i.e. just have 10, 11, 12 rather than 10.sql). Then from the `run` directory use `launch_rs_file.sh`. This script takes a filename (with the query names in it), a string representing the pay-per-compute database where data is starting in (and where data originates from before it is moved to BigQuery), the cost for this pay-per-byte database, and the cost of egress. 

This will execute the queries via inter-query analysis and provide results indicating the best cuts for each query provided on the data provided, after collecting baselines.  

### Creating Graphs 
For the inter-query scripts in the `inter_query_analysis` repo: the `graph_breakdown` scripts produce the stacked bar charts. The `graph_custom.py` handles the RBW workloads, and `graph_runtime.py` produces the plots that show runtime vs. cost in the paper. The scripts with `what_if` in the title concern some aspect of the what-if analysis, `graph_time_series.py` plots the impact of varying data size on query costs and observes the  impact of stale profiles, and finally `graph_estimation.py` looks at how poorly costs are managed when using noisy runtime estimates. 

### Hermes Transfer Tool
To use the transfer tool in the `hermes` directory, enter that directory and install the package via `python3 -m pip install .` This will then make `hermes` callable from command line, and usage to be seen via `$ hermes -h`. Functionality is quite limited on this tool as it can handle recursively copying files from one cloud to another and cleaning up directories by deleting files within them. With hermes, you first indicate what command (`cp` or `clean`) before writing the list of source objects and the destination bucket for them, along with a recursive flag. 
                      




                      