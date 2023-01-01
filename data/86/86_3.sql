CREATE TABLE duck_table_86_0 AS SELECT "t"."ws_item_sk", "t"."ws_net_paid"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_net_paid"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ws_sold_date_sk" = "t2"."d_date_sk"
;
SELECT "total_sum", "i_category", "i_class", "lochierarchy", RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "total_sum" DESC) AS "rank_within_parent", CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END
FROM (SELECT *
FROM (SELECT SUM("duck_table_86_0"."ws_net_paid") AS "total_sum", "t"."i_category", "t"."i_class", 0 AS "g_category", 0 AS "g_class", 0 AS "lochierarchy"
FROM "duck_table_86_0"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t" ON "duck_table_86_0"."ws_item_sk" = "t"."i_item_sk"
GROUP BY "t"."i_category", "t"."i_class"
UNION
SELECT SUM("t6"."total_sum") AS "total_sum", "t6"."i_category", NULL AS "i_class", 0 AS "g_category", 1 AS "g_class", 1 AS "lochierarchy"
FROM (SELECT "t3"."i_category", SUM("duck_table_86_00"."ws_net_paid") AS "total_sum"
FROM "duck_table_86_0" AS "duck_table_86_00"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t3" ON "duck_table_86_00"."ws_item_sk" = "t3"."i_item_sk"
GROUP BY "t3"."i_category", "t3"."i_class") AS "t6"
GROUP BY "t6"."i_category") AS "t"
UNION
SELECT SUM("t13"."total_sum") AS "total_sum", NULL AS "i_category", NULL AS "i_class", 1 AS "g_category", 1 AS "g_class", 2 AS "lochierarchy"
FROM (SELECT SUM("duck_table_86_01"."ws_net_paid") AS "total_sum"
FROM "duck_table_86_0" AS "duck_table_86_01"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t10" ON "duck_table_86_01"."ws_item_sk" = "t10"."i_item_sk"
GROUP BY "t10"."i_category", "t10"."i_class") AS "t13") AS "t16"
ORDER BY "lochierarchy" DESC, CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END NULLS FIRST, RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "total_sum" DESC) NULLS FIRST
FETCH NEXT 100 ROWS ONLY
;
