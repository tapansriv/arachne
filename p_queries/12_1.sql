CREATE TABLE duck_table_12_0 AS SELECT "t2"."i_item_id", "t2"."i_item_desc", "t2"."i_category", "t2"."i_class", "t2"."i_current_price", SUM("t2"."ws_ext_sales_price") AS "itemrevenue"
FROM (SELECT "t"."ws_sold_date_sk", "t"."ws_ext_sales_price", "t1"."i_item_id", "t1"."i_item_desc", "t1"."i_current_price", "t1"."i_class", "t1"."i_category"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_ext_sales_price"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t"
INNER JOIN (SELECT "i_item_sk", "i_item_id", "i_item_desc", "i_current_price", "i_class", "i_category"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_category" IN ('Books', 'Home', 'Sports')) AS "t1" ON "t"."ws_item_sk" = "t1"."i_item_sk") AS "t2"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_date" >= DATE '1999-02-22' AND "d_date" <= DATE '1999-03-24') AS "t5" ON "t2"."ws_sold_date_sk" = "t5"."d_date_sk"
GROUP BY "t2"."i_item_id", "t2"."i_item_desc", "t2"."i_category", "t2"."i_class", "t2"."i_current_price";
SELECT "i_item_id", "i_item_desc", "i_category", "i_class", "i_current_price", "itemrevenue", "itemrevenue" * 100.0000 / (SUM("itemrevenue") OVER (PARTITION BY "i_class" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) AS "revenueratio"
FROM "duck_table_12_0"
ORDER BY "i_category", "i_class", "i_item_id", "i_item_desc", "itemrevenue" * 100.0000 / (SUM("itemrevenue") OVER (PARTITION BY "i_class" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING))
FETCH NEXT 100 ROWS ONLY;
