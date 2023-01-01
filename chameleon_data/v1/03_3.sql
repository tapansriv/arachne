CREATE TABLE duck_table_03_0 AS SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ext_sales_price"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales
;
SELECT "t2"."d_year", "t5"."i_brand_id" AS "brand_id", "t5"."i_brand" AS "brand", SUM("t2"."ss_ext_sales_price") AS "sum_agg"
FROM (SELECT "t1"."d_year", "duck_table_03_0"."ss_item_sk", "duck_table_03_0"."ss_ext_sales_price"
FROM (SELECT "d_date_sk", "d_year"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_moy" = 11) AS "t1"
INNER JOIN "duck_table_03_0" ON "t1"."d_date_sk" = "duck_table_03_0"."ss_sold_date_sk") AS "t2"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_brand"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_manufact_id" = 128) AS "t5" ON "t2"."ss_item_sk" = "t5"."i_item_sk"
GROUP BY "t2"."d_year", "t5"."i_brand", "t5"."i_brand_id"
ORDER BY "t2"."d_year", SUM("t2"."ss_ext_sales_price") DESC NULLS LAST, "t5"."i_brand_id"
FETCH NEXT 100 ROWS ONLY
;
