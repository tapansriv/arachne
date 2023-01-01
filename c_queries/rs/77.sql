SELECT *
FROM (SELECT *
FROM (SELECT "channel", "id", SUM("sales") AS "sales", SUM("returns_") AS "returns_", SUM("profit") AS "profit"
FROM (SELECT *
FROM (SELECT 'store channel' AS "channel", "t7"."s_store_sk" AS "id", "t7"."sales", CASE WHEN "t16"."returns_" IS NOT NULL THEN "t16"."CAST" ELSE 0 END AS "returns_", "t7"."profit" - CASE WHEN "t16"."profit_loss" IS NOT NULL THEN "t16"."CAST4" ELSE 0 END AS "profit"
FROM (SELECT "t4"."s_store_sk", SUM("t3"."ss_ext_sales_price") AS "sales", SUM("t3"."ss_net_profit") AS "profit"
FROM (SELECT "t"."ss_store_sk", "t"."ss_ext_sales_price", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_ext_sales_price", "ss_net_profit"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "s_store_sk"
FROM store) AS "t4" ON "t3"."ss_store_sk" = "t4"."s_store_sk"
GROUP BY "t4"."s_store_sk") AS "t7"
LEFT JOIN (SELECT "t13"."s_store_sk", SUM("t12"."sr_return_amt") AS "returns_", SUM("t12"."sr_net_loss") AS "profit_loss", SUM("t12"."sr_return_amt") AS "CAST", SUM("t12"."sr_net_loss") AS "CAST4"
FROM (SELECT "t8"."sr_store_sk", "t8"."sr_return_amt", "t8"."sr_net_loss"
FROM (SELECT "sr_returned_date_sk", "sr_store_sk", "sr_return_amt", "sr_net_loss"
FROM store_returns) AS "t8"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t11" ON "t8"."sr_returned_date_sk" = "t11"."d_date_sk") AS "t12"
INNER JOIN (SELECT "s_store_sk"
FROM store) AS "t13" ON "t12"."sr_store_sk" = "t13"."s_store_sk"
GROUP BY "t13"."s_store_sk") AS "t16" ON "t7"."s_store_sk" = "t16"."s_store_sk"
UNION ALL
SELECT 'catalog channel' AS "channel", "t24"."cs_call_center_sk" AS "id", "t24"."sales", "t31"."returns_", "t24"."profit" - "t31"."profit_loss" AS "profit"
FROM (SELECT "t18"."cs_call_center_sk", SUM("t18"."cs_ext_sales_price") AS "sales", SUM("t18"."cs_net_profit") AS "profit"
FROM (SELECT "cs_sold_date_sk", "cs_call_center_sk", "cs_ext_sales_price", "cs_net_profit"
FROM catalog_sales) AS "t18"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t21" ON "t18"."cs_sold_date_sk" = "t21"."d_date_sk"
GROUP BY "t18"."cs_call_center_sk") AS "t24",
(SELECT SUM("t25"."cr_return_amount") AS "returns_", SUM("t25"."cr_net_loss") AS "profit_loss"
FROM (SELECT "cr_returned_date_sk", "cr_call_center_sk", "cr_return_amount", "cr_net_loss"
FROM catalog_returns) AS "t25"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t28" ON "t25"."cr_returned_date_sk" = "t28"."d_date_sk"
GROUP BY "t25"."cr_call_center_sk") AS "t31")
UNION ALL
SELECT 'web channel' AS "channel", "t42"."wp_web_page_sk" AS "id", "t42"."sales", CASE WHEN "t51"."returns_" IS NOT NULL THEN "t51"."CAST" ELSE 0 END AS "returns_", "t42"."profit" - CASE WHEN "t51"."profit_loss" IS NOT NULL THEN "t51"."CAST4" ELSE 0 END AS "profit"
FROM (SELECT "t39"."wp_web_page_sk", SUM("t38"."ws_ext_sales_price") AS "sales", SUM("t38"."ws_net_profit") AS "profit"
FROM (SELECT "t34"."ws_web_page_sk", "t34"."ws_ext_sales_price", "t34"."ws_net_profit"
FROM (SELECT "ws_sold_date_sk", "ws_web_page_sk", "ws_ext_sales_price", "ws_net_profit"
FROM web_sales) AS "t34"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t37" ON "t34"."ws_sold_date_sk" = "t37"."d_date_sk") AS "t38"
INNER JOIN (SELECT "wp_web_page_sk"
FROM web_page) AS "t39" ON "t38"."ws_web_page_sk" = "t39"."wp_web_page_sk"
GROUP BY "t39"."wp_web_page_sk") AS "t42"
LEFT JOIN (SELECT "t48"."wp_web_page_sk", SUM("t47"."wr_return_amt") AS "returns_", SUM("t47"."wr_net_loss") AS "profit_loss", SUM("t47"."wr_return_amt") AS "CAST", SUM("t47"."wr_net_loss") AS "CAST4"
FROM (SELECT "t43"."wr_web_page_sk", "t43"."wr_return_amt", "t43"."wr_net_loss"
FROM (SELECT "wr_returned_date_sk", "wr_web_page_sk", "wr_return_amt", "wr_net_loss"
FROM web_returns) AS "t43"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t46" ON "t43"."wr_returned_date_sk" = "t46"."d_date_sk") AS "t47"
INNER JOIN (SELECT "wp_web_page_sk"
FROM web_page) AS "t48" ON "t47"."wr_web_page_sk" = "t48"."wp_web_page_sk"
GROUP BY "t48"."wp_web_page_sk") AS "t51" ON "t42"."wp_web_page_sk" = "t51"."wp_web_page_sk") AS "t53"
GROUP BY "channel", "id"
UNION
SELECT "channel", NULL AS "id", SUM("sales") AS "sales", SUM("returns_") AS "returns_", SUM("profit") AS "profit"
FROM (SELECT "channel", SUM("sales") AS "sales", SUM("returns_") AS "returns_", SUM("profit") AS "profit"
FROM (SELECT *
FROM (SELECT 'store channel' AS "channel", "t64"."s_store_sk" AS "id", "t64"."sales", CASE WHEN "t73"."returns_" IS NOT NULL THEN "t73"."CAST" ELSE 0 END AS "returns_", "t64"."profit" - CASE WHEN "t73"."profit_loss" IS NOT NULL THEN "t73"."CAST4" ELSE 0 END AS "profit"
FROM (SELECT "t61"."s_store_sk", SUM("t60"."ss_ext_sales_price") AS "sales", SUM("t60"."ss_net_profit") AS "profit"
FROM (SELECT "t56"."ss_store_sk", "t56"."ss_ext_sales_price", "t56"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_ext_sales_price", "ss_net_profit"
FROM store_sales) AS "t56"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t59" ON "t56"."ss_sold_date_sk" = "t59"."d_date_sk") AS "t60"
INNER JOIN (SELECT "s_store_sk"
FROM store) AS "t61" ON "t60"."ss_store_sk" = "t61"."s_store_sk"
GROUP BY "t61"."s_store_sk") AS "t64"
LEFT JOIN (SELECT "t70"."s_store_sk", SUM("t69"."sr_return_amt") AS "returns_", SUM("t69"."sr_net_loss") AS "profit_loss", SUM("t69"."sr_return_amt") AS "CAST", SUM("t69"."sr_net_loss") AS "CAST4"
FROM (SELECT "t65"."sr_store_sk", "t65"."sr_return_amt", "t65"."sr_net_loss"
FROM (SELECT "sr_returned_date_sk", "sr_store_sk", "sr_return_amt", "sr_net_loss"
FROM store_returns) AS "t65"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t68" ON "t65"."sr_returned_date_sk" = "t68"."d_date_sk") AS "t69"
INNER JOIN (SELECT "s_store_sk"
FROM store) AS "t70" ON "t69"."sr_store_sk" = "t70"."s_store_sk"
GROUP BY "t70"."s_store_sk") AS "t73" ON "t64"."s_store_sk" = "t73"."s_store_sk"
UNION ALL
SELECT 'catalog channel' AS "channel", "t81"."cs_call_center_sk" AS "id", "t81"."sales", "t88"."returns_", "t81"."profit" - "t88"."profit_loss" AS "profit"
FROM (SELECT "t75"."cs_call_center_sk", SUM("t75"."cs_ext_sales_price") AS "sales", SUM("t75"."cs_net_profit") AS "profit"
FROM (SELECT "cs_sold_date_sk", "cs_call_center_sk", "cs_ext_sales_price", "cs_net_profit"
FROM catalog_sales) AS "t75"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t78" ON "t75"."cs_sold_date_sk" = "t78"."d_date_sk"
GROUP BY "t75"."cs_call_center_sk") AS "t81",
(SELECT SUM("t82"."cr_return_amount") AS "returns_", SUM("t82"."cr_net_loss") AS "profit_loss"
FROM (SELECT "cr_returned_date_sk", "cr_call_center_sk", "cr_return_amount", "cr_net_loss"
FROM catalog_returns) AS "t82"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t85" ON "t82"."cr_returned_date_sk" = "t85"."d_date_sk"
GROUP BY "t82"."cr_call_center_sk") AS "t88")
UNION ALL
SELECT 'web channel' AS "channel", "t99"."wp_web_page_sk" AS "id", "t99"."sales", CASE WHEN "t108"."returns_" IS NOT NULL THEN "t108"."CAST" ELSE 0 END AS "returns_", "t99"."profit" - CASE WHEN "t108"."profit_loss" IS NOT NULL THEN "t108"."CAST4" ELSE 0 END AS "profit"
FROM (SELECT "t96"."wp_web_page_sk", SUM("t95"."ws_ext_sales_price") AS "sales", SUM("t95"."ws_net_profit") AS "profit"
FROM (SELECT "t91"."ws_web_page_sk", "t91"."ws_ext_sales_price", "t91"."ws_net_profit"
FROM (SELECT "ws_sold_date_sk", "ws_web_page_sk", "ws_ext_sales_price", "ws_net_profit"
FROM web_sales) AS "t91"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t94" ON "t91"."ws_sold_date_sk" = "t94"."d_date_sk") AS "t95"
INNER JOIN (SELECT "wp_web_page_sk"
FROM web_page) AS "t96" ON "t95"."ws_web_page_sk" = "t96"."wp_web_page_sk"
GROUP BY "t96"."wp_web_page_sk") AS "t99"
LEFT JOIN (SELECT "t105"."wp_web_page_sk", SUM("t104"."wr_return_amt") AS "returns_", SUM("t104"."wr_net_loss") AS "profit_loss", SUM("t104"."wr_return_amt") AS "CAST", SUM("t104"."wr_net_loss") AS "CAST4"
FROM (SELECT "t100"."wr_web_page_sk", "t100"."wr_return_amt", "t100"."wr_net_loss"
FROM (SELECT "wr_returned_date_sk", "wr_web_page_sk", "wr_return_amt", "wr_net_loss"
FROM web_returns) AS "t100"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t103" ON "t100"."wr_returned_date_sk" = "t103"."d_date_sk") AS "t104"
INNER JOIN (SELECT "wp_web_page_sk"
FROM web_page) AS "t105" ON "t104"."wr_web_page_sk" = "t105"."wp_web_page_sk"
GROUP BY "t105"."wp_web_page_sk") AS "t108" ON "t99"."wp_web_page_sk" = "t108"."wp_web_page_sk") AS "t110"
GROUP BY "channel", "id") AS "t112"
GROUP BY "channel")
UNION
SELECT NULL AS "channel", NULL AS "id", SUM(SUM("sales")) AS "sales", SUM(SUM("returns_")) AS "returns_", SUM(SUM("profit")) AS "profit"
FROM (SELECT *
FROM (SELECT 'store channel' AS "channel", "t124"."s_store_sk" AS "id", "t124"."sales", CASE WHEN "t133"."returns_" IS NOT NULL THEN "t133"."CAST" ELSE 0 END AS "returns_", "t124"."profit" - CASE WHEN "t133"."profit_loss" IS NOT NULL THEN "t133"."CAST4" ELSE 0 END AS "profit"
FROM (SELECT "t121"."s_store_sk", SUM("t120"."ss_ext_sales_price") AS "sales", SUM("t120"."ss_net_profit") AS "profit"
FROM (SELECT "t116"."ss_store_sk", "t116"."ss_ext_sales_price", "t116"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_ext_sales_price", "ss_net_profit"
FROM store_sales) AS "t116"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t119" ON "t116"."ss_sold_date_sk" = "t119"."d_date_sk") AS "t120"
INNER JOIN (SELECT "s_store_sk"
FROM store) AS "t121" ON "t120"."ss_store_sk" = "t121"."s_store_sk"
GROUP BY "t121"."s_store_sk") AS "t124"
LEFT JOIN (SELECT "t130"."s_store_sk", SUM("t129"."sr_return_amt") AS "returns_", SUM("t129"."sr_net_loss") AS "profit_loss", SUM("t129"."sr_return_amt") AS "CAST", SUM("t129"."sr_net_loss") AS "CAST4"
FROM (SELECT "t125"."sr_store_sk", "t125"."sr_return_amt", "t125"."sr_net_loss"
FROM (SELECT "sr_returned_date_sk", "sr_store_sk", "sr_return_amt", "sr_net_loss"
FROM store_returns) AS "t125"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t128" ON "t125"."sr_returned_date_sk" = "t128"."d_date_sk") AS "t129"
INNER JOIN (SELECT "s_store_sk"
FROM store) AS "t130" ON "t129"."sr_store_sk" = "t130"."s_store_sk"
GROUP BY "t130"."s_store_sk") AS "t133" ON "t124"."s_store_sk" = "t133"."s_store_sk"
UNION ALL
SELECT 'catalog channel' AS "channel", "t141"."cs_call_center_sk" AS "id", "t141"."sales", "t148"."returns_", "t141"."profit" - "t148"."profit_loss" AS "profit"
FROM (SELECT "t135"."cs_call_center_sk", SUM("t135"."cs_ext_sales_price") AS "sales", SUM("t135"."cs_net_profit") AS "profit"
FROM (SELECT "cs_sold_date_sk", "cs_call_center_sk", "cs_ext_sales_price", "cs_net_profit"
FROM catalog_sales) AS "t135"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t138" ON "t135"."cs_sold_date_sk" = "t138"."d_date_sk"
GROUP BY "t135"."cs_call_center_sk") AS "t141",
(SELECT SUM("t142"."cr_return_amount") AS "returns_", SUM("t142"."cr_net_loss") AS "profit_loss"
FROM (SELECT "cr_returned_date_sk", "cr_call_center_sk", "cr_return_amount", "cr_net_loss"
FROM catalog_returns) AS "t142"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t145" ON "t142"."cr_returned_date_sk" = "t145"."d_date_sk"
GROUP BY "t142"."cr_call_center_sk") AS "t148")
UNION ALL
SELECT 'web channel' AS "channel", "t159"."wp_web_page_sk" AS "id", "t159"."sales", CASE WHEN "t168"."returns_" IS NOT NULL THEN "t168"."CAST" ELSE 0 END AS "returns_", "t159"."profit" - CASE WHEN "t168"."profit_loss" IS NOT NULL THEN "t168"."CAST4" ELSE 0 END AS "profit"
FROM (SELECT "t156"."wp_web_page_sk", SUM("t155"."ws_ext_sales_price") AS "sales", SUM("t155"."ws_net_profit") AS "profit"
FROM (SELECT "t151"."ws_web_page_sk", "t151"."ws_ext_sales_price", "t151"."ws_net_profit"
FROM (SELECT "ws_sold_date_sk", "ws_web_page_sk", "ws_ext_sales_price", "ws_net_profit"
FROM web_sales) AS "t151"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t154" ON "t151"."ws_sold_date_sk" = "t154"."d_date_sk") AS "t155"
INNER JOIN (SELECT "wp_web_page_sk"
FROM web_page) AS "t156" ON "t155"."ws_web_page_sk" = "t156"."wp_web_page_sk"
GROUP BY "t156"."wp_web_page_sk") AS "t159"
LEFT JOIN (SELECT "t165"."wp_web_page_sk", SUM("t164"."wr_return_amt") AS "returns_", SUM("t164"."wr_net_loss") AS "profit_loss", SUM("t164"."wr_return_amt") AS "CAST", SUM("t164"."wr_net_loss") AS "CAST4"
FROM (SELECT "t160"."wr_web_page_sk", "t160"."wr_return_amt", "t160"."wr_net_loss"
FROM (SELECT "wr_returned_date_sk", "wr_web_page_sk", "wr_return_amt", "wr_net_loss"
FROM web_returns) AS "t160"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-08-23' AND "d_date" <= DATE '2000-09-22') AS "t163" ON "t160"."wr_returned_date_sk" = "t163"."d_date_sk") AS "t164"
INNER JOIN (SELECT "wp_web_page_sk"
FROM web_page) AS "t165" ON "t164"."wr_web_page_sk" = "t165"."wp_web_page_sk"
GROUP BY "t165"."wp_web_page_sk") AS "t168" ON "t159"."wp_web_page_sk" = "t168"."wp_web_page_sk") AS "t170"
GROUP BY "channel", "id") AS "t175"
ORDER BY "channel" NULLS FIRST, "id" NULLS FIRST
LIMIT 100

