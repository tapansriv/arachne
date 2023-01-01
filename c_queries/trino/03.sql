SELECT "t3"."d_year", "t6"."i_brand_id" AS "brand_id", "t6"."i_brand" AS "brand", SUM("t3"."ss_ext_sales_price") AS "sum_agg"
FROM (SELECT "t1"."d_year", "t2"."ss_item_sk", "t2"."ss_ext_sales_price"
FROM (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_moy" = 11) AS "t1"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ext_sales_price"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t2" ON "t1"."d_date_sk" = "t2"."ss_sold_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_brand"
FROM tpcds.sf1000.item AS item
WHERE "i_manufact_id" = 128) AS "t6" ON "t3"."ss_item_sk" = "t6"."i_item_sk"
GROUP BY "t3"."d_year", "t6"."i_brand", "t6"."i_brand_id"
ORDER BY "t3"."d_year" IS NULL, "t3"."d_year", SUM("t3"."ss_ext_sales_price") DESC, "t6"."i_brand_id" IS NULL, "t6"."i_brand_id"
LIMIT 100

