CREATE TABLE rs_table_55_0 AS SELECT "i_item_sk", "i_brand_id", "i_brand"
FROM item
WHERE "i_manager_id" = 28
;
SELECT "rs_table_55_0"."i_brand_id" AS "brand_id", "rs_table_55_0"."i_brand" AS "brand", SUM("t3"."ss_ext_sales_price") AS "ext_price"
FROM (SELECT "t2"."ss_item_sk", "t2"."ss_ext_sales_price"
FROM (SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" = 11 AND "d_year" = 1999) AS "t1"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ext_sales_price"
FROM store_sales) AS "t2" ON "t1"."d_date_sk" = "t2"."ss_sold_date_sk") AS "t3"
INNER JOIN "rs_table_55_0" ON "t3"."ss_item_sk" = "rs_table_55_0"."i_item_sk"
GROUP BY "rs_table_55_0"."i_brand", "rs_table_55_0"."i_brand_id"
ORDER BY SUM("t3"."ss_ext_sales_price") DESC NULLS LAST, "rs_table_55_0"."i_brand_id"
LIMIT 100
;
