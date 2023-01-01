SELECT "t5"."ss_sold_year", "t5"."ss_item_sk", "t5"."ss_customer_sk", ROUND("t5"."ss_qty" * 1.00 / (CASE WHEN "t11"."ws_qty" IS NOT NULL THEN CAST("t11"."ws_qty" AS INTEGER) ELSE 0 END + CASE WHEN "t17"."cs_qty" IS NOT NULL THEN CAST("t17"."cs_qty" AS INTEGER) ELSE 0 END), 2) AS "ratio", "t5"."ss_qty" AS "store_qty", "t5"."ss_wc" AS "store_wholesale_cost", "t5"."ss_sp" AS "store_sales_price", CASE WHEN "t11"."ws_qty" IS NOT NULL THEN CAST("t11"."ws_qty" AS INTEGER) ELSE 0 END + CASE WHEN "t17"."cs_qty" IS NOT NULL THEN CAST("t17"."cs_qty" AS INTEGER) ELSE 0 END AS "other_chan_qty", CASE WHEN "t11"."ws_wc" IS NOT NULL THEN CAST("t11"."ws_wc" AS DECIMAL(19, 0)) ELSE 0 END + CASE WHEN "t17"."cs_wc" IS NOT NULL THEN CAST("t17"."cs_wc" AS DECIMAL(19, 0)) ELSE 0 END AS "other_chan_wholesale_cost", CASE WHEN "t11"."ws_sp" IS NOT NULL THEN CAST("t11"."ws_sp" AS DECIMAL(19, 0)) ELSE 0 END + CASE WHEN "t17"."cs_sp" IS NOT NULL THEN CAST("t17"."cs_sp" AS DECIMAL(19, 0)) ELSE 0 END AS "other_chan_sales_price"
FROM (SELECT "t2"."d_year" AS "ss_sold_year", "t1"."ss_item_sk", "t1"."ss_customer_sk", SUM("t1"."ss_quantity") AS "ss_qty", SUM("t1"."ss_wholesale_cost") AS "ss_wc", SUM("t1"."ss_sales_price") AS "ss_sp"
FROM (SELECT "store_sales"."ss_sold_date_sk", "store_sales"."ss_item_sk", "store_sales"."ss_customer_sk", "store_sales"."ss_quantity", "store_sales"."ss_wholesale_cost", "store_sales"."ss_sales_price"
FROM store_sales
LEFT JOIN store_returns ON "store_sales"."ss_ticket_number" = "store_returns"."sr_ticket_number" AND "store_sales"."ss_item_sk" = "store_returns"."sr_item_sk"
WHERE "store_returns"."sr_ticket_number" IS NULL) AS "t1"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t2" ON "t1"."ss_sold_date_sk" = "t2"."d_date_sk"
GROUP BY "t2"."d_year", "t1"."ss_item_sk", "t1"."ss_customer_sk"
HAVING "t2"."d_year" = 2000) AS "t5"
LEFT JOIN (SELECT "t9"."d_year" AS "ws_sold_year", "t8"."ws_item_sk", "t8"."ws_bill_customer_sk" AS "ws_customer_sk", SUM("t8"."ws_quantity") AS "ws_qty", SUM("t8"."ws_wholesale_cost") AS "ws_wc", SUM("t8"."ws_sales_price") AS "ws_sp"
FROM (SELECT "web_sales"."ws_sold_date_sk", "web_sales"."ws_item_sk", "web_sales"."ws_bill_customer_sk", "web_sales"."ws_quantity", "web_sales"."ws_wholesale_cost", "web_sales"."ws_sales_price"
FROM web_sales
LEFT JOIN web_returns ON "web_sales"."ws_order_number" = "web_returns"."wr_order_number" AND "web_sales"."ws_item_sk" = "web_returns"."wr_item_sk"
WHERE "web_returns"."wr_order_number" IS NULL) AS "t8"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t9" ON "t8"."ws_sold_date_sk" = "t9"."d_date_sk"
GROUP BY "t9"."d_year", "t8"."ws_item_sk", "t8"."ws_bill_customer_sk") AS "t11" ON "t5"."ss_sold_year" = "t11"."ws_sold_year" AND "t5"."ss_item_sk" = "t11"."ws_item_sk" AND "t5"."ss_customer_sk" = "t11"."ws_customer_sk"
LEFT JOIN (SELECT "t15"."d_year" AS "cs_sold_year", "t14"."cs_item_sk", "t14"."cs_bill_customer_sk" AS "cs_customer_sk", SUM("t14"."cs_quantity") AS "cs_qty", SUM("t14"."cs_wholesale_cost") AS "cs_wc", SUM("t14"."cs_sales_price") AS "cs_sp"
FROM (SELECT "catalog_sales"."cs_sold_date_sk", "catalog_sales"."cs_bill_customer_sk", "catalog_sales"."cs_item_sk", "catalog_sales"."cs_quantity", "catalog_sales"."cs_wholesale_cost", "catalog_sales"."cs_sales_price"
FROM catalog_sales
LEFT JOIN catalog_returns ON "catalog_sales"."cs_order_number" = "catalog_returns"."cr_order_number" AND "catalog_sales"."cs_item_sk" = "catalog_returns"."cr_item_sk"
WHERE "catalog_returns"."cr_order_number" IS NULL) AS "t14"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t15" ON "t14"."cs_sold_date_sk" = "t15"."d_date_sk"
GROUP BY "t15"."d_year", "t14"."cs_item_sk", "t14"."cs_bill_customer_sk") AS "t17" ON "t5"."ss_sold_year" = "t17"."cs_sold_year" AND "t5"."ss_item_sk" = "t17"."cs_item_sk" AND "t5"."ss_customer_sk" = "t17"."cs_customer_sk"
WHERE CASE WHEN "t11"."ws_qty" IS NOT NULL THEN CAST("t11"."ws_qty" AS INTEGER) ELSE 0 END > 0 OR CASE WHEN "t17"."cs_qty" IS NOT NULL THEN CAST("t17"."cs_qty" AS INTEGER) ELSE 0 END > 0
ORDER BY "t5"."ss_sold_year", "t5"."ss_item_sk", "t5"."ss_customer_sk", "t5"."ss_qty" DESC NULLS LAST, "t5"."ss_wc" DESC NULLS LAST, "t5"."ss_sp" DESC NULLS LAST, CASE WHEN "t11"."ws_qty" IS NOT NULL THEN CAST("t11"."ws_qty" AS INTEGER) ELSE 0 END + CASE WHEN "t17"."cs_qty" IS NOT NULL THEN CAST("t17"."cs_qty" AS INTEGER) ELSE 0 END, CASE WHEN "t11"."ws_wc" IS NOT NULL THEN CAST("t11"."ws_wc" AS DECIMAL(19, 0)) ELSE 0 END + CASE WHEN "t17"."cs_wc" IS NOT NULL THEN CAST("t17"."cs_wc" AS DECIMAL(19, 0)) ELSE 0 END, CASE WHEN "t11"."ws_sp" IS NOT NULL THEN CAST("t11"."ws_sp" AS DECIMAL(19, 0)) ELSE 0 END + CASE WHEN "t17"."cs_sp" IS NOT NULL THEN CAST("t17"."cs_sp" AS DECIMAL(19, 0)) ELSE 0 END, ROUND("t5"."ss_qty" * 1.00 / (CASE WHEN "t11"."ws_qty" IS NOT NULL THEN CAST("t11"."ws_qty" AS INTEGER) ELSE 0 END + CASE WHEN "t17"."cs_qty" IS NOT NULL THEN CAST("t17"."cs_qty" AS INTEGER) ELSE 0 END), 2)
FETCH NEXT 100 ROWS ONLY

