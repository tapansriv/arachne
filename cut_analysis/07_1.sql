CREATE TABLE duck_table_07_0 AS SELECT "t9"."i_item_id", "t9"."ss_quantity", "t9"."ss_list_price", "t9"."ss_coupon_amt", "t9"."ss_sales_price"
FROM (SELECT "t7"."ss_promo_sk", "t7"."ss_quantity", "t7"."ss_list_price", "t7"."ss_sales_price", "t7"."ss_coupon_amt", "t8"."i_item_id"
FROM (SELECT "t3"."ss_item_sk", "t3"."ss_promo_sk", "t3"."ss_quantity", "t3"."ss_list_price", "t3"."ss_sales_price", "t3"."ss_coupon_amt"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_item_sk", "t"."ss_promo_sk", "t"."ss_quantity", "t"."ss_list_price", "t"."ss_sales_price", "t"."ss_coupon_amt"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_cdemo_sk", "ss_promo_sk", "ss_quantity", "ss_list_price", "ss_sales_price", "ss_coupon_amt"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "cd_demo_sk"
FROM '/mnt/disks/tpcds/parquet/customer_demographics.parquet' AS customer_demographics
WHERE "cd_gender" = 'M' AND "cd_marital_status" = 'S' AND "cd_education_status" = 'College') AS "t2" ON "t"."ss_cdemo_sk" = "t2"."cd_demo_sk") AS "t3"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 2000) AS "t6" ON "t3"."ss_sold_date_sk" = "t6"."d_date_sk") AS "t7"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t8" ON "t7"."ss_item_sk" = "t8"."i_item_sk") AS "t9"
INNER JOIN (SELECT "p_promo_sk"
FROM '/mnt/disks/tpcds/parquet/promotion.parquet' AS promotion
WHERE "p_channel_email" = 'N' OR "p_channel_event" = 'N') AS "t12" ON "t9"."ss_promo_sk" = "t12"."p_promo_sk"
;
SELECT "i_item_id", AVG("ss_quantity") AS "agg1", AVG("ss_list_price") AS "agg2", AVG("ss_coupon_amt") AS "agg3", AVG("ss_sales_price") AS "agg4"
FROM "duck_table_07_0"
GROUP BY "i_item_id"
ORDER BY "i_item_id"
FETCH NEXT 100 ROWS ONLY
;
