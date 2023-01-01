CREATE TABLE rs_table_55_0 AS SELECT "t2"."ss_item_sk", "t2"."ss_ext_sales_price"
FROM (SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" = 11 AND "d_year" = 1999) AS "t1"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ext_sales_price"
FROM store_sales) AS "t2" ON "t1"."d_date_sk" = "t2"."ss_sold_date_sk"
;
SELECT "t1"."i_brand_id" AS "brand_id", "t1"."i_brand" AS "brand", SUM("rs_table_55_0"."ss_ext_sales_price") AS "ext_price"
FROM "rs_table_55_0"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_brand"
FROM item
WHERE "i_manager_id" = 28) AS "t1" ON "rs_table_55_0"."ss_item_sk" = "t1"."i_item_sk"
GROUP BY "t1"."i_brand", "t1"."i_brand_id"
ORDER BY SUM("rs_table_55_0"."ss_ext_sales_price") DESC NULLS LAST, "t1"."i_brand_id"
LIMIT 100
;
