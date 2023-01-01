CREATE TABLE rs_table_15_0 AS SELECT "t3"."ca_zip", "t3"."cs_sales_price"
FROM (SELECT "t1"."cs_sold_date_sk", "t1"."cs_sales_price", "t2"."ca_zip"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_sales_price", "t0"."c_current_addr_sk", "t".">"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_sales_price", "cs_sales_price" > 500 AS ">"
FROM catalog_sales) AS "t"
INNER JOIN (SELECT "c_customer_sk", "c_current_addr_sk"
FROM customer) AS "t0" ON "t"."cs_bill_customer_sk" = "t0"."c_customer_sk") AS "t1"
INNER JOIN (SELECT "ca_address_sk", "ca_zip", SUBSTRING("ca_zip" FROM 1 FOR 5) = '85669' AS "=", SUBSTRING("ca_zip" FROM 1 FOR 5) = '86197' AS "=3", SUBSTRING("ca_zip" FROM 1 FOR 5) = '88274' AS "=4", SUBSTRING("ca_zip" FROM 1 FOR 5) = '83405' AS "=5", SUBSTRING("ca_zip" FROM 1 FOR 5) = '86475' AS "=6", SUBSTRING("ca_zip" FROM 1 FOR 5) = '85392' AS "=7", SUBSTRING("ca_zip" FROM 1 FOR 5) = '85460' AS "=8", SUBSTRING("ca_zip" FROM 1 FOR 5) = '80348' AS "=9", SUBSTRING("ca_zip" FROM 1 FOR 5) = '81792' AS "=10", "ca_state" IN ('CA', 'GA', 'WA') AS "SEARCH"
FROM customer_address) AS "t2" ON "t1"."c_current_addr_sk" = "t2"."ca_address_sk" AND ("t2"."=" OR "t2"."=3" OR ("t2"."=4" OR ("t2"."=5" OR "t2"."=6")) OR ("t2"."=7" OR ("t2"."=8" OR "t2"."=9") OR ("t2"."=10" OR ("t2"."SEARCH" OR "t1".">"))))) AS "t3"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_qoy" = 2 AND "d_year" = 2001) AS "t6" ON "t3"."cs_sold_date_sk" = "t6"."d_date_sk"
;
SELECT "ca_zip", SUM("cs_sales_price")
FROM "rs_table_15_0"
GROUP BY "ca_zip"
ORDER BY "ca_zip" NULLS FIRST
LIMIT 100
;
