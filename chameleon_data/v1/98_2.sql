CREATE TABLE duck_table_98_0 AS SELECT "t2"."i_item_id", "t2"."i_item_desc", "t2"."i_category", "t2"."i_class", "t2"."i_current_price", "t2"."ss_ext_sales_price"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_ext_sales_price", "t1"."i_item_id", "t1"."i_item_desc", "t1"."i_current_price", "t1"."i_class", "t1"."i_category"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ext_sales_price"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "i_item_sk", "i_item_id", "i_item_desc", "i_current_price", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_category" IN ('Books', 'Home', 'Sports')) AS "t1" ON "t"."ss_item_sk" = "t1"."i_item_sk") AS "t2"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_date" >= DATE '1999-02-22' AND "d_date" <= DATE '1999-03-24') AS "t5" ON "t2"."ss_sold_date_sk" = "t5"."d_date_sk"
;
SELECT "i_item_id", "i_item_desc", "i_category", "i_class", "i_current_price", SUM("ss_ext_sales_price") AS "itemrevenue", SUM("ss_ext_sales_price") * 100.0000 / (SUM(SUM("ss_ext_sales_price")) OVER (PARTITION BY "i_class" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) AS "revenueratio"
FROM "duck_table_98_0"
GROUP BY "i_item_id", "i_item_desc", "i_category", "i_class", "i_current_price"
ORDER BY "i_category" NULLS FIRST, "i_class" NULLS FIRST, "i_item_id" NULLS FIRST, "i_item_desc" NULLS FIRST, SUM("ss_ext_sales_price") * 100.0000 / (SUM(SUM("ss_ext_sales_price")) OVER (PARTITION BY "i_class" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) NULLS FIRST
;
