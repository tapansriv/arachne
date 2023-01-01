CREATE TABLE rs_table_60_0 AS SELECT "item"."i_item_sk", "item"."i_item_id"
FROM item
INNER JOIN (SELECT "i_item_id"
FROM item
WHERE "i_category" = 'Music'
GROUP BY "i_item_id") AS "t2" ON "item"."i_item_id" = "t2"."i_item_id"
;
CREATE TABLE rs_table_60_1 AS SELECT *
FROM (SELECT "rs_table_60_0"."i_item_id", SUM("t7"."ss_ext_sales_price") AS "total_sales"
FROM (SELECT "t3"."ss_item_sk", "t3"."ss_ext_sales_price"
FROM (SELECT "t"."ss_item_sk", "t"."ss_addr_sk", "t"."ss_ext_sales_price"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_addr_sk", "ss_ext_sales_price"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1998 AND "d_moy" = 9) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_gmt_offset" = -5) AS "t6" ON "t3"."ss_addr_sk" = "t6"."ca_address_sk") AS "t7"
INNER JOIN "rs_table_60_0" ON "t7"."ss_item_sk" = "rs_table_60_0"."i_item_sk"
GROUP BY "rs_table_60_0"."i_item_id"
UNION ALL
SELECT "rs_table_60_00"."i_item_id", SUM("t19"."cs_ext_sales_price") AS "total_sales"
FROM (SELECT "t15"."cs_item_sk", "t15"."cs_ext_sales_price"
FROM (SELECT "t11"."cs_bill_addr_sk", "t11"."cs_item_sk", "t11"."cs_ext_sales_price"
FROM (SELECT "cs_sold_date_sk", "cs_bill_addr_sk", "cs_item_sk", "cs_ext_sales_price"
FROM catalog_sales) AS "t11"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1998 AND "d_moy" = 9) AS "t14" ON "t11"."cs_sold_date_sk" = "t14"."d_date_sk") AS "t15"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_gmt_offset" = -5) AS "t18" ON "t15"."cs_bill_addr_sk" = "t18"."ca_address_sk") AS "t19"
INNER JOIN "rs_table_60_0" AS "rs_table_60_00" ON "t19"."cs_item_sk" = "rs_table_60_00"."i_item_sk"
GROUP BY "rs_table_60_00"."i_item_id")
UNION ALL
SELECT "rs_table_60_01"."i_item_id", SUM("t32"."ws_ext_sales_price") AS "total_sales"
FROM (SELECT "t28"."ws_item_sk", "t28"."ws_ext_sales_price"
FROM (SELECT "t24"."ws_item_sk", "t24"."ws_bill_addr_sk", "t24"."ws_ext_sales_price"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_bill_addr_sk", "ws_ext_sales_price"
FROM web_sales) AS "t24"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1998 AND "d_moy" = 9) AS "t27" ON "t24"."ws_sold_date_sk" = "t27"."d_date_sk") AS "t28"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_gmt_offset" = -5) AS "t31" ON "t28"."ws_bill_addr_sk" = "t31"."ca_address_sk") AS "t32"
INNER JOIN "rs_table_60_0" AS "rs_table_60_01" ON "t32"."ws_item_sk" = "rs_table_60_01"."i_item_sk"
GROUP BY "rs_table_60_01"."i_item_id"
;
SELECT "i_item_id", SUM("total_sales") AS "total_sales1"
FROM "rs_table_60_1"
GROUP BY "i_item_id"
ORDER BY "i_item_id", SUM("total_sales")
LIMIT 100
;
