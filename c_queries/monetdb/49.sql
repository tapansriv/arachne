SELECT *
FROM (SELECT *
FROM (SELECT 'web' AS "channel", "item", "return_ratio", "return_rank", "currency_rank"
FROM (SELECT "t9"."item", CAST("t9"."$f1" AS DECIMAL(15, 4)) / CAST("t9"."$f2" AS DECIMAL(15, 4)) AS "return_ratio", CAST("t9"."$f3" AS DECIMAL(15, 4)) / CAST("t9"."$f4" AS DECIMAL(15, 4)) AS "currency_ratio", RANK() OVER (ORDER BY CAST("t9"."$f1" AS DECIMAL(15, 4)) / CAST("t9"."$f2" AS DECIMAL(15, 4)) IS NULL, CAST("t9"."$f1" AS DECIMAL(15, 4)) / CAST("t9"."$f2" AS DECIMAL(15, 4))) AS "return_rank", RANK() OVER (ORDER BY CAST("t9"."$f3" AS DECIMAL(15, 4)) / CAST("t9"."$f4" AS DECIMAL(15, 4)) IS NULL, CAST("t9"."$f3" AS DECIMAL(15, 4)) / CAST("t9"."$f4" AS DECIMAL(15, 4))) AS "currency_rank"
FROM (SELECT "t4"."ws_item_sk" AS "item", SUM("t4"."CASE") AS "$f1", SUM("t4"."ws_quantity") AS "$f2", SUM("t4"."CASE5") AS "$f3", SUM("t4"."ws_net_paid") AS "$f4"
FROM (SELECT "t0"."ws_sold_date_sk", "t0"."ws_item_sk", "t0"."ws_quantity", "t0"."ws_net_paid", CASE WHEN "t2"."CAST16" IS NOT NULL THEN CAST("t2"."CAST16" AS SIGNED) ELSE 0 END AS "CASE", CASE WHEN "t2"."CAST17" IS NOT NULL THEN CAST("t2"."CAST17" AS DECIMAL(19, 0)) ELSE 0 END AS "CASE5"
FROM (SELECT *
FROM web_sales
WHERE "ws_net_profit" > 1 AND "ws_net_paid" > 0 AND "ws_quantity" > 0) AS "t0"
INNER JOIN (SELECT "wr_item_sk", "wr_order_number", CAST("wr_returned_date_sk" AS SIGNED) AS "CAST", CAST("wr_returned_time_sk" AS SIGNED) AS "CAST3", CAST("wr_item_sk" AS SIGNED) AS "CAST4", CAST("wr_refunded_customer_sk" AS SIGNED) AS "CAST5", CAST("wr_refunded_cdemo_sk" AS SIGNED) AS "CAST6", CAST("wr_refunded_hdemo_sk" AS SIGNED) AS "CAST7", CAST("wr_refunded_addr_sk" AS SIGNED) AS "CAST8", CAST("wr_returning_customer_sk" AS SIGNED) AS "CAST9", CAST("wr_returning_cdemo_sk" AS SIGNED) AS "CAST10", CAST("wr_returning_hdemo_sk" AS SIGNED) AS "CAST11", CAST("wr_returning_addr_sk" AS SIGNED) AS "CAST12", CAST("wr_web_page_sk" AS SIGNED) AS "CAST13", CAST("wr_reason_sk" AS SIGNED) AS "CAST14", CAST("wr_order_number" AS SIGNED) AS "CAST15", CAST("wr_return_quantity" AS SIGNED) AS "CAST16", CAST("wr_return_amt" AS DECIMAL(19, 0)) AS "CAST17", CAST("wr_return_tax" AS DECIMAL(19, 0)) AS "CAST18", CAST("wr_return_amt_inc_tax" AS DECIMAL(19, 0)) AS "CAST19", CAST("wr_fee" AS DECIMAL(19, 0)) AS "CAST20", CAST("wr_return_ship_cost" AS DECIMAL(19, 0)) AS "CAST21", CAST("wr_refunded_cash" AS DECIMAL(19, 0)) AS "CAST22", CAST("wr_reversed_charge" AS DECIMAL(19, 0)) AS "CAST23", CAST("wr_account_credit" AS DECIMAL(19, 0)) AS "CAST24", CAST("wr_net_loss" AS DECIMAL(19, 0)) AS "CAST25"
FROM web_returns
WHERE "wr_return_amt" > 10000) AS "t2" ON "t0"."ws_order_number" = "t2"."wr_order_number" AND "t0"."ws_item_sk" = "t2"."wr_item_sk") AS "t4"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2001 AND "d_moy" = 12) AS "t7" ON "t4"."ws_sold_date_sk" = "t7"."d_date_sk"
GROUP BY "t4"."ws_item_sk") AS "t9") AS "t10"
WHERE "return_rank" <= 10 OR "currency_rank" <= 10
UNION
SELECT 'catalog' AS "channel", "item", "return_ratio", "return_rank", "currency_rank"
FROM (SELECT "t24"."item", CAST("t24"."$f1" AS DECIMAL(15, 4)) / CAST("t24"."$f2" AS DECIMAL(15, 4)) AS "return_ratio", CAST("t24"."$f3" AS DECIMAL(15, 4)) / CAST("t24"."$f4" AS DECIMAL(15, 4)) AS "currency_ratio", RANK() OVER (ORDER BY CAST("t24"."$f1" AS DECIMAL(15, 4)) / CAST("t24"."$f2" AS DECIMAL(15, 4)) IS NULL, CAST("t24"."$f1" AS DECIMAL(15, 4)) / CAST("t24"."$f2" AS DECIMAL(15, 4))) AS "return_rank", RANK() OVER (ORDER BY CAST("t24"."$f3" AS DECIMAL(15, 4)) / CAST("t24"."$f4" AS DECIMAL(15, 4)) IS NULL, CAST("t24"."$f3" AS DECIMAL(15, 4)) / CAST("t24"."$f4" AS DECIMAL(15, 4))) AS "currency_rank"
FROM (SELECT "t19"."cs_item_sk" AS "item", SUM("t19"."CASE") AS "$f1", SUM("t19"."cs_quantity") AS "$f2", SUM("t19"."CASE5") AS "$f3", SUM("t19"."cs_net_paid") AS "$f4"
FROM (SELECT "t15"."cs_sold_date_sk", "t15"."cs_item_sk", "t15"."cs_quantity", "t15"."cs_net_paid", CASE WHEN "t17"."CAST19" IS NOT NULL THEN CAST("t17"."CAST19" AS SIGNED) ELSE 0 END AS "CASE", CASE WHEN "t17"."CAST20" IS NOT NULL THEN CAST("t17"."CAST20" AS DECIMAL(19, 0)) ELSE 0 END AS "CASE5"
FROM (SELECT *
FROM catalog_sales
WHERE "cs_net_profit" > 1 AND "cs_net_paid" > 0 AND "cs_quantity" > 0) AS "t15"
INNER JOIN (SELECT "cr_item_sk", "cr_order_number", CAST("cr_returned_date_sk" AS SIGNED) AS "CAST", CAST("cr_returned_time_sk" AS SIGNED) AS "CAST3", CAST("cr_item_sk" AS SIGNED) AS "CAST4", CAST("cr_refunded_customer_sk" AS SIGNED) AS "CAST5", CAST("cr_refunded_cdemo_sk" AS SIGNED) AS "CAST6", CAST("cr_refunded_hdemo_sk" AS SIGNED) AS "CAST7", CAST("cr_refunded_addr_sk" AS SIGNED) AS "CAST8", CAST("cr_returning_customer_sk" AS SIGNED) AS "CAST9", CAST("cr_returning_cdemo_sk" AS SIGNED) AS "CAST10", CAST("cr_returning_hdemo_sk" AS SIGNED) AS "CAST11", CAST("cr_returning_addr_sk" AS SIGNED) AS "CAST12", CAST("cr_call_center_sk" AS SIGNED) AS "CAST13", CAST("cr_catalog_page_sk" AS SIGNED) AS "CAST14", CAST("cr_ship_mode_sk" AS SIGNED) AS "CAST15", CAST("cr_warehouse_sk" AS SIGNED) AS "CAST16", CAST("cr_reason_sk" AS SIGNED) AS "CAST17", CAST("cr_order_number" AS SIGNED) AS "CAST18", CAST("cr_return_quantity" AS SIGNED) AS "CAST19", CAST("cr_return_amount" AS DECIMAL(19, 0)) AS "CAST20", CAST("cr_return_tax" AS DECIMAL(19, 0)) AS "CAST21", CAST("cr_return_amt_inc_tax" AS DECIMAL(19, 0)) AS "CAST22", CAST("cr_fee" AS DECIMAL(19, 0)) AS "CAST23", CAST("cr_return_ship_cost" AS DECIMAL(19, 0)) AS "CAST24", CAST("cr_refunded_cash" AS DECIMAL(19, 0)) AS "CAST25", CAST("cr_reversed_charge" AS DECIMAL(19, 0)) AS "CAST26", CAST("cr_store_credit" AS DECIMAL(19, 0)) AS "CAST27", CAST("cr_net_loss" AS DECIMAL(19, 0)) AS "CAST28"
FROM catalog_returns
WHERE "cr_return_amount" > 10000) AS "t17" ON "t15"."cs_order_number" = "t17"."cr_order_number" AND "t15"."cs_item_sk" = "t17"."cr_item_sk") AS "t19"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2001 AND "d_moy" = 12) AS "t22" ON "t19"."cs_sold_date_sk" = "t22"."d_date_sk"
GROUP BY "t19"."cs_item_sk") AS "t24") AS "t25"
WHERE "return_rank" <= 10 OR "currency_rank" <= 10) AS "t"
UNION
SELECT 'store' AS "channel", "item", "return_ratio", "return_rank", "currency_rank"
FROM (SELECT "t40"."item", CAST("t40"."$f1" AS DECIMAL(15, 4)) / CAST("t40"."$f2" AS DECIMAL(15, 4)) AS "return_ratio", CAST("t40"."$f3" AS DECIMAL(15, 4)) / CAST("t40"."$f4" AS DECIMAL(15, 4)) AS "currency_ratio", RANK() OVER (ORDER BY CAST("t40"."$f1" AS DECIMAL(15, 4)) / CAST("t40"."$f2" AS DECIMAL(15, 4)) IS NULL, CAST("t40"."$f1" AS DECIMAL(15, 4)) / CAST("t40"."$f2" AS DECIMAL(15, 4))) AS "return_rank", RANK() OVER (ORDER BY CAST("t40"."$f3" AS DECIMAL(15, 4)) / CAST("t40"."$f4" AS DECIMAL(15, 4)) IS NULL, CAST("t40"."$f3" AS DECIMAL(15, 4)) / CAST("t40"."$f4" AS DECIMAL(15, 4))) AS "currency_rank"
FROM (SELECT "t35"."ss_item_sk" AS "item", SUM("t35"."CASE") AS "$f1", SUM("t35"."ss_quantity") AS "$f2", SUM("t35"."CASE5") AS "$f3", SUM("t35"."ss_net_paid") AS "$f4"
FROM (SELECT "t31"."ss_sold_date_sk", "t31"."ss_item_sk", "t31"."ss_quantity", "t31"."ss_net_paid", CASE WHEN "t33"."CAST12" IS NOT NULL THEN CAST("t33"."CAST12" AS SIGNED) ELSE 0 END AS "CASE", CASE WHEN "t33"."CAST13" IS NOT NULL THEN CAST("t33"."CAST13" AS DECIMAL(19, 0)) ELSE 0 END AS "CASE5"
FROM (SELECT *
FROM store_sales
WHERE "ss_net_profit" > 1 AND "ss_net_paid" > 0 AND "ss_quantity" > 0) AS "t31"
INNER JOIN (SELECT "sr_item_sk", "sr_ticket_number", CAST("sr_returned_date_sk" AS SIGNED) AS "CAST", CAST("sr_return_time_sk" AS SIGNED) AS "CAST3", CAST("sr_item_sk" AS SIGNED) AS "CAST4", CAST("sr_customer_sk" AS SIGNED) AS "CAST5", CAST("sr_cdemo_sk" AS SIGNED) AS "CAST6", CAST("sr_hdemo_sk" AS SIGNED) AS "CAST7", CAST("sr_addr_sk" AS SIGNED) AS "CAST8", CAST("sr_store_sk" AS SIGNED) AS "CAST9", CAST("sr_reason_sk" AS SIGNED) AS "CAST10", CAST("sr_ticket_number" AS SIGNED) AS "CAST11", CAST("sr_return_quantity" AS SIGNED) AS "CAST12", CAST("sr_return_amt" AS DECIMAL(19, 0)) AS "CAST13", CAST("sr_return_tax" AS DECIMAL(19, 0)) AS "CAST14", CAST("sr_return_amt_inc_tax" AS DECIMAL(19, 0)) AS "CAST15", CAST("sr_fee" AS DECIMAL(19, 0)) AS "CAST16", CAST("sr_return_ship_cost" AS DECIMAL(19, 0)) AS "CAST17", CAST("sr_refunded_cash" AS DECIMAL(19, 0)) AS "CAST18", CAST("sr_reversed_charge" AS DECIMAL(19, 0)) AS "CAST19", CAST("sr_store_credit" AS DECIMAL(19, 0)) AS "CAST20", CAST("sr_net_loss" AS DECIMAL(19, 0)) AS "CAST21"
FROM store_returns
WHERE "sr_return_amt" > 10000) AS "t33" ON "t31"."ss_ticket_number" = "t33"."sr_ticket_number" AND "t31"."ss_item_sk" = "t33"."sr_item_sk") AS "t35"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2001 AND "d_moy" = 12) AS "t38" ON "t35"."ss_sold_date_sk" = "t38"."d_date_sk"
GROUP BY "t35"."ss_item_sk") AS "t40") AS "t41"
WHERE "return_rank" <= 10 OR "currency_rank" <= 10) AS "t45"
ORDER BY "channel", "return_rank", "currency_rank", "item"
LIMIT 100
;
