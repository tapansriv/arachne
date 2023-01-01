CREATE TABLE duck_table_55_0 AS SELECT "t6"."i_brand" AS "brand", "t6"."i_brand_id" AS "brand_id", "t3"."ss_ext_sales_price"
FROM (SELECT "t2"."ss_item_sk", "t2"."ss_ext_sales_price"
FROM (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_moy" = 11 AND "d_year" = 1999) AS "t1"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ext_sales_price"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t2" ON "t1"."d_date_sk" = "t2"."ss_sold_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_brand"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_manager_id" = 28) AS "t6" ON "t3"."ss_item_sk" = "t6"."i_item_sk" ;
SELECT "brand_id", "brand", SUM("ss_ext_sales_price") AS "ext_price"
FROM "duck_table_55_0"
GROUP BY "brand", "brand_id"
ORDER BY SUM("ss_ext_sales_price") DESC NULLS LAST, "brand_id"
FETCH NEXT 100 ROWS ONLY;
