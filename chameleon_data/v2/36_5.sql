CREATE TABLE duck_table_36_0 AS SELECT "t"."ss_item_sk", "t"."ss_store_sk", "t"."ss_ext_sales_price", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_ext_sales_price", "ss_net_profit"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 2001) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk"
;
SELECT "gross_margin", "i_category", "i_class", "lochierarchy", RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "t_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "gross_margin") AS "rank_within_parent", CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END
FROM (SELECT *
FROM (SELECT SUM("t0"."ss_net_profit") * 1.0000 / SUM("t0"."ss_ext_sales_price") AS "gross_margin", "t0"."i_category", "t0"."i_class", 0 AS "t_category", 0 AS "t_class", 0 AS "lochierarchy"
FROM (SELECT "duck_table_36_0"."ss_store_sk", "duck_table_36_0"."ss_ext_sales_price", "duck_table_36_0"."ss_net_profit", "t"."i_class", "t"."i_category"
FROM "duck_table_36_0"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t" ON "duck_table_36_0"."ss_item_sk" = "t"."i_item_sk") AS "t0"
INNER JOIN (SELECT "s_store_sk"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store
WHERE "s_state" = 'TN') AS "t3" ON "t0"."ss_store_sk" = "t3"."s_store_sk"
GROUP BY "t0"."i_category", "t0"."i_class"
UNION
SELECT SUM("t14"."ss_net_profit") * 1.0000 / SUM("t14"."ss_ext_sales_price") AS "gross_margin", "t14"."i_category", NULL AS "i_class", 0 AS "t_category", 1 AS "t_class", 1 AS "lochierarchy"
FROM (SELECT "t8"."i_category", SUM("t8"."ss_net_profit") AS "ss_net_profit", SUM("t8"."ss_ext_sales_price") AS "ss_ext_sales_price"
FROM (SELECT "duck_table_36_00"."ss_store_sk", "duck_table_36_00"."ss_ext_sales_price", "duck_table_36_00"."ss_net_profit", "t7"."i_class", "t7"."i_category"
FROM "duck_table_36_0" AS "duck_table_36_00"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t7" ON "duck_table_36_00"."ss_item_sk" = "t7"."i_item_sk") AS "t8"
INNER JOIN (SELECT "s_store_sk"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store
WHERE "s_state" = 'TN') AS "t11" ON "t8"."ss_store_sk" = "t11"."s_store_sk"
GROUP BY "t8"."i_category", "t8"."i_class") AS "t14"
GROUP BY "t14"."i_category") AS "t"
UNION
SELECT SUM("t25"."ss_net_profit") * 1.0000 / SUM("t25"."ss_ext_sales_price") AS "gross_margin", NULL AS "i_category", NULL AS "i_class", 1 AS "t_category", 1 AS "t_class", 2 AS "lochierarchy"
FROM (SELECT SUM("t19"."ss_net_profit") AS "ss_net_profit", SUM("t19"."ss_ext_sales_price") AS "ss_ext_sales_price"
FROM (SELECT "duck_table_36_01"."ss_store_sk", "duck_table_36_01"."ss_ext_sales_price", "duck_table_36_01"."ss_net_profit", "t18"."i_class", "t18"."i_category"
FROM "duck_table_36_0" AS "duck_table_36_01"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t18" ON "duck_table_36_01"."ss_item_sk" = "t18"."i_item_sk") AS "t19"
INNER JOIN (SELECT "s_store_sk"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store
WHERE "s_state" = 'TN') AS "t22" ON "t19"."ss_store_sk" = "t22"."s_store_sk"
GROUP BY "t19"."i_category", "t19"."i_class") AS "t25") AS "t28"
ORDER BY "lochierarchy" DESC, CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END NULLS FIRST, RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "t_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "gross_margin") NULLS FIRST
FETCH NEXT 100 ROWS ONLY
;
