CREATE TABLE rs_table_31_0 AS SELECT "t2"."ca_county", "t1"."d_qoy", "t1"."d_year", SUM("t1"."ss_ext_sales_price") AS "store_sales"
FROM (SELECT "t"."ss_addr_sk", "t"."ss_ext_sales_price", "t0"."d_year", "t0"."d_qoy"
FROM (SELECT "ss_sold_date_sk", "ss_addr_sk", "ss_ext_sales_price"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_qoy"
FROM date_dim) AS "t0" ON "t"."ss_sold_date_sk" = "t0"."d_date_sk") AS "t1"
INNER JOIN (SELECT "ca_address_sk", "ca_county"
FROM customer_address) AS "t2" ON "t1"."ss_addr_sk" = "t2"."ca_address_sk"
GROUP BY "t2"."ca_county", "t1"."d_qoy", "t1"."d_year"
;
CREATE TABLE rs_table_31_1 AS SELECT "t2"."ca_county", "t1"."d_qoy", "t1"."d_year", SUM("t1"."ws_ext_sales_price") AS "web_sales"
FROM (SELECT "t"."ws_bill_addr_sk", "t"."ws_ext_sales_price", "t0"."d_year", "t0"."d_qoy"
FROM (SELECT "ws_sold_date_sk", "ws_bill_addr_sk", "ws_ext_sales_price"
FROM web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_qoy"
FROM date_dim) AS "t0" ON "t"."ws_sold_date_sk" = "t0"."d_date_sk") AS "t1"
INNER JOIN (SELECT "ca_address_sk", "ca_county"
FROM customer_address) AS "t2" ON "t1"."ws_bill_addr_sk" = "t2"."ca_address_sk"
GROUP BY "t2"."ca_county", "t1"."d_qoy", "t1"."d_year"
;
CREATE TABLE rs_table_31_2 AS SELECT "t9"."ca_county", "t9"."d_year", "t9"."ca_county2", "t11"."web_sales" AS "web_sales0", "t11"."""*""" / "t9"."web_sales" AS "/", "t9"."/" AS "/5", "t9"."/5" AS "/6", "t11".">", "t9"."CASE"
FROM (SELECT "t6"."ca_county", "t6"."d_year", "t8"."ca_county" AS "ca_county2", "t8"."web_sales", "t6"."/", "t6"."/3" AS "/5", "t6"."CASE", "t8".">", "t6"."CASE5" AS "CASE8"
FROM (SELECT "t3"."ca_county", "t3"."d_year", "t3"."/", "t5"."""*""" / "t3"."store_sales0" AS "/3", CASE WHEN "t3".">" THEN "t5"."""*""" / "t3"."store_sales0" ELSE NULL END AS "CASE", "t3"."CASE" AS "CASE5"
FROM (SELECT "t0"."ca_county", "t0"."d_year", "t2"."ca_county" AS "ca_county0", "t2"."store_sales" AS "store_sales0", "t2"."""*""" / "t0"."store_sales" AS "/", "t2".">", CASE WHEN "t0".">" THEN "t2"."""*""" / "t0"."store_sales" ELSE NULL END AS "CASE"
FROM (SELECT "ca_county", "d_year", "store_sales", "store_sales" > 0 AS ">"
FROM "rs_table_31_0"
WHERE "d_qoy" = 1 AND "d_year" = 2000) AS "t0"
INNER JOIN (SELECT "ca_county", "store_sales", "store_sales" * 1.0000 AS """*""", "store_sales" > 0 AS ">"
FROM "rs_table_31_0"
WHERE "d_qoy" = 2 AND "d_year" = 2000) AS "t2" ON "t0"."ca_county" = "t2"."ca_county") AS "t3"
INNER JOIN (SELECT "ca_county", "store_sales" * 1.0000 AS """*"""
FROM "rs_table_31_0"
WHERE "d_qoy" = 3 AND "d_year" = 2000) AS "t5" ON "t3"."ca_county0" = "t5"."ca_county") AS "t6"
INNER JOIN (SELECT "ca_county", "web_sales", "web_sales" > 0 AS ">"
FROM "rs_table_31_1"
WHERE "d_qoy" = 1 AND "d_year" = 2000) AS "t8" ON "t6"."ca_county" = "t8"."ca_county") AS "t9"
INNER JOIN (SELECT "ca_county", "web_sales", "web_sales" * 1.0000 AS """*""", "web_sales" > 0 AS ">"
FROM "rs_table_31_1"
WHERE "d_qoy" = 2 AND "d_year" = 2000) AS "t11" ON "t9"."ca_county2" = "t11"."ca_county" AND CASE WHEN "t9".">" THEN "t11"."""*""" / "t9"."web_sales" ELSE NULL END > "t9"."CASE8"
;
SELECT "rs_table_31_2"."ca_county", "rs_table_31_2"."d_year", "rs_table_31_2"."/" AS "web_q1_q2_increase", "rs_table_31_2"."/5" AS "store_q1_q2_increase", "t6"."""*""" / "rs_table_31_2"."web_sales0" AS "web_q2_q3_increase", "rs_table_31_2"."/6" AS "store_q2_q3_increase"
FROM "rs_table_31_2"
INNER JOIN (SELECT "t2"."ca_county", SUM("t1"."ws_ext_sales_price") * 1.0000 AS """*"""
FROM (SELECT "t"."ws_bill_addr_sk", "t"."ws_ext_sales_price", "t0"."d_year", "t0"."d_qoy"
FROM (SELECT "ws_sold_date_sk", "ws_bill_addr_sk", "ws_ext_sales_price"
FROM web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_qoy"
FROM date_dim) AS "t0" ON "t"."ws_sold_date_sk" = "t0"."d_date_sk") AS "t1"
INNER JOIN (SELECT "ca_address_sk", "ca_county"
FROM customer_address) AS "t2" ON "t1"."ws_bill_addr_sk" = "t2"."ca_address_sk"
GROUP BY "t2"."ca_county", "t1"."d_qoy", "t1"."d_year"
HAVING "t1"."d_qoy" = 3 AND "t1"."d_year" = 2000) AS "t6" ON "rs_table_31_2"."ca_county2" = "t6"."ca_county" AND CASE WHEN "rs_table_31_2".">" THEN CAST("t6"."""*""" / "rs_table_31_2"."web_sales0" AS DECIMAL(19, 4)) ELSE NULL END > "rs_table_31_2"."CASE"
ORDER BY "rs_table_31_2"."ca_county"
;
