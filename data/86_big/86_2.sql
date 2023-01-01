CREATE TABLE duck_table_86_0 AS SELECT "t4"."i_category", "t4"."i_class", SUM("t3"."ws_net_paid") AS "total_sum"
FROM (SELECT "t"."ws_item_sk", "t"."ws_net_paid"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_net_paid"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ws_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t4" ON "t3"."ws_item_sk" = "t4"."i_item_sk"
GROUP BY "t4"."i_category", "t4"."i_class"
;
CREATE TABLE duck_table_86_1 AS SELECT "t4"."i_category", "t4"."i_class", SUM("t3"."ws_net_paid") AS "total_sum"
FROM (SELECT "t"."ws_item_sk", "t"."ws_net_paid"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_net_paid"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ws_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t4" ON "t3"."ws_item_sk" = "t4"."i_item_sk"
GROUP BY "t4"."i_category", "t4"."i_class"
;
SELECT "total_sum", "i_category", "i_class", "lochierarchy", RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "total_sum" DESC) AS "rank_within_parent", CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END
FROM (SELECT *
FROM (SELECT "total_sum", "i_category", "i_class", 0 AS "g_category", 0 AS "g_class", 0 AS "lochierarchy"
FROM "duck_table_86_1"
UNION
SELECT SUM("total_sum") AS "total_sum", "i_category", NULL AS "i_class", 0 AS "g_category", 1 AS "g_class", 1 AS "lochierarchy"
FROM "duck_table_86_1"
GROUP BY "i_category") AS "t"
UNION
SELECT SUM("total_sum") AS "total_sum", NULL AS "i_category", NULL AS "i_class", 1 AS "g_category", 1 AS "g_class", 2 AS "lochierarchy"
FROM "duck_table_86_1") AS "t7"
ORDER BY "lochierarchy" DESC, CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END NULLS FIRST, RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "total_sum" DESC) NULLS FIRST
FETCH NEXT 100 ROWS ONLY
;
