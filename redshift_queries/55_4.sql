CREATE TABLE rs_table_55_0 AS SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" = 11 AND "d_year" = 1999
;
SELECT "t3"."i_brand_id" AS "brand_id", "t3"."i_brand" AS "brand", SUM("t0"."ss_ext_sales_price") AS "ext_price"
FROM (SELECT "t"."ss_item_sk", "t"."ss_ext_sales_price"
FROM "rs_table_55_0"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ext_sales_price"
FROM store_sales) AS "t" ON "rs_table_55_0"."d_date_sk" = "t"."ss_sold_date_sk") AS "t0"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_brand"
FROM item
WHERE "i_manager_id" = 28) AS "t3" ON "t0"."ss_item_sk" = "t3"."i_item_sk"
GROUP BY "t3"."i_brand", "t3"."i_brand_id"
ORDER BY SUM("t0"."ss_ext_sales_price") DESC NULLS LAST, "t3"."i_brand_id"
LIMIT 100
;
