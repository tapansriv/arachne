SELECT "t5"."s_store_name", SUM("t5"."ss_net_profit")
FROM (SELECT "t3"."ss_net_profit", "t4"."s_store_name", "t4"."SUBSTRING"
FROM (SELECT "t"."ss_store_sk", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_net_profit"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_qoy" = 2 AND "d_year" = 1998) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "s_store_sk", "s_store_name", SUBSTRING("s_zip" FROM 1 FOR 2) AS "SUBSTRING"
FROM store) AS "t4" ON "t3"."ss_store_sk" = "t4"."s_store_sk") AS "t5"
INNER JOIN (SELECT SUBSTRING("ca_zip" FROM 1 FOR 2) AS "SUBSTRING"
FROM (SELECT SUBSTRING("ca_zip" FROM 1 FOR 5) AS "ca_zip"
FROM customer_address
INTERSECT
SELECT SUBSTRING("t9"."ca_zip" FROM 1 FOR 5) AS "ca_zip"
FROM (SELECT "ca_address_sk", "ca_zip"
FROM customer_address) AS "t9"
INNER JOIN (SELECT "c_current_addr_sk"
FROM customer
WHERE "c_preferred_cust_flag" = 'Y') AS "t12" ON "t9"."ca_address_sk" = "t12"."c_current_addr_sk"
GROUP BY "t9"."ca_zip"
HAVING COUNT(*) > 10) AS "t17") AS "t19" ON "t5"."SUBSTRING" = "t19"."SUBSTRING"
GROUP BY "t5"."s_store_name"
ORDER BY "t5"."s_store_name"
FETCH NEXT 100 ROWS ONLY

