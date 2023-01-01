CREATE TABLE duck_table_86_0 AS SELECT "t"."ws_sold_date_sk", "t"."ws_item_sk", "t"."ws_net_paid", "t2"."d_date_sk"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_net_paid"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ws_sold_date_sk" = "t2"."d_date_sk"
;
SELECT "total_sum", "i_category", "i_class", "lochierarchy", RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "total_sum" DESC) AS "rank_within_parent", CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END
FROM (SELECT *
FROM (SELECT SUM("t"."ws_net_paid") AS "total_sum", "t0"."i_category", "t0"."i_class", 0 AS "g_category", 0 AS "g_class", 0 AS "lochierarchy"
FROM (SELECT "ws_item_sk", "ws_net_paid"
FROM "duck_table_86_0") AS "t"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t0" ON "t"."ws_item_sk" = "t0"."i_item_sk"
GROUP BY "t0"."i_category", "t0"."i_class"
UNION
SELECT SUM("t8"."total_sum") AS "total_sum", "t8"."i_category", NULL AS "i_class", 0 AS "g_category", 1 AS "g_class", 1 AS "lochierarchy"
FROM (SELECT "t5"."i_category", SUM("t4"."ws_net_paid") AS "total_sum"
FROM (SELECT "ws_item_sk", "ws_net_paid"
FROM "duck_table_86_0") AS "t4"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t5" ON "t4"."ws_item_sk" = "t5"."i_item_sk"
GROUP BY "t5"."i_category", "t5"."i_class") AS "t8"
GROUP BY "t8"."i_category") AS "t"
UNION
SELECT SUM("t16"."total_sum") AS "total_sum", NULL AS "i_category", NULL AS "i_class", 1 AS "g_category", 1 AS "g_class", 2 AS "lochierarchy"
FROM (SELECT SUM("t12"."ws_net_paid") AS "total_sum"
FROM (SELECT "ws_item_sk", "ws_net_paid"
FROM "duck_table_86_0") AS "t12"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t13" ON "t12"."ws_item_sk" = "t13"."i_item_sk"
GROUP BY "t13"."i_category", "t13"."i_class") AS "t16") AS "t19"
ORDER BY "lochierarchy" DESC, CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END NULLS FIRST, RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "total_sum" DESC) NULLS FIRST
FETCH NEXT 100 ROWS ONLY
;
