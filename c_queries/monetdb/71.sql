SELECT "t19"."i_brand_id" AS "brand_id", "t19"."i_brand" AS "brand", "t22"."t_hour", "t22"."t_minute", SUM("t19"."ext_price") AS "ext_price"
FROM (SELECT "i_brand_id", "i_brand", "ext_price", "time_sk"
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM item
WHERE "i_manager_id" = 1) AS "t"
INNER JOIN (SELECT "t0"."ws_ext_sales_price" AS "ext_price", "t0"."ws_sold_date_sk" AS "sold_date_sk", "t0"."ws_item_sk" AS "sold_item_sk", "t0"."ws_sold_time_sk" AS "time_sk"
FROM (SELECT "ws_sold_date_sk", "ws_sold_time_sk", "ws_item_sk", "ws_ext_sales_price"
FROM web_sales) AS "t0"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" = 11 AND "d_year" = 1999) AS "t3" ON "t0"."ws_sold_date_sk" = "t3"."d_date_sk") AS "t4" ON "t"."i_item_sk" = "t4"."sold_item_sk"
UNION ALL
SELECT *
FROM (SELECT *
FROM item
WHERE "i_manager_id" = 1) AS "t5"
INNER JOIN (SELECT "t6"."cs_ext_sales_price" AS "ext_price", "t6"."cs_sold_date_sk" AS "sold_date_sk", "t6"."cs_item_sk" AS "sold_item_sk", "t6"."cs_sold_time_sk" AS "time_sk"
FROM (SELECT "cs_sold_date_sk", "cs_sold_time_sk", "cs_item_sk", "cs_ext_sales_price"
FROM catalog_sales) AS "t6"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" = 11 AND "d_year" = 1999) AS "t9" ON "t6"."cs_sold_date_sk" = "t9"."d_date_sk") AS "t10" ON "t5"."i_item_sk" = "t10"."sold_item_sk") AS "t"
UNION ALL
SELECT *
FROM (SELECT *
FROM item
WHERE "i_manager_id" = 1) AS "t12"
INNER JOIN (SELECT "t13"."ss_ext_sales_price" AS "ext_price", "t13"."ss_sold_date_sk" AS "sold_date_sk", "t13"."ss_item_sk" AS "sold_item_sk", "t13"."ss_sold_time_sk" AS "time_sk"
FROM (SELECT "ss_sold_date_sk", "ss_sold_time_sk", "ss_item_sk", "ss_ext_sales_price"
FROM store_sales) AS "t13"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" = 11 AND "d_year" = 1999) AS "t16" ON "t13"."ss_sold_date_sk" = "t16"."d_date_sk") AS "t17" ON "t12"."i_item_sk" = "t17"."sold_item_sk") AS "t18") AS "t19"
INNER JOIN (SELECT "t_time_sk", "t_hour", "t_minute"
FROM time_dim
WHERE "t_meal_time" IN ('breakfast', 'dinner')) AS "t22" ON "t19"."time_sk" = "t22"."t_time_sk"
GROUP BY "t19"."i_brand", "t19"."i_brand_id", "t22"."t_hour", "t22"."t_minute"
ORDER BY SUM("t19"."ext_price") IS NULL DESC, SUM("t19"."ext_price") DESC, "t19"."i_brand_id"
;
