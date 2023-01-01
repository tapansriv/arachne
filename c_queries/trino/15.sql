SELECT "t3"."ca_zip", SUM("t3"."cs_sales_price")
FROM (SELECT "t1"."cs_sold_date_sk", "t1"."cs_sales_price", "t2"."ca_zip"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_sales_price", "t0"."c_current_addr_sk", "t".">"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_sales_price", "cs_sales_price" > 500 AS ">"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t"
INNER JOIN (SELECT "c_customer_sk", "c_current_addr_sk"
FROM tpcds.sf1000.customer AS customer) AS "t0" ON "t"."cs_bill_customer_sk" = "t0"."c_customer_sk") AS "t1"
INNER JOIN (SELECT "ca_address_sk", "ca_zip", SUBSTR("ca_zip", 1, 5) = '85669' AS "=", SUBSTR("ca_zip", 1, 5) = '86197' AS "=3", SUBSTR("ca_zip", 1, 5) = '88274' AS "=4", SUBSTR("ca_zip", 1, 5) = '83405' AS "=5", SUBSTR("ca_zip", 1, 5) = '86475' AS "=6", SUBSTR("ca_zip", 1, 5) = '85392' AS "=7", SUBSTR("ca_zip", 1, 5) = '85460' AS "=8", SUBSTR("ca_zip", 1, 5) = '80348' AS "=9", SUBSTR("ca_zip", 1, 5) = '81792' AS "=10", "ca_state" IN ('CA', 'GA', 'WA') AS "SEARCH"
FROM tpcds.sf1000.customer_address AS customer_address) AS "t2" ON "t1"."c_current_addr_sk" = "t2"."ca_address_sk" AND ("t2"."=" OR "t2"."=3" OR ("t2"."=4" OR ("t2"."=5" OR "t2"."=6")) OR ("t2"."=7" OR ("t2"."=8" OR "t2"."=9") OR ("t2"."=10" OR ("t2"."SEARCH" OR "t1".">"))))) AS "t3"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_qoy" = 2 AND "d_year" = 2001) AS "t6" ON "t3"."cs_sold_date_sk" = "t6"."d_date_sk"
GROUP BY "t3"."ca_zip"
ORDER BY "t3"."ca_zip"
LIMIT 100

