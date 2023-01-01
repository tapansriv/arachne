CREATE TABLE rs_table_08_0 AS SELECT "t"."ss_store_sk", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_net_profit"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_qoy" = 2 AND "d_year" = 1998) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk"
;
SELECT "t0"."s_store_name", SUM("t0"."ss_net_profit")
FROM (SELECT "rs_table_08_0"."ss_net_profit", "t"."s_store_name", "t"."SUBSTRING"
FROM "rs_table_08_0"
INNER JOIN (SELECT "s_store_sk", "s_store_name", SUBSTRING("s_zip" FROM 1 FOR 2) AS "SUBSTRING"
FROM store) AS "t" ON "rs_table_08_0"."ss_store_sk" = "t"."s_store_sk") AS "t0"
INNER JOIN (SELECT SUBSTRING("ca_zip" FROM 1 FOR 2) AS "SUBSTRING"
FROM (SELECT SUBSTRING("ca_zip" FROM 1 FOR 5) AS "ca_zip"
FROM customer_address
INTERSECT
SELECT SUBSTRING("t4"."ca_zip" FROM 1 FOR 5) AS "ca_zip"
FROM (SELECT "ca_address_sk", "ca_zip"
FROM customer_address) AS "t4"
INNER JOIN (SELECT "c_current_addr_sk"
FROM customer
WHERE "c_preferred_cust_flag" = 'Y') AS "t7" ON "t4"."ca_address_sk" = "t7"."c_current_addr_sk"
GROUP BY "t4"."ca_zip"
HAVING COUNT(*) > 10) AS "t12") AS "t14" ON "t0"."SUBSTRING" = "t14"."SUBSTRING"
GROUP BY "t0"."s_store_name"
ORDER BY "t0"."s_store_name"
LIMIT 100
;
