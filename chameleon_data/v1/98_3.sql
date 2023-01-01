CREATE TABLE duck_table_98_0 AS SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ext_sales_price"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales
;
SELECT "t6"."i_item_id", "t6"."i_item_desc", "t6"."i_category", "t6"."i_class", "t6"."i_current_price", "t6"."itemrevenue", "t6"."itemrevenue" * 100.0000 / (SUM("t6"."itemrevenue") OVER (PARTITION BY "t6"."i_class" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) AS "revenueratio"
FROM (SELECT "t1"."i_item_id", "t1"."i_item_desc", "t1"."i_category", "t1"."i_class", "t1"."i_current_price", SUM("t1"."ss_ext_sales_price") AS "itemrevenue"
FROM (SELECT "duck_table_98_0"."ss_sold_date_sk", "duck_table_98_0"."ss_ext_sales_price", "t0"."i_item_id", "t0"."i_item_desc", "t0"."i_current_price", "t0"."i_class", "t0"."i_category"
FROM "duck_table_98_0"
INNER JOIN (SELECT "i_item_sk", "i_item_id", "i_item_desc", "i_current_price", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_category" IN ('Books', 'Home', 'Sports')) AS "t0" ON "duck_table_98_0"."ss_item_sk" = "t0"."i_item_sk") AS "t1"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_date" >= DATE '1999-02-22' AND "d_date" <= DATE '1999-03-24') AS "t4" ON "t1"."ss_sold_date_sk" = "t4"."d_date_sk"
GROUP BY "t1"."i_item_id", "t1"."i_item_desc", "t1"."i_category", "t1"."i_class", "t1"."i_current_price") AS "t6"
ORDER BY "t6"."i_category" NULLS FIRST, "t6"."i_class" NULLS FIRST, "t6"."i_item_id" NULLS FIRST, "t6"."i_item_desc" NULLS FIRST, "t6"."itemrevenue" * 100.0000 / (SUM("t6"."itemrevenue") OVER (PARTITION BY "t6"."i_class" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) NULLS FIRST
;
