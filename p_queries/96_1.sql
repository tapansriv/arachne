CREATE TABLE duck_table_96_0 AS SELECT *
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales
INNER JOIN (SELECT *
FROM '/mnt/disks/tpcds/parquet/household_demographics.parquet' AS household_demographics
WHERE "hd_dep_count" = 7) AS "t" ON "store_sales"."ss_hdemo_sk" = "t"."hd_demo_sk"
INNER JOIN (SELECT *
FROM '/mnt/disks/tpcds/parquet/time_dim.parquet' AS time_dim
WHERE "t_hour" = 20 AND "t_minute" >= 30) AS "t0" ON "store_sales"."ss_sold_time_sk" = "t0"."t_time_sk"
INNER JOIN (SELECT *
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store
WHERE "s_store_name" = 'ese') AS "t1" ON "store_sales"."ss_store_sk" = "t1"."s_store_sk";
SELECT COUNT(*)
FROM "duck_table_96_0"
ORDER BY COUNT(*)
FETCH NEXT 100 ROWS ONLY;
