CREATE TABLE rs_table_26_0 AS SELECT "t9"."i_item_id", "t9"."cs_quantity", "t9"."cs_list_price", "t9"."cs_coupon_amt", "t9"."cs_sales_price"
FROM (SELECT "t7"."cs_promo_sk", "t7"."cs_quantity", "t7"."cs_list_price", "t7"."cs_sales_price", "t7"."cs_coupon_amt", "t8"."i_item_id"
FROM (SELECT "t3"."cs_item_sk", "t3"."cs_promo_sk", "t3"."cs_quantity", "t3"."cs_list_price", "t3"."cs_sales_price", "t3"."cs_coupon_amt"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_item_sk", "t"."cs_promo_sk", "t"."cs_quantity", "t"."cs_list_price", "t"."cs_sales_price", "t"."cs_coupon_amt"
FROM (SELECT "cs_sold_date_sk", "cs_bill_cdemo_sk", "cs_item_sk", "cs_promo_sk", "cs_quantity", "cs_list_price", "cs_sales_price", "cs_coupon_amt"
FROM catalog_sales) AS "t"
INNER JOIN (SELECT "cd_demo_sk"
FROM customer_demographics
WHERE "cd_gender" = 'M' AND "cd_marital_status" = 'S' AND "cd_education_status" = 'College') AS "t2" ON "t"."cs_bill_cdemo_sk" = "t2"."cd_demo_sk") AS "t3"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2000) AS "t6" ON "t3"."cs_sold_date_sk" = "t6"."d_date_sk") AS "t7"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t8" ON "t7"."cs_item_sk" = "t8"."i_item_sk") AS "t9"
INNER JOIN (SELECT "p_promo_sk"
FROM promotion
WHERE "p_channel_email" = 'N' OR "p_channel_event" = 'N') AS "t12" ON "t9"."cs_promo_sk" = "t12"."p_promo_sk"
;
SELECT "i_item_id", AVG("cs_quantity") AS "agg1", AVG("cs_list_price") AS "agg2", AVG("cs_coupon_amt") AS "agg3", AVG("cs_sales_price") AS "agg4"
FROM "rs_table_26_0"
GROUP BY "i_item_id"
ORDER BY "i_item_id"
LIMIT 100
;
