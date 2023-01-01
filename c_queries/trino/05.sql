SELECT *
FROM (SELECT *
FROM (SELECT "channel", "id", SUM("sales") AS "sales", SUM("returns_") AS "returns_", SUM("profit") AS "profit"
FROM (SELECT *
FROM (SELECT 'store channel' AS "channel", 'store' || "s_store_id" AS "id", SUM("sales_price") AS "sales", SUM("return_amt") AS "returns_", SUM("profit") - SUM("net_loss") AS "profit"
FROM (SELECT *
FROM (SELECT "ss_store_sk" AS "store_sk", "ss_sold_date_sk" AS "date_sk", "ss_ext_sales_price" AS "sales_price", "ss_net_profit" AS "profit", 0 AS "return_amt", 0 AS "net_loss"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t0" ON "t"."date_sk" = "t0"."d_date_sk"
INNER JOIN tpcds.sf1000.store AS store ON "t"."store_sk" = "store"."s_store_sk"
UNION ALL
SELECT *
FROM (SELECT "sr_store_sk" AS "store_sk", "sr_returned_date_sk" AS "date_sk", 0 AS "sales_price", 0 AS "profit", "sr_return_amt" AS "return_amt", "sr_net_loss" AS "net_loss"
FROM tpcds.sf1000.store_returns AS store_returns) AS "t1"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t2" ON "t1"."date_sk" = "t2"."d_date_sk"
INNER JOIN tpcds.sf1000.store AS "store0" ON "t1"."store_sk" = "store0"."s_store_sk") AS "t3"
GROUP BY "s_store_id"
UNION ALL
SELECT 'catalog channel' AS "channel", 'catalog_page' || "cp_catalog_page_id" AS "id", SUM("sales_price") AS "sales", SUM("return_amt") AS "returns_", SUM("profit") - SUM("net_loss") AS "profit"
FROM (SELECT *
FROM (SELECT "cs_catalog_page_sk" AS "page_sk", "cs_sold_date_sk" AS "date_sk", "cs_ext_sales_price" AS "sales_price", "cs_net_profit" AS "profit", 0 AS "return_amt", 0 AS "net_loss"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t7"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t8" ON "t7"."date_sk" = "t8"."d_date_sk"
INNER JOIN tpcds.sf1000.catalog_page AS catalog_page ON "t7"."page_sk" = "catalog_page"."cp_catalog_page_sk"
UNION ALL
SELECT *
FROM (SELECT "cr_catalog_page_sk" AS "page_sk", "cr_returned_date_sk" AS "date_sk", 0 AS "sales_price", 0 AS "profit", "cr_return_amount" AS "return_amt", "cr_net_loss" AS "net_loss"
FROM tpcds.sf1000.catalog_returns AS catalog_returns) AS "t9"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t10" ON "t9"."date_sk" = "t10"."d_date_sk"
INNER JOIN tpcds.sf1000.catalog_page AS "catalog_page0" ON "t9"."page_sk" = "catalog_page0"."cp_catalog_page_sk") AS "t11"
GROUP BY "cp_catalog_page_id") AS "t"
UNION ALL
SELECT 'web channel' AS "channel", 'web_site' || "web_site_id" AS "id", SUM("sales_price") AS "sales", SUM("return_amt") AS "returns_", SUM("profit") - SUM("net_loss") AS "profit"
FROM (SELECT *
FROM (SELECT "ws_web_site_sk" AS "wsr_web_site_sk", "ws_sold_date_sk" AS "date_sk", "ws_ext_sales_price" AS "sales_price", "ws_net_profit" AS "profit", 0 AS "return_amt", 0 AS "net_loss"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t16"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t17" ON "t16"."date_sk" = "t17"."d_date_sk"
INNER JOIN tpcds.sf1000.web_site AS web_site ON "t16"."wsr_web_site_sk" = "web_site"."web_site_sk"
UNION ALL
SELECT *
FROM (SELECT "t19"."ws_web_site_sk" AS "wsr_web_site_sk", "t18"."wr_returned_date_sk" AS "date_sk", 0 AS "sales_price", 0 AS "profit", "t18"."wr_return_amt" AS "return_amt", "t18"."wr_net_loss" AS "net_loss"
FROM (SELECT "wr_returned_date_sk", "wr_item_sk", "wr_order_number", "wr_return_amt", "wr_net_loss"
FROM tpcds.sf1000.web_returns AS web_returns) AS "t18"
LEFT JOIN (SELECT "ws_item_sk", "ws_web_site_sk", "ws_order_number"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t19" ON "t18"."wr_item_sk" = "t19"."ws_item_sk" AND "t18"."wr_order_number" = "t19"."ws_order_number") AS "t20"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t21" ON "t20"."date_sk" = "t21"."d_date_sk"
INNER JOIN tpcds.sf1000.web_site AS "web_site0" ON "t20"."wsr_web_site_sk" = "web_site0"."web_site_sk") AS "t22"
GROUP BY "web_site_id") AS "t26"
GROUP BY "channel", "id"
UNION
SELECT "channel", NULL AS "id", SUM("sales") AS "EXPR$2", SUM("returns_") AS "EXPR$3", SUM("profit") AS "EXPR$4"
FROM (SELECT "channel", SUM("sales") AS "sales", SUM("returns_") AS "returns_", SUM("profit") AS "profit"
FROM (SELECT *
FROM (SELECT 'store channel' AS "channel", 'store' || "s_store_id" AS "id", SUM("sales_price") AS "sales", SUM("return_amt") AS "returns_", SUM("profit") - SUM("net_loss") AS "profit"
FROM (SELECT *
FROM (SELECT "ss_store_sk" AS "store_sk", "ss_sold_date_sk" AS "date_sk", "ss_ext_sales_price" AS "sales_price", "ss_net_profit" AS "profit", 0 AS "return_amt", 0 AS "net_loss"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t29"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t30" ON "t29"."date_sk" = "t30"."d_date_sk"
INNER JOIN tpcds.sf1000.store AS "store1" ON "t29"."store_sk" = "store1"."s_store_sk"
UNION ALL
SELECT *
FROM (SELECT "sr_store_sk" AS "store_sk", "sr_returned_date_sk" AS "date_sk", 0 AS "sales_price", 0 AS "profit", "sr_return_amt" AS "return_amt", "sr_net_loss" AS "net_loss"
FROM tpcds.sf1000.store_returns AS store_returns) AS "t31"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t32" ON "t31"."date_sk" = "t32"."d_date_sk"
INNER JOIN tpcds.sf1000.store AS "store2" ON "t31"."store_sk" = "store2"."s_store_sk") AS "t33"
GROUP BY "s_store_id"
UNION ALL
SELECT 'catalog channel' AS "channel", 'catalog_page' || "cp_catalog_page_id" AS "id", SUM("sales_price") AS "sales", SUM("return_amt") AS "returns_", SUM("profit") - SUM("net_loss") AS "profit"
FROM (SELECT *
FROM (SELECT "cs_catalog_page_sk" AS "page_sk", "cs_sold_date_sk" AS "date_sk", "cs_ext_sales_price" AS "sales_price", "cs_net_profit" AS "profit", 0 AS "return_amt", 0 AS "net_loss"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t37"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t38" ON "t37"."date_sk" = "t38"."d_date_sk"
INNER JOIN tpcds.sf1000.catalog_page AS "catalog_page1" ON "t37"."page_sk" = "catalog_page1"."cp_catalog_page_sk"
UNION ALL
SELECT *
FROM (SELECT "cr_catalog_page_sk" AS "page_sk", "cr_returned_date_sk" AS "date_sk", 0 AS "sales_price", 0 AS "profit", "cr_return_amount" AS "return_amt", "cr_net_loss" AS "net_loss"
FROM tpcds.sf1000.catalog_returns AS catalog_returns) AS "t39"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t40" ON "t39"."date_sk" = "t40"."d_date_sk"
INNER JOIN tpcds.sf1000.catalog_page AS "catalog_page2" ON "t39"."page_sk" = "catalog_page2"."cp_catalog_page_sk") AS "t41"
GROUP BY "cp_catalog_page_id") AS "t"
UNION ALL
SELECT 'web channel' AS "channel", 'web_site' || "web_site_id" AS "id", SUM("sales_price") AS "sales", SUM("return_amt") AS "returns_", SUM("profit") - SUM("net_loss") AS "profit"
FROM (SELECT *
FROM (SELECT "ws_web_site_sk" AS "wsr_web_site_sk", "ws_sold_date_sk" AS "date_sk", "ws_ext_sales_price" AS "sales_price", "ws_net_profit" AS "profit", 0 AS "return_amt", 0 AS "net_loss"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t46"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t47" ON "t46"."date_sk" = "t47"."d_date_sk"
INNER JOIN tpcds.sf1000.web_site AS "web_site1" ON "t46"."wsr_web_site_sk" = "web_site1"."web_site_sk"
UNION ALL
SELECT *
FROM (SELECT "t49"."ws_web_site_sk" AS "wsr_web_site_sk", "t48"."wr_returned_date_sk" AS "date_sk", 0 AS "sales_price", 0 AS "profit", "t48"."wr_return_amt" AS "return_amt", "t48"."wr_net_loss" AS "net_loss"
FROM (SELECT "wr_returned_date_sk", "wr_item_sk", "wr_order_number", "wr_return_amt", "wr_net_loss"
FROM tpcds.sf1000.web_returns AS web_returns) AS "t48"
LEFT JOIN (SELECT "ws_item_sk", "ws_web_site_sk", "ws_order_number"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t49" ON "t48"."wr_item_sk" = "t49"."ws_item_sk" AND "t48"."wr_order_number" = "t49"."ws_order_number") AS "t50"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t51" ON "t50"."date_sk" = "t51"."d_date_sk"
INNER JOIN tpcds.sf1000.web_site AS "web_site2" ON "t50"."wsr_web_site_sk" = "web_site2"."web_site_sk") AS "t52"
GROUP BY "web_site_id") AS "t56"
GROUP BY "channel", "id") AS "t58"
GROUP BY "channel") AS "t"
UNION
SELECT NULL AS "channel", NULL AS "id", SUM("sales") AS "EXPR$2", SUM("returns_") AS "EXPR$3", SUM("profit") AS "EXPR$4"
FROM (SELECT SUM("sales") AS "sales", SUM("returns_") AS "returns_", SUM("profit") AS "profit"
FROM (SELECT *
FROM (SELECT 'store channel' AS "channel", 'store' || "s_store_id" AS "id", SUM("sales_price") AS "sales", SUM("return_amt") AS "returns_", SUM("profit") - SUM("net_loss") AS "profit"
FROM (SELECT *
FROM (SELECT "ss_store_sk" AS "store_sk", "ss_sold_date_sk" AS "date_sk", "ss_ext_sales_price" AS "sales_price", "ss_net_profit" AS "profit", 0 AS "return_amt", 0 AS "net_loss"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t62"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t63" ON "t62"."date_sk" = "t63"."d_date_sk"
INNER JOIN tpcds.sf1000.store AS "store3" ON "t62"."store_sk" = "store3"."s_store_sk"
UNION ALL
SELECT *
FROM (SELECT "sr_store_sk" AS "store_sk", "sr_returned_date_sk" AS "date_sk", 0 AS "sales_price", 0 AS "profit", "sr_return_amt" AS "return_amt", "sr_net_loss" AS "net_loss"
FROM tpcds.sf1000.store_returns AS store_returns) AS "t64"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t65" ON "t64"."date_sk" = "t65"."d_date_sk"
INNER JOIN tpcds.sf1000.store AS "store4" ON "t64"."store_sk" = "store4"."s_store_sk") AS "t66"
GROUP BY "s_store_id"
UNION ALL
SELECT 'catalog channel' AS "channel", 'catalog_page' || "cp_catalog_page_id" AS "id", SUM("sales_price") AS "sales", SUM("return_amt") AS "returns_", SUM("profit") - SUM("net_loss") AS "profit"
FROM (SELECT *
FROM (SELECT "cs_catalog_page_sk" AS "page_sk", "cs_sold_date_sk" AS "date_sk", "cs_ext_sales_price" AS "sales_price", "cs_net_profit" AS "profit", 0 AS "return_amt", 0 AS "net_loss"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t70"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t71" ON "t70"."date_sk" = "t71"."d_date_sk"
INNER JOIN tpcds.sf1000.catalog_page AS "catalog_page3" ON "t70"."page_sk" = "catalog_page3"."cp_catalog_page_sk"
UNION ALL
SELECT *
FROM (SELECT "cr_catalog_page_sk" AS "page_sk", "cr_returned_date_sk" AS "date_sk", 0 AS "sales_price", 0 AS "profit", "cr_return_amount" AS "return_amt", "cr_net_loss" AS "net_loss"
FROM tpcds.sf1000.catalog_returns AS catalog_returns) AS "t72"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t73" ON "t72"."date_sk" = "t73"."d_date_sk"
INNER JOIN tpcds.sf1000.catalog_page AS "catalog_page4" ON "t72"."page_sk" = "catalog_page4"."cp_catalog_page_sk") AS "t74"
GROUP BY "cp_catalog_page_id") AS "t"
UNION ALL
SELECT 'web channel' AS "channel", 'web_site' || "web_site_id" AS "id", SUM("sales_price") AS "sales", SUM("return_amt") AS "returns_", SUM("profit") - SUM("net_loss") AS "profit"
FROM (SELECT *
FROM (SELECT "ws_web_site_sk" AS "wsr_web_site_sk", "ws_sold_date_sk" AS "date_sk", "ws_ext_sales_price" AS "sales_price", "ws_net_profit" AS "profit", 0 AS "return_amt", 0 AS "net_loss"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t79"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t80" ON "t79"."date_sk" = "t80"."d_date_sk"
INNER JOIN tpcds.sf1000.web_site AS "web_site3" ON "t79"."wsr_web_site_sk" = "web_site3"."web_site_sk"
UNION ALL
SELECT *
FROM (SELECT "t82"."ws_web_site_sk" AS "wsr_web_site_sk", "t81"."wr_returned_date_sk" AS "date_sk", 0 AS "sales_price", 0 AS "profit", "t81"."wr_return_amt" AS "return_amt", "t81"."wr_net_loss" AS "net_loss"
FROM (SELECT "wr_returned_date_sk", "wr_item_sk", "wr_order_number", "wr_return_amt", "wr_net_loss"
FROM tpcds.sf1000.web_returns AS web_returns) AS "t81"
LEFT JOIN (SELECT "ws_item_sk", "ws_web_site_sk", "ws_order_number"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t82" ON "t81"."wr_item_sk" = "t82"."ws_item_sk" AND "t81"."wr_order_number" = "t82"."ws_order_number") AS "t83"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-06') AS "t84" ON "t83"."date_sk" = "t84"."d_date_sk"
INNER JOIN tpcds.sf1000.web_site AS "web_site4" ON "t83"."wsr_web_site_sk" = "web_site4"."web_site_sk") AS "t85"
GROUP BY "web_site_id") AS "t89"
GROUP BY "channel", "id") AS "t91") AS "t94"
ORDER BY "channel", "id"
LIMIT 100

