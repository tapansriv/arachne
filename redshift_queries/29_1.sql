CREATE TABLE rs_table_29_0 AS SELECT "t18"."i_item_id", "t18"."i_item_desc", "t17"."s_store_id", "t17"."s_store_name", "t17"."ss_quantity", "t17"."sr_return_quantity", "t17"."cs_quantity"
FROM (SELECT "t15"."ss_item_sk", "t15"."ss_quantity", "t15"."sr_return_quantity", "t15"."cs_quantity", "t16"."s_store_id", "t16"."s_store_name"
FROM (SELECT "t11"."ss_item_sk", "t11"."ss_store_sk", "t11"."ss_quantity", "t11"."sr_return_quantity", "t11"."cs_quantity"
FROM (SELECT "t7"."ss_item_sk", "t7"."ss_store_sk", "t7"."ss_quantity", "t7"."sr_return_quantity", "t7"."cs_sold_date_sk", "t7"."cs_quantity"
FROM (SELECT "t3"."ss_item_sk", "t3"."ss_store_sk", "t3"."ss_quantity", "t3"."sr_returned_date_sk", "t3"."sr_return_quantity", "t3"."cs_sold_date_sk", "t3"."cs_quantity"
FROM (SELECT "t1"."ss_sold_date_sk", "t1"."ss_item_sk", "t1"."ss_store_sk", "t1"."ss_quantity", "t1"."sr_returned_date_sk", "t1"."sr_return_quantity", "t2"."cs_sold_date_sk", "t2"."cs_quantity"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_item_sk", "t"."ss_store_sk", "t"."ss_quantity", "t0"."sr_returned_date_sk", "t0"."sr_item_sk", "t0"."sr_customer_sk", "t0"."sr_return_quantity"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_customer_sk", "ss_store_sk", "ss_ticket_number", "ss_quantity"
FROM store_sales) AS "t"
INNER JOIN (SELECT "sr_returned_date_sk", "sr_item_sk", "sr_customer_sk", "sr_ticket_number", "sr_return_quantity"
FROM store_returns) AS "t0" ON "t"."ss_customer_sk" = "t0"."sr_customer_sk" AND "t"."ss_item_sk" = "t0"."sr_item_sk" AND "t"."ss_ticket_number" = "t0"."sr_ticket_number") AS "t1"
INNER JOIN (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_item_sk", "cs_quantity"
FROM catalog_sales) AS "t2" ON "t1"."sr_customer_sk" = "t2"."cs_bill_customer_sk" AND "t1"."sr_item_sk" = "t2"."cs_item_sk") AS "t3"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" = 9 AND "d_year" = 1999) AS "t6" ON "t3"."ss_sold_date_sk" = "t6"."d_date_sk") AS "t7"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" >= 9 AND "d_moy" <= 9 + 3 AND "d_year" = 1999) AS "t10" ON "t7"."sr_returned_date_sk" = "t10"."d_date_sk") AS "t11"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1999 OR "d_year" = 1999 + 1 OR "d_year" = 1999 + 2) AS "t14" ON "t11"."cs_sold_date_sk" = "t14"."d_date_sk") AS "t15"
INNER JOIN (SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM store) AS "t16" ON "t15"."ss_store_sk" = "t16"."s_store_sk") AS "t17"
INNER JOIN (SELECT "i_item_sk", "i_item_id", "i_item_desc"
FROM item) AS "t18" ON "t17"."ss_item_sk" = "t18"."i_item_sk"
;
SELECT "i_item_id", "i_item_desc", "s_store_id", "s_store_name", SUM("ss_quantity") AS "store_sales_quantity", SUM("sr_return_quantity") AS "store_returns_quantity", SUM("cs_quantity") AS "catalog_sales_quantity"
FROM "rs_table_29_0"
GROUP BY "i_item_id", "i_item_desc", "s_store_id", "s_store_name"
ORDER BY "i_item_id", "i_item_desc", "s_store_id", "s_store_name"
LIMIT 100
;
