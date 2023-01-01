CREATE TABLE rs_table_42_0 AS SELECT "t3"."d_year", "t6"."i_category_id", "t6"."i_category", "t3"."ss_ext_sales_price"
FROM (SELECT "t1"."d_year", "t2"."ss_item_sk", "t2"."ss_ext_sales_price"
FROM (SELECT "d_date_sk", "d_year"
FROM date_dim
WHERE "d_moy" = 11 AND "d_year" = 2000) AS "t1"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ext_sales_price"
FROM store_sales) AS "t2" ON "t1"."d_date_sk" = "t2"."ss_sold_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_category_id", "i_category"
FROM item
WHERE "i_manager_id" = 1) AS "t6" ON "t3"."ss_item_sk" = "t6"."i_item_sk"
;
SELECT "d_year", "i_category_id", "i_category", SUM("ss_ext_sales_price")
FROM "rs_table_42_0"
GROUP BY "d_year", "i_category_id", "i_category"
ORDER BY SUM("ss_ext_sales_price") DESC NULLS LAST, "d_year", "i_category_id", "i_category"
LIMIT 100
;
