SELECT "t3"."d_year", "t6"."i_category_id", "t6"."i_category", SUM("t3"."ss_ext_sales_price")
FROM (SELECT "t1"."d_year", "t2"."ss_item_sk", "t2"."ss_ext_sales_price"
FROM (SELECT "d_date_sk", "d_year"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_moy" = 11 AND "d_year" = 2000) AS "t1"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ext_sales_price"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t2" ON "t1"."d_date_sk" = "t2"."ss_sold_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_category_id", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_manager_id" = 1) AS "t6" ON "t3"."ss_item_sk" = "t6"."i_item_sk"
GROUP BY "t3"."d_year", "t6"."i_category_id", "t6"."i_category"
ORDER BY SUM("t3"."ss_ext_sales_price") DESC NULLS LAST, "t3"."d_year", "t6"."i_category_id", "t6"."i_category"
FETCH NEXT 100 ROWS ONLY

