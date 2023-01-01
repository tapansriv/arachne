CREATE TABLE rs_table_25_0 AS SELECT "t18"."i_item_id", "t18"."i_item_desc", "t17"."s_store_id", "t17"."s_store_name", "t17"."ss_net_profit", "t17"."sr_net_loss", "t17"."cs_net_profit"
FROM (SELECT "t15"."ss_item_sk", "t15"."ss_net_profit", "t15"."sr_net_loss", "t15"."cs_net_profit", "t16"."s_store_id", "t16"."s_store_name"
FROM (SELECT "t11"."ss_item_sk", "t11"."ss_store_sk", "t11"."ss_net_profit", "t11"."sr_net_loss", "t11"."cs_net_profit"
FROM (SELECT "t7"."ss_item_sk", "t7"."ss_store_sk", "t7"."ss_net_profit", "t7"."sr_net_loss", "t7"."cs_sold_date_sk", "t7"."cs_net_profit"
FROM (SELECT "t3"."ss_item_sk", "t3"."ss_store_sk", "t3"."ss_net_profit", "t3"."sr_returned_date_sk", "t3"."sr_net_loss", "t3"."cs_sold_date_sk", "t3"."cs_net_profit"
FROM (SELECT "t1"."ss_sold_date_sk", "t1"."ss_item_sk", "t1"."ss_store_sk", "t1"."ss_net_profit", "t1"."sr_returned_date_sk", "t1"."sr_net_loss", "t2"."cs_sold_date_sk", "t2"."cs_net_profit"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_item_sk", "t"."ss_store_sk", "t"."ss_net_profit", "t0"."sr_returned_date_sk", "t0"."sr_item_sk", "t0"."sr_customer_sk", "t0"."sr_net_loss"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_customer_sk", "ss_store_sk", "ss_ticket_number", "ss_net_profit"
FROM store_sales) AS "t"
INNER JOIN (SELECT "sr_returned_date_sk", "sr_item_sk", "sr_customer_sk", "sr_ticket_number", "sr_net_loss"
FROM store_returns) AS "t0" ON "t"."ss_customer_sk" = "t0"."sr_customer_sk" AND "t"."ss_item_sk" = "t0"."sr_item_sk" AND "t"."ss_ticket_number" = "t0"."sr_ticket_number") AS "t1"
INNER JOIN (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_item_sk", "cs_net_profit"
FROM catalog_sales) AS "t2" ON "t1"."sr_customer_sk" = "t2"."cs_bill_customer_sk" AND "t1"."sr_item_sk" = "t2"."cs_item_sk") AS "t3"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" = 4 AND "d_year" = 2001) AS "t6" ON "t3"."ss_sold_date_sk" = "t6"."d_date_sk") AS "t7"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" >= 4 AND "d_moy" <= 10 AND "d_year" = 2001) AS "t10" ON "t7"."sr_returned_date_sk" = "t10"."d_date_sk") AS "t11"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" >= 4 AND "d_moy" <= 10 AND "d_year" = 2001) AS "t14" ON "t11"."cs_sold_date_sk" = "t14"."d_date_sk") AS "t15"
INNER JOIN (SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM store) AS "t16" ON "t15"."ss_store_sk" = "t16"."s_store_sk") AS "t17"
INNER JOIN (SELECT "i_item_sk", "i_item_id", "i_item_desc"
FROM item) AS "t18" ON "t17"."ss_item_sk" = "t18"."i_item_sk"
;
SELECT "i_item_id", "i_item_desc", "s_store_id", "s_store_name", SUM("ss_net_profit") AS "store_sales_profit", SUM("sr_net_loss") AS "store_returns_loss", SUM("cs_net_profit") AS "catalog_sales_profit"
FROM "rs_table_25_0"
GROUP BY "i_item_id", "i_item_desc", "s_store_id", "s_store_name"
ORDER BY "i_item_id", "i_item_desc", "s_store_id", "s_store_name"
LIMIT 100
;
