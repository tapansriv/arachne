SELECT "total_sum", "s_state", "s_county", "lochierarchy", RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_county" = 0 THEN "s_state" ELSE NULL END ORDER BY "total_sum" IS NULL DESC, "total_sum" DESC) AS "rank_within_parent", CASE WHEN "lochierarchy" = 0 THEN "s_state" ELSE NULL END
FROM (SELECT *
FROM (SELECT SUM("t3"."ss_net_profit") AS "total_sum", "t12"."s_state", "t12"."s_county", 0 AS "g_state", 0 AS "g_county", 0 AS "lochierarchy"
FROM (SELECT "t"."ss_store_sk", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_net_profit"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "store"."s_store_sk", "store"."s_county", "store"."s_state"
FROM store
INNER JOIN (SELECT "s_state"
FROM (SELECT "t7"."s_state", RANK() OVER (PARTITION BY "t7"."s_state" ORDER BY "t7"."$f1" IS NULL DESC, "t7"."$f1" DESC) AS "ranking"
FROM (SELECT "store0"."s_state", SUM("store_sales0"."ss_net_profit") AS "$f1"
FROM store_sales AS "store_sales0",
store AS "store0",
date_dim AS "date_dim0"
WHERE "date_dim0"."d_month_seq" >= 1200 AND "date_dim0"."d_month_seq" <= 1200 + 11 AND "date_dim0"."d_date_sk" = "store_sales0"."ss_sold_date_sk" AND "store0"."s_store_sk" = "store_sales0"."ss_store_sk"
GROUP BY "store0"."s_state") AS "t7") AS "t8"
WHERE "ranking" <= 5) AS "t10" ON "store"."s_state" = "t10"."s_state") AS "t12" ON "t3"."ss_store_sk" = "t12"."s_store_sk"
GROUP BY "t12"."s_state", "t12"."s_county"
UNION
SELECT SUM("t32"."total_sum") AS "total_sum", "t32"."s_state", NULL AS "s_county", 0 AS "g_state", 1 AS "g_county", 1 AS "lochierarchy"
FROM (SELECT "t29"."s_state", SUM("t20"."ss_net_profit") AS "total_sum"
FROM (SELECT "t16"."ss_store_sk", "t16"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_net_profit"
FROM store_sales) AS "t16"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t19" ON "t16"."ss_sold_date_sk" = "t19"."d_date_sk") AS "t20"
INNER JOIN (SELECT "store1"."s_store_sk", "store1"."s_county", "store1"."s_state"
FROM store AS "store1"
INNER JOIN (SELECT "s_state"
FROM (SELECT "t24"."s_state", RANK() OVER (PARTITION BY "t24"."s_state" ORDER BY "t24"."$f1" IS NULL DESC, "t24"."$f1" DESC) AS "ranking"
FROM (SELECT "store2"."s_state", SUM("store_sales2"."ss_net_profit") AS "$f1"
FROM store_sales AS "store_sales2",
store AS "store2",
date_dim AS "date_dim2"
WHERE "date_dim2"."d_month_seq" >= 1200 AND "date_dim2"."d_month_seq" <= 1200 + 11 AND "date_dim2"."d_date_sk" = "store_sales2"."ss_sold_date_sk" AND "store2"."s_store_sk" = "store_sales2"."ss_store_sk"
GROUP BY "store2"."s_state") AS "t24") AS "t25"
WHERE "ranking" <= 5) AS "t27" ON "store1"."s_state" = "t27"."s_state") AS "t29" ON "t20"."ss_store_sk" = "t29"."s_store_sk"
GROUP BY "t29"."s_state", "t29"."s_county") AS "t32"
GROUP BY "t32"."s_state") AS "t"
UNION
SELECT SUM("t52"."total_sum") AS "total_sum", NULL AS "s_state", NULL AS "s_county", 1 AS "g_state", 1 AS "g_county", 2 AS "lochierarchy"
FROM (SELECT SUM("t40"."ss_net_profit") AS "total_sum"
FROM (SELECT "t36"."ss_store_sk", "t36"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_net_profit"
FROM store_sales) AS "t36"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t39" ON "t36"."ss_sold_date_sk" = "t39"."d_date_sk") AS "t40"
INNER JOIN (SELECT "store3"."s_store_sk", "store3"."s_county", "store3"."s_state"
FROM store AS "store3"
INNER JOIN (SELECT "s_state"
FROM (SELECT "t44"."s_state", RANK() OVER (PARTITION BY "t44"."s_state" ORDER BY "t44"."$f1" IS NULL DESC, "t44"."$f1" DESC) AS "ranking"
FROM (SELECT "store4"."s_state", SUM("store_sales4"."ss_net_profit") AS "$f1"
FROM store_sales AS "store_sales4",
store AS "store4",
date_dim AS "date_dim4"
WHERE "date_dim4"."d_month_seq" >= 1200 AND "date_dim4"."d_month_seq" <= 1200 + 11 AND "date_dim4"."d_date_sk" = "store_sales4"."ss_sold_date_sk" AND "store4"."s_store_sk" = "store_sales4"."ss_store_sk"
GROUP BY "store4"."s_state") AS "t44") AS "t45"
WHERE "ranking" <= 5) AS "t47" ON "store3"."s_state" = "t47"."s_state") AS "t49" ON "t40"."ss_store_sk" = "t49"."s_store_sk"
GROUP BY "t49"."s_state", "t49"."s_county") AS "t52") AS "t55"
ORDER BY "lochierarchy" DESC, CASE WHEN "lochierarchy" = 0 THEN "s_state" ELSE NULL END IS NULL, CASE WHEN "lochierarchy" = 0 THEN "s_state" ELSE NULL END, (RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_county" = 0 THEN "s_state" ELSE NULL END ORDER BY "total_sum" IS NULL DESC, "total_sum" DESC)) IS NULL, RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_county" = 0 THEN "s_state" ELSE NULL END ORDER BY "total_sum" IS NULL DESC, "total_sum" DESC)
LIMIT 100
;
