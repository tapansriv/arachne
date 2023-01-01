CREATE TABLE duck_table_70_0 AS SELECT "t12"."s_state", "t12"."s_county", SUM("t3"."ss_net_profit") AS "total_sum"
FROM (SELECT "t"."ss_store_sk", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_net_profit"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "store"."s_store_sk", "store"."s_county", "store"."s_state"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store
INNER JOIN (SELECT "s_state"
FROM (SELECT "t7"."s_state", RANK() OVER (PARTITION BY "t7"."s_state" ORDER BY "t7"."$f1" DESC) AS "ranking"
FROM (SELECT "store0"."s_state", SUM("store_sales0"."ss_net_profit") AS "$f1"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS "store_sales0",
'/mnt/disks/tpcds/parquet/store.parquet' AS "store0",
'/mnt/disks/tpcds/parquet/date_dim.parquet' AS "date_dim0"
WHERE "date_dim0"."d_month_seq" >= 1200 AND "date_dim0"."d_month_seq" <= 1200 + 11 AND "date_dim0"."d_date_sk" = "store_sales0"."ss_sold_date_sk" AND "store0"."s_store_sk" = "store_sales0"."ss_store_sk"
GROUP BY "store0"."s_state") AS "t7") AS "t8"
WHERE "ranking" <= 5) AS "t10" ON "store"."s_state" = "t10"."s_state") AS "t12" ON "t3"."ss_store_sk" = "t12"."s_store_sk"
GROUP BY "t12"."s_state", "t12"."s_county";
CREATE TABLE duck_table_70_1 AS SELECT *
FROM (SELECT "total_sum", "s_state", "s_county", 0 AS "g_state", 0 AS "g_county", 0 AS "lochierarchy"
FROM "duck_table_70_0"
UNION
SELECT SUM("total_sum") AS "total_sum", "s_state", NULL AS "s_county", 0 AS "g_state", 1 AS "g_county", 1 AS "lochierarchy"
FROM "duck_table_70_0"
GROUP BY "s_state") AS "t"
UNION
SELECT SUM("total_sum") AS "total_sum", NULL AS "s_state", NULL AS "s_county", 1 AS "g_state", 1 AS "g_county", 2 AS "lochierarchy"
FROM "duck_table_70_0";
SELECT "total_sum", "s_state", "s_county", "lochierarchy", RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_county" = 0 THEN "s_state" ELSE NULL END ORDER BY "total_sum" DESC) AS "rank_within_parent", CASE WHEN "lochierarchy" = 0 THEN "s_state" ELSE NULL END
FROM "duck_table_70_1"
ORDER BY "lochierarchy" DESC NULLS LAST, CASE WHEN "lochierarchy" = 0 THEN "s_state" ELSE NULL END, RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "g_county" = 0 THEN "s_state" ELSE NULL END ORDER BY "total_sum" DESC)
FETCH NEXT 100 ROWS ONLY;
