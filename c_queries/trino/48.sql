SELECT SUM("t5"."ss_quantity")
FROM (SELECT "t3"."ss_sold_date_sk", "t3"."ss_quantity"
FROM (SELECT "t1"."ss_sold_date_sk", "t1"."ss_addr_sk", "t1"."ss_quantity", "t1"."AND" AS "SEARCH", "t1"."AND5" AS "SEARCH4", "t1"."AND6" AS "SEARCH5"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_cdemo_sk", "t"."ss_addr_sk", "t"."ss_quantity", "t"."AND", "t"."AND6" AS "AND5", "t"."AND7" AS "AND6", "t"."AND8" AS "SEARCH", "t"."AND9" AS "SEARCH8", "t"."AND10" AS "SEARCH9"
FROM (SELECT "ss_sold_date_sk", "ss_cdemo_sk", "ss_addr_sk", "ss_store_sk", "ss_quantity", "ss_net_profit" >= 0 AND "ss_net_profit" <= 2000 AS "AND", "ss_net_profit" >= 150 AND "ss_net_profit" <= 3000 AS "AND6", "ss_net_profit" >= 50 AND "ss_net_profit" <= 25000 AS "AND7", "ss_sales_price" >= 100.00 AND "ss_sales_price" <= 150.00 AS "AND8", "ss_sales_price" >= 50.00 AND "ss_sales_price" <= 100.00 AS "AND9", "ss_sales_price" >= 150.00 AND "ss_sales_price" <= 200.00 AS "AND10"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t"
INNER JOIN (SELECT "s_store_sk"
FROM tpcds.sf1000.store AS store) AS "t0" ON "t"."ss_store_sk" = "t0"."s_store_sk") AS "t1"
INNER JOIN (SELECT "cd_demo_sk", "cd_marital_status" = 'M' AS "=", "cd_education_status" = '4 yr Degree' AS "=2", "cd_marital_status" = 'D' AS "=3", "cd_education_status" = '2 yr Degree' AS "=4", "cd_marital_status" = 'S' AS "=5", "cd_education_status" = 'College' AS "=6"
FROM tpcds.sf1000.customer_demographics AS customer_demographics) AS "t2" ON "t1"."ss_cdemo_sk" = "t2"."cd_demo_sk" AND "t2"."=" AND "t2"."=2" AND "t1"."SEARCH" OR "t1"."ss_cdemo_sk" = "t2"."cd_demo_sk" AND "t2"."=3" AND "t2"."=4" AND "t1"."SEARCH8" OR "t1"."ss_cdemo_sk" = "t2"."cd_demo_sk" AND "t2"."=5" AND "t2"."=6" AND "t1"."SEARCH9") AS "t3"
INNER JOIN (SELECT "ca_address_sk", "ca_country" = 'United States' AS "=", "ca_state" IN ('CO', 'OH', 'TX') AS "SEARCH", "ca_state" IN ('KY', 'MN', 'OR') AS "SEARCH3", "ca_state" IN ('CA', 'MS', 'VA') AS "SEARCH4"
FROM tpcds.sf1000.customer_address AS customer_address) AS "t4" ON "t3"."ss_addr_sk" = "t4"."ca_address_sk" AND "t4"."=" AND "t4"."SEARCH" AND "t3"."SEARCH" OR "t3"."ss_addr_sk" = "t4"."ca_address_sk" AND "t4"."=" AND "t4"."SEARCH3" AND "t3"."SEARCH4" OR "t3"."ss_addr_sk" = "t4"."ca_address_sk" AND "t4"."=" AND "t4"."SEARCH4" AND "t3"."SEARCH5") AS "t5"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 2000) AS "t8" ON "t5"."ss_sold_date_sk" = "t8"."d_date_sk"

