SELECT AVG("t7"."ss_quantity") AS "avg1", AVG("t7"."ss_ext_sales_price") AS "avg2", AVG("t7"."ss_ext_wholesale_cost") AS "avg3", SUM("t7"."ss_ext_wholesale_cost")
FROM (SELECT "t5"."ss_sold_date_sk", "t5"."ss_quantity", "t5"."ss_ext_sales_price", "t5"."ss_ext_wholesale_cost"
FROM (SELECT "t3"."ss_sold_date_sk", "t3"."ss_addr_sk", "t3"."ss_quantity", "t3"."ss_ext_sales_price", "t3"."ss_ext_wholesale_cost", "t3"."AND" AS "SEARCH", "t3"."AND7" AS "SEARCH6", "t3"."AND8" AS "SEARCH7"
FROM (SELECT "t1"."ss_sold_date_sk", "t1"."ss_hdemo_sk", "t1"."ss_addr_sk", "t1"."ss_quantity", "t1"."ss_ext_sales_price", "t1"."ss_ext_wholesale_cost", "t1"."AND", "t1"."AND8" AS "AND7", "t1"."AND9" AS "AND8", "t2"."cd_demo_sk" = "t1"."ss_cdemo_sk" AS "=", "t2"."=" AS "=10", "t2"."=2" AS "=11", "t1"."AND10" AS "SEARCH", "t2"."=3" AS "=13", "t2"."=4" AS "=14", "t1"."AND11" AS "SEARCH15", "t2"."=5" AS "=16", "t2"."=6" AS "=17", "t1"."AND12" AS "SEARCH18"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_cdemo_sk", "t"."ss_hdemo_sk", "t"."ss_addr_sk", "t"."ss_quantity", "t"."ss_ext_sales_price", "t"."ss_ext_wholesale_cost", "t"."AND", "t"."AND9" AS "AND8", "t"."AND10" AS "AND9", "t"."AND11" AS "AND10", "t"."AND12" AS "AND11", "t"."AND13" AS "AND12"
FROM (SELECT "ss_sold_date_sk", "ss_cdemo_sk", "ss_hdemo_sk", "ss_addr_sk", "ss_store_sk", "ss_quantity", "ss_ext_sales_price", "ss_ext_wholesale_cost", "ss_net_profit" >= 100 AND "ss_net_profit" <= 200 AS "AND", "ss_net_profit" >= 150 AND "ss_net_profit" <= 300 AS "AND9", "ss_net_profit" >= 50 AND "ss_net_profit" <= 250 AS "AND10", "ss_sales_price" >= 100.00 AND "ss_sales_price" <= 150.00 AS "AND11", "ss_sales_price" >= 50.00 AND "ss_sales_price" <= 100.00 AS "AND12", "ss_sales_price" >= 150.00 AND "ss_sales_price" <= 200.00 AS "AND13"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t"
INNER JOIN (SELECT "s_store_sk"
FROM tpcds.sf1000.store AS store) AS "t0" ON "t"."ss_store_sk" = "t0"."s_store_sk") AS "t1",
(SELECT "cd_demo_sk", "cd_marital_status" = 'M' AS "=", "cd_education_status" = 'Advanced Degree' AS "=2", "cd_marital_status" = 'S' AS "=3", "cd_education_status" = 'College' AS "=4", "cd_marital_status" = 'W' AS "=5", "cd_education_status" = '2 yr Degree' AS "=6"
FROM tpcds.sf1000.customer_demographics AS customer_demographics) AS "t2") AS "t3"
INNER JOIN (SELECT "hd_demo_sk", "hd_dep_count" = 3 AS "=", "hd_dep_count" = 1 AS "=2"
FROM tpcds.sf1000.household_demographics AS household_demographics) AS "t4" ON "t3"."ss_hdemo_sk" = "t4"."hd_demo_sk" AND ("t3"."=" AND "t3"."=10") AND ("t3"."=11" AND ("t3"."SEARCH" AND "t4"."=")) OR "t3"."ss_hdemo_sk" = "t4"."hd_demo_sk" AND ("t3"."=" AND "t3"."=13") AND ("t3"."=14" AND ("t3"."SEARCH15" AND "t4"."=2")) OR "t3"."ss_hdemo_sk" = "t4"."hd_demo_sk" AND ("t3"."=" AND "t3"."=16") AND ("t3"."=17" AND ("t3"."SEARCH18" AND "t4"."=2"))) AS "t5"
INNER JOIN (SELECT "ca_address_sk", "ca_country" = 'United States' AS "=", "ca_state" IN ('OH', 'TX') AS "SEARCH", "ca_state" IN ('KY', 'NM', 'OR') AS "SEARCH3", "ca_state" IN ('MS', 'TX', 'VA') AS "SEARCH4"
FROM tpcds.sf1000.customer_address AS customer_address) AS "t6" ON "t5"."ss_addr_sk" = "t6"."ca_address_sk" AND "t6"."=" AND "t6"."SEARCH" AND "t5"."SEARCH" OR "t5"."ss_addr_sk" = "t6"."ca_address_sk" AND "t6"."=" AND "t6"."SEARCH3" AND "t5"."SEARCH6" OR "t5"."ss_addr_sk" = "t6"."ca_address_sk" AND "t6"."=" AND "t6"."SEARCH4" AND "t5"."SEARCH7") AS "t7"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 2001) AS "t10" ON "t7"."ss_sold_date_sk" = "t10"."d_date_sk"

