CREATE TABLE duck_table_49_0 AS SELECT "t4"."cs_item_sk" AS "item", SUM("t4"."CASE") AS "$f1", SUM("t4"."cs_quantity") AS "$f2", SUM("t4"."CASE5") AS "$f3", SUM("t4"."cs_net_paid") AS "$f4"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_item_sk", "t"."cs_quantity", "t"."cs_net_paid", CASE WHEN "t1"."CAST19" IS NOT NULL THEN CAST("t1"."CAST19" AS INTEGER) ELSE 0 END AS "CASE", CASE WHEN "t1"."CAST20" IS NOT NULL THEN CAST("t1"."CAST20" AS DECIMAL(19, 0)) ELSE 0 END AS "CASE5"
FROM (SELECT *
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales
WHERE "cs_net_profit" > 1 AND "cs_net_paid" > 0 AND "cs_quantity" > 0) AS "t"
INNER JOIN (SELECT "cr_item_sk", "cr_order_number", CAST("cr_returned_date_sk" AS INTEGER) AS "CAST", CAST("cr_returned_time_sk" AS INTEGER) AS "CAST3", CAST("cr_item_sk" AS INTEGER) AS "CAST4", CAST("cr_refunded_customer_sk" AS INTEGER) AS "CAST5", CAST("cr_refunded_cdemo_sk" AS INTEGER) AS "CAST6", CAST("cr_refunded_hdemo_sk" AS INTEGER) AS "CAST7", CAST("cr_refunded_addr_sk" AS INTEGER) AS "CAST8", CAST("cr_returning_customer_sk" AS INTEGER) AS "CAST9", CAST("cr_returning_cdemo_sk" AS INTEGER) AS "CAST10", CAST("cr_returning_hdemo_sk" AS INTEGER) AS "CAST11", CAST("cr_returning_addr_sk" AS INTEGER) AS "CAST12", CAST("cr_call_center_sk" AS INTEGER) AS "CAST13", CAST("cr_catalog_page_sk" AS INTEGER) AS "CAST14", CAST("cr_ship_mode_sk" AS INTEGER) AS "CAST15", CAST("cr_warehouse_sk" AS INTEGER) AS "CAST16", CAST("cr_reason_sk" AS INTEGER) AS "CAST17", CAST("cr_order_number" AS INTEGER) AS "CAST18", CAST("cr_return_quantity" AS INTEGER) AS "CAST19", CAST("cr_return_amount" AS DECIMAL(19, 0)) AS "CAST20", CAST("cr_return_tax" AS DECIMAL(19, 0)) AS "CAST21", CAST("cr_return_amt_inc_tax" AS DECIMAL(19, 0)) AS "CAST22", CAST("cr_fee" AS DECIMAL(19, 0)) AS "CAST23", CAST("cr_return_ship_cost" AS DECIMAL(19, 0)) AS "CAST24", CAST("cr_refunded_cash" AS DECIMAL(19, 0)) AS "CAST25", CAST("cr_reversed_charge" AS DECIMAL(19, 0)) AS "CAST26", CAST("cr_store_credit" AS DECIMAL(19, 0)) AS "CAST27", CAST("cr_net_loss" AS DECIMAL(19, 0)) AS "CAST28"
FROM '/mnt/disks/tpcds/parquet/catalog_returns.parquet' AS catalog_returns
WHERE "cr_return_amount" > 10000) AS "t1" ON "t"."cs_order_number" = "t1"."cr_order_number" AND "t"."cs_item_sk" = "t1"."cr_item_sk") AS "t4"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 2001 AND "d_moy" = 12) AS "t7" ON "t4"."cs_sold_date_sk" = "t7"."d_date_sk"
GROUP BY "t4"."cs_item_sk";
SELECT *
FROM (SELECT *
FROM (SELECT 'web' AS "channel", "item", "return_ratio", "return_rank", "currency_rank"
FROM (SELECT "t9"."item", CAST("t9"."$f1" AS DECIMAL(15, 4)) / CAST("t9"."$f2" AS DECIMAL(15, 4)) AS "return_ratio", CAST("t9"."$f3" AS DECIMAL(15, 4)) / CAST("t9"."$f4" AS DECIMAL(15, 4)) AS "currency_ratio", RANK() OVER (ORDER BY CAST("t9"."$f1" AS DECIMAL(15, 4)) / CAST("t9"."$f2" AS DECIMAL(15, 4))) AS "return_rank", RANK() OVER (ORDER BY CAST("t9"."$f3" AS DECIMAL(15, 4)) / CAST("t9"."$f4" AS DECIMAL(15, 4))) AS "currency_rank"
FROM (SELECT "t4"."ws_item_sk" AS "item", SUM("t4"."CASE") AS "$f1", SUM("t4"."ws_quantity") AS "$f2", SUM("t4"."CASE5") AS "$f3", SUM("t4"."ws_net_paid") AS "$f4"
FROM (SELECT "t"."ws_sold_date_sk", "t"."ws_item_sk", "t"."ws_quantity", "t"."ws_net_paid", CASE WHEN "t1"."CAST16" IS NOT NULL THEN CAST("t1"."CAST16" AS INTEGER) ELSE 0 END AS "CASE", CASE WHEN "t1"."CAST17" IS NOT NULL THEN CAST("t1"."CAST17" AS DECIMAL(19, 0)) ELSE 0 END AS "CASE5"
FROM (SELECT *
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales
WHERE "ws_net_profit" > 1 AND "ws_net_paid" > 0 AND "ws_quantity" > 0) AS "t"
INNER JOIN (SELECT "wr_item_sk", "wr_order_number", CAST("wr_returned_date_sk" AS INTEGER) AS "CAST", CAST("wr_returned_time_sk" AS INTEGER) AS "CAST3", CAST("wr_item_sk" AS INTEGER) AS "CAST4", CAST("wr_refunded_customer_sk" AS INTEGER) AS "CAST5", CAST("wr_refunded_cdemo_sk" AS INTEGER) AS "CAST6", CAST("wr_refunded_hdemo_sk" AS INTEGER) AS "CAST7", CAST("wr_refunded_addr_sk" AS INTEGER) AS "CAST8", CAST("wr_returning_customer_sk" AS INTEGER) AS "CAST9", CAST("wr_returning_cdemo_sk" AS INTEGER) AS "CAST10", CAST("wr_returning_hdemo_sk" AS INTEGER) AS "CAST11", CAST("wr_returning_addr_sk" AS INTEGER) AS "CAST12", CAST("wr_web_page_sk" AS INTEGER) AS "CAST13", CAST("wr_reason_sk" AS INTEGER) AS "CAST14", CAST("wr_order_number" AS INTEGER) AS "CAST15", CAST("wr_return_quantity" AS INTEGER) AS "CAST16", CAST("wr_return_amt" AS DECIMAL(19, 0)) AS "CAST17", CAST("wr_return_tax" AS DECIMAL(19, 0)) AS "CAST18", CAST("wr_return_amt_inc_tax" AS DECIMAL(19, 0)) AS "CAST19", CAST("wr_fee" AS DECIMAL(19, 0)) AS "CAST20", CAST("wr_return_ship_cost" AS DECIMAL(19, 0)) AS "CAST21", CAST("wr_refunded_cash" AS DECIMAL(19, 0)) AS "CAST22", CAST("wr_reversed_charge" AS DECIMAL(19, 0)) AS "CAST23", CAST("wr_account_credit" AS DECIMAL(19, 0)) AS "CAST24", CAST("wr_net_loss" AS DECIMAL(19, 0)) AS "CAST25"
FROM '/mnt/disks/tpcds/parquet/web_returns.parquet' AS web_returns
WHERE "wr_return_amt" > 10000) AS "t1" ON "t"."ws_order_number" = "t1"."wr_order_number" AND "t"."ws_item_sk" = "t1"."wr_item_sk") AS "t4"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 2001 AND "d_moy" = 12) AS "t7" ON "t4"."ws_sold_date_sk" = "t7"."d_date_sk"
GROUP BY "t4"."ws_item_sk") AS "t9") AS "t10"
WHERE "return_rank" <= 10 OR "currency_rank" <= 10
UNION
SELECT 'catalog' AS "channel", "item", "return_ratio", "return_rank", "currency_rank"
FROM (SELECT "item", CAST("$f1" AS DECIMAL(15, 4)) / CAST("$f2" AS DECIMAL(15, 4)) AS "return_ratio", CAST("$f3" AS DECIMAL(15, 4)) / CAST("$f4" AS DECIMAL(15, 4)) AS "currency_ratio", RANK() OVER (ORDER BY CAST("$f1" AS DECIMAL(15, 4)) / CAST("$f2" AS DECIMAL(15, 4))) AS "return_rank", RANK() OVER (ORDER BY CAST("$f3" AS DECIMAL(15, 4)) / CAST("$f4" AS DECIMAL(15, 4))) AS "currency_rank"
FROM "duck_table_49_0") AS "t14"
WHERE "return_rank" <= 10 OR "currency_rank" <= 10) AS "t"
UNION
SELECT 'store' AS "channel", "item", "return_ratio", "return_rank", "currency_rank"
FROM (SELECT "t29"."item", CAST("t29"."$f1" AS DECIMAL(15, 4)) / CAST("t29"."$f2" AS DECIMAL(15, 4)) AS "return_ratio", CAST("t29"."$f3" AS DECIMAL(15, 4)) / CAST("t29"."$f4" AS DECIMAL(15, 4)) AS "currency_ratio", RANK() OVER (ORDER BY CAST("t29"."$f1" AS DECIMAL(15, 4)) / CAST("t29"."$f2" AS DECIMAL(15, 4))) AS "return_rank", RANK() OVER (ORDER BY CAST("t29"."$f3" AS DECIMAL(15, 4)) / CAST("t29"."$f4" AS DECIMAL(15, 4))) AS "currency_rank"
FROM (SELECT "t24"."ss_item_sk" AS "item", SUM("t24"."CASE") AS "$f1", SUM("t24"."ss_quantity") AS "$f2", SUM("t24"."CASE5") AS "$f3", SUM("t24"."ss_net_paid") AS "$f4"
FROM (SELECT "t19"."ss_sold_date_sk", "t19"."ss_item_sk", "t19"."ss_quantity", "t19"."ss_net_paid", CASE WHEN "t21"."CAST12" IS NOT NULL THEN CAST("t21"."CAST12" AS INTEGER) ELSE 0 END AS "CASE", CASE WHEN "t21"."CAST13" IS NOT NULL THEN CAST("t21"."CAST13" AS DECIMAL(19, 0)) ELSE 0 END AS "CASE5"
FROM (SELECT *
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales
WHERE "ss_net_profit" > 1 AND "ss_net_paid" > 0 AND "ss_quantity" > 0) AS "t19"
INNER JOIN (SELECT "sr_item_sk", "sr_ticket_number", CAST("sr_returned_date_sk" AS INTEGER) AS "CAST", CAST("sr_return_time_sk" AS INTEGER) AS "CAST3", CAST("sr_item_sk" AS INTEGER) AS "CAST4", CAST("sr_customer_sk" AS INTEGER) AS "CAST5", CAST("sr_cdemo_sk" AS INTEGER) AS "CAST6", CAST("sr_hdemo_sk" AS INTEGER) AS "CAST7", CAST("sr_addr_sk" AS INTEGER) AS "CAST8", CAST("sr_store_sk" AS INTEGER) AS "CAST9", CAST("sr_reason_sk" AS INTEGER) AS "CAST10", CAST("sr_ticket_number" AS INTEGER) AS "CAST11", CAST("sr_return_quantity" AS INTEGER) AS "CAST12", CAST("sr_return_amt" AS DECIMAL(19, 0)) AS "CAST13", CAST("sr_return_tax" AS DECIMAL(19, 0)) AS "CAST14", CAST("sr_return_amt_inc_tax" AS DECIMAL(19, 0)) AS "CAST15", CAST("sr_fee" AS DECIMAL(19, 0)) AS "CAST16", CAST("sr_return_ship_cost" AS DECIMAL(19, 0)) AS "CAST17", CAST("sr_refunded_cash" AS DECIMAL(19, 0)) AS "CAST18", CAST("sr_reversed_charge" AS DECIMAL(19, 0)) AS "CAST19", CAST("sr_store_credit" AS DECIMAL(19, 0)) AS "CAST20", CAST("sr_net_loss" AS DECIMAL(19, 0)) AS "CAST21"
FROM '/mnt/disks/tpcds/parquet/store_returns.parquet' AS store_returns
WHERE "sr_return_amt" > 10000) AS "t21" ON "t19"."ss_ticket_number" = "t21"."sr_ticket_number" AND "t19"."ss_item_sk" = "t21"."sr_item_sk") AS "t24"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 2001 AND "d_moy" = 12) AS "t27" ON "t24"."ss_sold_date_sk" = "t27"."d_date_sk"
GROUP BY "t24"."ss_item_sk") AS "t29") AS "t30"
WHERE "return_rank" <= 10 OR "currency_rank" <= 10) AS "t34"
ORDER BY "channel" NULLS FIRST, "return_rank" NULLS FIRST, "currency_rank" NULLS FIRST, "item" NULLS FIRST
FETCH NEXT 100 ROWS ONLY;
