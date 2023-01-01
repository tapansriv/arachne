CREATE TABLE duck_table_36_0 AS SELECT "t3"."ss_store_sk", "t3"."ss_ext_sales_price", "t3"."ss_net_profit", "t4"."i_class", "t4"."i_category"
FROM (SELECT "t"."ss_item_sk", "t"."ss_store_sk", "t"."ss_ext_sales_price", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_ext_sales_price", "ss_net_profit"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 2001) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t4" ON "t3"."ss_item_sk" = "t4"."i_item_sk"
;
SELECT "gross_margin", "i_category", "i_class", "lochierarchy", RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "t_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "gross_margin") AS "rank_within_parent", CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END
FROM (SELECT *
FROM (SELECT SUM("duck_table_36_0"."ss_net_profit") * 1.0000 / SUM("duck_table_36_0"."ss_ext_sales_price") AS "gross_margin", "duck_table_36_0"."i_category", "duck_table_36_0"."i_class", 0 AS "t_category", 0 AS "t_class", 0 AS "lochierarchy"
FROM "duck_table_36_0"
INNER JOIN (SELECT "s_store_sk"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store
WHERE "s_state" = 'TN') AS "t1" ON "duck_table_36_0"."ss_store_sk" = "t1"."s_store_sk"
GROUP BY "duck_table_36_0"."i_category", "duck_table_36_0"."i_class"
UNION
SELECT SUM("t10"."ss_net_profit") * 1.0000 / SUM("t10"."ss_ext_sales_price") AS "gross_margin", "t10"."i_category", NULL AS "i_class", 0 AS "t_category", 1 AS "t_class", 1 AS "lochierarchy"
FROM (SELECT "duck_table_36_00"."i_category", SUM("duck_table_36_00"."ss_net_profit") AS "ss_net_profit", SUM("duck_table_36_00"."ss_ext_sales_price") AS "ss_ext_sales_price"
FROM "duck_table_36_0" AS "duck_table_36_00"
INNER JOIN (SELECT "s_store_sk"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store
WHERE "s_state" = 'TN') AS "t7" ON "duck_table_36_00"."ss_store_sk" = "t7"."s_store_sk"
GROUP BY "duck_table_36_00"."i_category", "duck_table_36_00"."i_class") AS "t10"
GROUP BY "t10"."i_category") AS "t"
UNION
SELECT SUM("t19"."ss_net_profit") * 1.0000 / SUM("t19"."ss_ext_sales_price") AS "gross_margin", NULL AS "i_category", NULL AS "i_class", 1 AS "t_category", 1 AS "t_class", 2 AS "lochierarchy"
FROM (SELECT SUM("duck_table_36_01"."ss_net_profit") AS "ss_net_profit", SUM("duck_table_36_01"."ss_ext_sales_price") AS "ss_ext_sales_price"
FROM "duck_table_36_0" AS "duck_table_36_01"
INNER JOIN (SELECT "s_store_sk"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store
WHERE "s_state" = 'TN') AS "t16" ON "duck_table_36_01"."ss_store_sk" = "t16"."s_store_sk"
GROUP BY "duck_table_36_01"."i_category", "duck_table_36_01"."i_class") AS "t19") AS "t22"
ORDER BY "lochierarchy" DESC, CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END NULLS FIRST, RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "t_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "gross_margin") NULLS FIRST
FETCH NEXT 100 ROWS ONLY
;
