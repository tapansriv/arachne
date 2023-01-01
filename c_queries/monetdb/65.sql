SELECT "t"."s_store_name", "t0"."i_item_desc", "t16"."revenue", "t0"."i_current_price", "t0"."i_wholesale_cost", "t0"."i_brand"
FROM (SELECT "s_store_sk", "s_store_name"
FROM store) AS "t",
(SELECT "i_item_sk", "i_item_desc", "i_current_price", "i_wholesale_cost", "i_brand"
FROM item) AS "t0",
(SELECT "t7"."ss_store_sk", 0.1 * AVG("t7"."revenue") AS "*"
FROM (SELECT "t1"."ss_store_sk", SUM("t1"."ss_sales_price") AS "revenue"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t1"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1176 AND "d_month_seq" <= 1176 + 11) AS "t4" ON "t1"."ss_sold_date_sk" = "t4"."d_date_sk"
GROUP BY "t1"."ss_store_sk", "t1"."ss_item_sk") AS "t7"
GROUP BY "t7"."ss_store_sk") AS "t9"
INNER JOIN (SELECT "t10"."ss_store_sk", "t10"."ss_item_sk", SUM("t10"."ss_sales_price") AS "revenue"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t10"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1176 AND "d_month_seq" <= 1176 + 11) AS "t13" ON "t10"."ss_sold_date_sk" = "t13"."d_date_sk"
GROUP BY "t10"."ss_store_sk", "t10"."ss_item_sk") AS "t16" ON "t9"."ss_store_sk" = "t16"."ss_store_sk" AND "t9"."*" >= "t16"."revenue" AND "t"."s_store_sk" = "t16"."ss_store_sk" AND "t0"."i_item_sk" = "t16"."ss_item_sk"
ORDER BY "t"."s_store_name", "t0"."i_item_desc"
LIMIT 100
;
