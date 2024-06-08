This is a java subproject managed by maven that handles SQL conversion. This repo may change to entirely use java, but for the short term this includes the current work (although messy) under version control together with prior versions of Arachne.

To compile, run `mvn compile` from this directory. You must provide 5 command line arguments. First, indicate whether you're running a single test ("singe"), all ("all"), or "range". The next argument is what the source system is, right now "duck" for DuckDB and "rs" for Amazon Redshift are supported. 

If "single", the third argument is the query number being run (you should put it in 1 instead of 01). The fourth argument is the cost/hour of that source environment, and the fifth argument is the cost per GB of movement from source to BigQuery.

If "all", the above hold except you don't provide an argument for query number.  The 3rd and 4th arguments are runtime and movement cost with no 5th arg.

For "range" your 3rd and 4th arguments are the range of queries being attempted.  It will be inclusive start exclusive end (i.e. range 1 10 runs queries 1 through 9, excluding 10). The 5th and 6th arguments are runtime and movement costs respectively.  

To run, use, for example, `mvn exec:java -Dexec.mainClass=org.arachne.ArachneQueryProcessor -Dexec.args="single duck 59 1.48 0"`.
To run, use, for example, `mvn exec:java -Dexec.mainClass=org.arachne.ArachneQueryProcessor -Dexec.args="single rs 21 1.008 0.09"`.

These examples show running single queries. The first is based in DuckDB with a runtime cost of \$1.48/hr and \$0/GB to move because its within the same cloud as BQ. The second runs single query based in redshift, query 21, with a \$1.008/hr runtime cost and a \$0.09/GB to move from S3 to Google Cloud Storage.

