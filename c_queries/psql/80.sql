SELECT *
FROM (SELECT *
FROM (SELECT "channel", "id", SUM("sales") AS "sales", SUM("returns_") AS "returns_", SUM("profit") AS "profit"
FROM (SELECT *
FROM (SELECT 'store channel' AS "channel", 'store' || "store"."s_store_id" AS "id", SUM("store_sales"."ss_ext_sales_price") AS "sales", SUM(CASE WHEN "store_returns"."sr_return_amt" IS NOT NULL THEN CAST("store_returns"."sr_return_amt" AS DECIMAL(19, 0)) ELSE 0 END) AS "returns_", SUM("store_sales"."ss_net_profit" - CASE WHEN "store_returns"."sr_net_loss" IS NOT NULL THEN CAST("store_returns"."sr_net_loss" AS DECIMAL(19, 0)) ELSE 0 END) AS "profit"
FROM store_sales
LEFT JOIN store_returns ON "store_sales"."ss_item_sk" = "store_returns"."sr_item_sk" AND "store_sales"."ss_ticket_number" = "store_returns"."sr_ticket_number"
INNER JOIN (SELECT *
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t" ON "store_sales"."ss_sold_date_sk" = "t"."d_date_sk"
INNER JOIN store ON "store_sales"."ss_store_sk" = "store"."s_store_sk"
INNER JOIN (SELECT *
FROM item
WHERE "i_current_price" > 50) AS "t0" ON "store_sales"."ss_item_sk" = "t0"."i_item_sk"
INNER JOIN (SELECT *
FROM promotion
WHERE "p_channel_tv" = 'N') AS "t1" ON "store_sales"."ss_promo_sk" = "t1"."p_promo_sk"
GROUP BY "store"."s_store_id"
UNION ALL
SELECT 'catalog channel' AS "channel", 'catalog_page' || "catalog_page"."cp_catalog_page_id" AS "id", SUM("catalog_sales"."cs_ext_sales_price") AS "sales", SUM(CASE WHEN "catalog_returns"."cr_return_amount" IS NOT NULL THEN CAST("catalog_returns"."cr_return_amount" AS DECIMAL(19, 0)) ELSE 0 END) AS "returns_", SUM("catalog_sales"."cs_net_profit" - CASE WHEN "catalog_returns"."cr_net_loss" IS NOT NULL THEN CAST("catalog_returns"."cr_net_loss" AS DECIMAL(19, 0)) ELSE 0 END) AS "profit"
FROM catalog_sales
LEFT JOIN catalog_returns ON "catalog_sales"."cs_item_sk" = "catalog_returns"."cr_item_sk" AND "catalog_sales"."cs_order_number" = "catalog_returns"."cr_order_number"
INNER JOIN (SELECT *
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t5" ON "catalog_sales"."cs_sold_date_sk" = "t5"."d_date_sk"
INNER JOIN catalog_page ON "catalog_sales"."cs_catalog_page_sk" = "catalog_page"."cp_catalog_page_sk"
INNER JOIN (SELECT *
FROM item
WHERE "i_current_price" > 50) AS "t6" ON "catalog_sales"."cs_item_sk" = "t6"."i_item_sk"
INNER JOIN (SELECT *
FROM promotion
WHERE "p_channel_tv" = 'N') AS "t7" ON "catalog_sales"."cs_promo_sk" = "t7"."p_promo_sk"
GROUP BY "catalog_page"."cp_catalog_page_id") AS "t"
UNION ALL
SELECT 'web channel' AS "channel", 'web_site' || "web_site"."web_site_id" AS "id", SUM("web_sales"."ws_ext_sales_price") AS "sales", SUM(CASE WHEN "web_returns"."wr_return_amt" IS NOT NULL THEN CAST("web_returns"."wr_return_amt" AS DECIMAL(19, 0)) ELSE 0 END) AS "returns_", SUM("web_sales"."ws_net_profit" - CASE WHEN "web_returns"."wr_net_loss" IS NOT NULL THEN CAST("web_returns"."wr_net_loss" AS DECIMAL(19, 0)) ELSE 0 END) AS "profit"
FROM web_sales
LEFT JOIN web_returns ON "web_sales"."ws_item_sk" = "web_returns"."wr_item_sk" AND "web_sales"."ws_order_number" = "web_returns"."wr_order_number"
INNER JOIN (SELECT *
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t12" ON "web_sales"."ws_sold_date_sk" = "t12"."d_date_sk"
INNER JOIN web_site ON "web_sales"."ws_web_site_sk" = "web_site"."web_site_sk"
INNER JOIN (SELECT *
FROM item
WHERE "i_current_price" > 50) AS "t13" ON "web_sales"."ws_item_sk" = "t13"."i_item_sk"
INNER JOIN (SELECT *
FROM promotion
WHERE "p_channel_tv" = 'N') AS "t14" ON "web_sales"."ws_promo_sk" = "t14"."p_promo_sk"
GROUP BY "web_site"."web_site_id") AS "t18"
GROUP BY "channel", "id"
UNION
SELECT "channel", NULL AS "id", SUM("sales") AS "sales", SUM("returns_") AS "returns_", SUM("profit") AS "profit"
FROM (SELECT "channel", SUM("sales") AS "sales", SUM("returns_") AS "returns_", SUM("profit") AS "profit"
FROM (SELECT *
FROM (SELECT 'store channel' AS "channel", 'store' || "store0"."s_store_id" AS "id", SUM("store_sales0"."ss_ext_sales_price") AS "sales", SUM(CASE WHEN "store_returns0"."sr_return_amt" IS NOT NULL THEN CAST("store_returns0"."sr_return_amt" AS DECIMAL(19, 0)) ELSE 0 END) AS "returns_", SUM("store_sales0"."ss_net_profit" - CASE WHEN "store_returns0"."sr_net_loss" IS NOT NULL THEN CAST("store_returns0"."sr_net_loss" AS DECIMAL(19, 0)) ELSE 0 END) AS "profit"
FROM store_sales AS "store_sales0"
LEFT JOIN store_returns AS "store_returns0" ON "store_sales0"."ss_item_sk" = "store_returns0"."sr_item_sk" AND "store_sales0"."ss_ticket_number" = "store_returns0"."sr_ticket_number"
INNER JOIN (SELECT *
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t21" ON "store_sales0"."ss_sold_date_sk" = "t21"."d_date_sk"
INNER JOIN store AS "store0" ON "store_sales0"."ss_store_sk" = "store0"."s_store_sk"
INNER JOIN (SELECT *
FROM item
WHERE "i_current_price" > 50) AS "t22" ON "store_sales0"."ss_item_sk" = "t22"."i_item_sk"
INNER JOIN (SELECT *
FROM promotion
WHERE "p_channel_tv" = 'N') AS "t23" ON "store_sales0"."ss_promo_sk" = "t23"."p_promo_sk"
GROUP BY "store0"."s_store_id"
UNION ALL
SELECT 'catalog channel' AS "channel", 'catalog_page' || "catalog_page0"."cp_catalog_page_id" AS "id", SUM("catalog_sales0"."cs_ext_sales_price") AS "sales", SUM(CASE WHEN "catalog_returns0"."cr_return_amount" IS NOT NULL THEN CAST("catalog_returns0"."cr_return_amount" AS DECIMAL(19, 0)) ELSE 0 END) AS "returns_", SUM("catalog_sales0"."cs_net_profit" - CASE WHEN "catalog_returns0"."cr_net_loss" IS NOT NULL THEN CAST("catalog_returns0"."cr_net_loss" AS DECIMAL(19, 0)) ELSE 0 END) AS "profit"
FROM catalog_sales AS "catalog_sales0"
LEFT JOIN catalog_returns AS "catalog_returns0" ON "catalog_sales0"."cs_item_sk" = "catalog_returns0"."cr_item_sk" AND "catalog_sales0"."cs_order_number" = "catalog_returns0"."cr_order_number"
INNER JOIN (SELECT *
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t27" ON "catalog_sales0"."cs_sold_date_sk" = "t27"."d_date_sk"
INNER JOIN catalog_page AS "catalog_page0" ON "catalog_sales0"."cs_catalog_page_sk" = "catalog_page0"."cp_catalog_page_sk"
INNER JOIN (SELECT *
FROM item
WHERE "i_current_price" > 50) AS "t28" ON "catalog_sales0"."cs_item_sk" = "t28"."i_item_sk"
INNER JOIN (SELECT *
FROM promotion
WHERE "p_channel_tv" = 'N') AS "t29" ON "catalog_sales0"."cs_promo_sk" = "t29"."p_promo_sk"
GROUP BY "catalog_page0"."cp_catalog_page_id") AS "t"
UNION ALL
SELECT 'web channel' AS "channel", 'web_site' || "web_site0"."web_site_id" AS "id", SUM("web_sales0"."ws_ext_sales_price") AS "sales", SUM(CASE WHEN "web_returns0"."wr_return_amt" IS NOT NULL THEN CAST("web_returns0"."wr_return_amt" AS DECIMAL(19, 0)) ELSE 0 END) AS "returns_", SUM("web_sales0"."ws_net_profit" - CASE WHEN "web_returns0"."wr_net_loss" IS NOT NULL THEN CAST("web_returns0"."wr_net_loss" AS DECIMAL(19, 0)) ELSE 0 END) AS "profit"
FROM web_sales AS "web_sales0"
LEFT JOIN web_returns AS "web_returns0" ON "web_sales0"."ws_item_sk" = "web_returns0"."wr_item_sk" AND "web_sales0"."ws_order_number" = "web_returns0"."wr_order_number"
INNER JOIN (SELECT *
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t34" ON "web_sales0"."ws_sold_date_sk" = "t34"."d_date_sk"
INNER JOIN web_site AS "web_site0" ON "web_sales0"."ws_web_site_sk" = "web_site0"."web_site_sk"
INNER JOIN (SELECT *
FROM item
WHERE "i_current_price" > 50) AS "t35" ON "web_sales0"."ws_item_sk" = "t35"."i_item_sk"
INNER JOIN (SELECT *
FROM promotion
WHERE "p_channel_tv" = 'N') AS "t36" ON "web_sales0"."ws_promo_sk" = "t36"."p_promo_sk"
GROUP BY "web_site0"."web_site_id") AS "t40"
GROUP BY "channel", "id") AS "t42"
GROUP BY "channel") AS "t"
UNION
SELECT NULL AS "channel", NULL AS "id", SUM("sales") AS "sales", SUM("returns_") AS "returns_", SUM("profit") AS "profit"
FROM (SELECT SUM("sales") AS "sales", SUM("returns_") AS "returns_", SUM("profit") AS "profit"
FROM (SELECT *
FROM (SELECT 'store channel' AS "channel", 'store' || "store1"."s_store_id" AS "id", SUM("store_sales1"."ss_ext_sales_price") AS "sales", SUM(CASE WHEN "store_returns1"."sr_return_amt" IS NOT NULL THEN CAST("store_returns1"."sr_return_amt" AS DECIMAL(19, 0)) ELSE 0 END) AS "returns_", SUM("store_sales1"."ss_net_profit" - CASE WHEN "store_returns1"."sr_net_loss" IS NOT NULL THEN CAST("store_returns1"."sr_net_loss" AS DECIMAL(19, 0)) ELSE 0 END) AS "profit"
FROM store_sales AS "store_sales1"
LEFT JOIN store_returns AS "store_returns1" ON "store_sales1"."ss_item_sk" = "store_returns1"."sr_item_sk" AND "store_sales1"."ss_ticket_number" = "store_returns1"."sr_ticket_number"
INNER JOIN (SELECT *
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t46" ON "store_sales1"."ss_sold_date_sk" = "t46"."d_date_sk"
INNER JOIN store AS "store1" ON "store_sales1"."ss_store_sk" = "store1"."s_store_sk"
INNER JOIN (SELECT *
FROM item
WHERE "i_current_price" > 50) AS "t47" ON "store_sales1"."ss_item_sk" = "t47"."i_item_sk"
INNER JOIN (SELECT *
FROM promotion
WHERE "p_channel_tv" = 'N') AS "t48" ON "store_sales1"."ss_promo_sk" = "t48"."p_promo_sk"
GROUP BY "store1"."s_store_id"
UNION ALL
SELECT 'catalog channel' AS "channel", 'catalog_page' || "catalog_page1"."cp_catalog_page_id" AS "id", SUM("catalog_sales1"."cs_ext_sales_price") AS "sales", SUM(CASE WHEN "catalog_returns1"."cr_return_amount" IS NOT NULL THEN CAST("catalog_returns1"."cr_return_amount" AS DECIMAL(19, 0)) ELSE 0 END) AS "returns_", SUM("catalog_sales1"."cs_net_profit" - CASE WHEN "catalog_returns1"."cr_net_loss" IS NOT NULL THEN CAST("catalog_returns1"."cr_net_loss" AS DECIMAL(19, 0)) ELSE 0 END) AS "profit"
FROM catalog_sales AS "catalog_sales1"
LEFT JOIN catalog_returns AS "catalog_returns1" ON "catalog_sales1"."cs_item_sk" = "catalog_returns1"."cr_item_sk" AND "catalog_sales1"."cs_order_number" = "catalog_returns1"."cr_order_number"
INNER JOIN (SELECT *
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t52" ON "catalog_sales1"."cs_sold_date_sk" = "t52"."d_date_sk"
INNER JOIN catalog_page AS "catalog_page1" ON "catalog_sales1"."cs_catalog_page_sk" = "catalog_page1"."cp_catalog_page_sk"
INNER JOIN (SELECT *
FROM item
WHERE "i_current_price" > 50) AS "t53" ON "catalog_sales1"."cs_item_sk" = "t53"."i_item_sk"
INNER JOIN (SELECT *
FROM promotion
WHERE "p_channel_tv" = 'N') AS "t54" ON "catalog_sales1"."cs_promo_sk" = "t54"."p_promo_sk"
GROUP BY "catalog_page1"."cp_catalog_page_id") AS "t"
UNION ALL
SELECT 'web channel' AS "channel", 'web_site' || "web_site1"."web_site_id" AS "id", SUM("web_sales1"."ws_ext_sales_price") AS "sales", SUM(CASE WHEN "web_returns1"."wr_return_amt" IS NOT NULL THEN CAST("web_returns1"."wr_return_amt" AS DECIMAL(19, 0)) ELSE 0 END) AS "returns_", SUM("web_sales1"."ws_net_profit" - CASE WHEN "web_returns1"."wr_net_loss" IS NOT NULL THEN CAST("web_returns1"."wr_net_loss" AS DECIMAL(19, 0)) ELSE 0 END) AS "profit"
FROM web_sales AS "web_sales1"
LEFT JOIN web_returns AS "web_returns1" ON "web_sales1"."ws_item_sk" = "web_returns1"."wr_item_sk" AND "web_sales1"."ws_order_number" = "web_returns1"."wr_order_number"
INNER JOIN (SELECT *
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t59" ON "web_sales1"."ws_sold_date_sk" = "t59"."d_date_sk"
INNER JOIN web_site AS "web_site1" ON "web_sales1"."ws_web_site_sk" = "web_site1"."web_site_sk"
INNER JOIN (SELECT *
FROM item
WHERE "i_current_price" > 50) AS "t60" ON "web_sales1"."ws_item_sk" = "t60"."i_item_sk"
INNER JOIN (SELECT *
FROM promotion
WHERE "p_channel_tv" = 'N') AS "t61" ON "web_sales1"."ws_promo_sk" = "t61"."p_promo_sk"
GROUP BY "web_site1"."web_site_id") AS "t65"
GROUP BY "channel", "id") AS "t67") AS "t70"
ORDER BY "channel" NULLS FIRST, "id" NULLS FIRST
FETCH NEXT 100 ROWS ONLY

