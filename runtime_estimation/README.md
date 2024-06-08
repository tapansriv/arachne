Based on the model proposed in "Predicting Multiple Metrics for Queries: Better Decisions Enabled by Machine Learning". 

The way this works is we construct training samples where labels are runtime and
features are (per Section VI-D) instance count and cardinality sum for each
possible operator. I.e. if there are 2 Sorts with cardinality 45000 and 3000
then we'd have a feature for Sort\_count = 2 and sort\_card = 48000. 

Then for inferences, we use the Gaussian kernel to compute the 3 closest
neighbors and use uniform weights on those 3 neighbors to predict runtime (equal
weight average of the 3).

Training data generated from TPC-DS with RNGSEED 20. Scripts handle deduping
both within the training set and between the original 99 TPC-DS queries and the
1030 generated training queries. This yields 918 unique training queries that do
not overlap with the test set. 



ALL OF THIS ON RS1 ra3.xlplus

train plans is the original set
train plans v2 is the second gen of training queries
these are made from TPCDS templates

then we have TPC-DS test on 100GB
then we have TPC-DS test on 1TB

(TEST is these in W-MIXED)
and now we have RBW on 100GB 


