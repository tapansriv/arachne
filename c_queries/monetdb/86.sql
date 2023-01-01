SELECT "total_sum", "i_category", "i_class", "lochierarchy", RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "total_sum" IS NULL DESC, "total_sum" DESC) AS "rank_within_parent", CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END
FROM (SELECT *
FROM (SELECT SUM("t3"."ws_net_paid") AS "total_sum", "t4"."i_category", "t4"."i_class", 0 AS "g_category", 0 AS "g_class", 0 AS "lochierarchy"
FROM (SELECT "t"."ws_item_sk", "t"."ws_net_paid"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_net_paid"
FROM web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ws_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM item) AS "t4" ON "t3"."ws_item_sk" = "t4"."i_item_sk"
GROUP BY "t4"."i_category", "t4"."i_class"
UNION
SELECT SUM("t16"."total_sum") AS "total_sum", "t16"."i_category", NULL AS "i_class", 0 AS "g_category", 1 AS "g_class", 1 AS "lochierarchy"
FROM (SELECT "t13"."i_category", SUM("t12"."ws_net_paid") AS "total_sum"
FROM (SELECT "t8"."ws_item_sk", "t8"."ws_net_paid"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_net_paid"
FROM web_sales) AS "t8"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t11" ON "t8"."ws_sold_date_sk" = "t11"."d_date_sk") AS "t12"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM item) AS "t13" ON "t12"."ws_item_sk" = "t13"."i_item_sk"
GROUP BY "t13"."i_category", "t13"."i_class") AS "t16"
GROUP BY "t16"."i_category") AS "t"
UNION
SELECT SUM("t28"."total_sum") AS "total_sum", NULL AS "i_category", NULL AS "i_class", 1 AS "g_category", 1 AS "g_class", 2 AS "lochierarchy"
FROM (SELECT SUM("t24"."ws_net_paid") AS "total_sum"
FROM (SELECT "t20"."ws_item_sk", "t20"."ws_net_paid"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_net_paid"
FROM web_sales) AS "t20"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t23" ON "t20"."ws_sold_date_sk" = "t23"."d_date_sk") AS "t24"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM item) AS "t25" ON "t24"."ws_item_sk" = "t25"."i_item_sk"
GROUP BY "t25"."i_category", "t25"."i_class") AS "t28") AS "t31"
ORDER BY "lochierarchy" IS NULL DESC, "lochierarchy" DESC, CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END, RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "total_sum" IS NULL DESC, "total_sum" DESC)
LIMIT 100
;
