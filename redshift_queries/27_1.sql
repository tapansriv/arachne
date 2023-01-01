CREATE TABLE rs_table_27_0 AS SELECT "t11"."ss_quantity" AS "agg1", "t11"."ss_list_price" AS "agg2", "t11"."ss_coupon_amt" AS "agg3", "t11"."ss_sales_price" AS "agg4"
FROM (SELECT "t7"."ss_item_sk", "t7"."ss_quantity", "t7"."ss_list_price", "t7"."ss_sales_price", "t7"."ss_coupon_amt"
FROM (SELECT "t3"."ss_item_sk", "t3"."ss_store_sk", "t3"."ss_quantity", "t3"."ss_list_price", "t3"."ss_sales_price", "t3"."ss_coupon_amt"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_item_sk", "t"."ss_store_sk", "t"."ss_quantity", "t"."ss_list_price", "t"."ss_sales_price", "t"."ss_coupon_amt"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_cdemo_sk", "ss_store_sk", "ss_quantity", "ss_list_price", "ss_sales_price", "ss_coupon_amt"
FROM store_sales) AS "t"
INNER JOIN (SELECT "cd_demo_sk"
FROM customer_demographics
WHERE "cd_gender" = 'M' AND "cd_marital_status" = 'S' AND "cd_education_status" = 'College') AS "t2" ON "t"."ss_cdemo_sk" = "t2"."cd_demo_sk") AS "t3"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2002) AS "t6" ON "t3"."ss_sold_date_sk" = "t6"."d_date_sk") AS "t7"
INNER JOIN (SELECT "s_store_sk"
FROM store
WHERE "s_state" = 'TN') AS "t10" ON "t7"."ss_store_sk" = "t10"."s_store_sk") AS "t11"
INNER JOIN (SELECT "i_item_sk"
FROM item) AS "t12" ON "t11"."ss_item_sk" = "t12"."i_item_sk"
;
SELECT *
FROM (SELECT *
FROM (SELECT "t11"."i_item_id", "t10"."s_state", 0 AS "g_state", AVG("t10"."ss_quantity") AS "agg1", AVG("t10"."ss_list_price") AS "agg2", AVG("t10"."ss_coupon_amt") AS "agg3", AVG("t10"."ss_sales_price") AS "agg4"
FROM (SELECT "t7"."ss_item_sk", "t7"."ss_quantity", "t7"."ss_list_price", "t7"."ss_sales_price", "t7"."ss_coupon_amt", "t9"."s_state"
FROM (SELECT "t3"."ss_item_sk", "t3"."ss_store_sk", "t3"."ss_quantity", "t3"."ss_list_price", "t3"."ss_sales_price", "t3"."ss_coupon_amt"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_item_sk", "t"."ss_store_sk", "t"."ss_quantity", "t"."ss_list_price", "t"."ss_sales_price", "t"."ss_coupon_amt"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_cdemo_sk", "ss_store_sk", "ss_quantity", "ss_list_price", "ss_sales_price", "ss_coupon_amt"
FROM store_sales) AS "t"
INNER JOIN (SELECT "cd_demo_sk"
FROM customer_demographics
WHERE "cd_gender" = 'M' AND "cd_marital_status" = 'S' AND "cd_education_status" = 'College') AS "t2" ON "t"."ss_cdemo_sk" = "t2"."cd_demo_sk") AS "t3"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2002) AS "t6" ON "t3"."ss_sold_date_sk" = "t6"."d_date_sk") AS "t7"
INNER JOIN (SELECT "s_store_sk", "s_state"
FROM store
WHERE "s_state" = 'TN') AS "t9" ON "t7"."ss_store_sk" = "t9"."s_store_sk") AS "t10"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t11" ON "t10"."ss_item_sk" = "t11"."i_item_sk"
GROUP BY "t11"."i_item_id", "t10"."s_state"
UNION ALL
SELECT "t28"."i_item_id", NULL AS "s_state", 1 AS "g_state", AVG("t27"."ss_quantity") AS "agg1", AVG("t27"."ss_list_price") AS "agg2", AVG("t27"."ss_coupon_amt") AS "agg3", AVG("t27"."ss_sales_price") AS "agg4"
FROM (SELECT "t23"."ss_item_sk", "t23"."ss_quantity", "t23"."ss_list_price", "t23"."ss_sales_price", "t23"."ss_coupon_amt"
FROM (SELECT "t19"."ss_item_sk", "t19"."ss_store_sk", "t19"."ss_quantity", "t19"."ss_list_price", "t19"."ss_sales_price", "t19"."ss_coupon_amt"
FROM (SELECT "t15"."ss_sold_date_sk", "t15"."ss_item_sk", "t15"."ss_store_sk", "t15"."ss_quantity", "t15"."ss_list_price", "t15"."ss_sales_price", "t15"."ss_coupon_amt"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_cdemo_sk", "ss_store_sk", "ss_quantity", "ss_list_price", "ss_sales_price", "ss_coupon_amt"
FROM store_sales) AS "t15"
INNER JOIN (SELECT "cd_demo_sk"
FROM customer_demographics
WHERE "cd_gender" = 'M' AND "cd_marital_status" = 'S' AND "cd_education_status" = 'College') AS "t18" ON "t15"."ss_cdemo_sk" = "t18"."cd_demo_sk") AS "t19"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2002) AS "t22" ON "t19"."ss_sold_date_sk" = "t22"."d_date_sk") AS "t23"
INNER JOIN (SELECT "s_store_sk"
FROM store
WHERE "s_state" = 'TN') AS "t26" ON "t23"."ss_store_sk" = "t26"."s_store_sk") AS "t27"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t28" ON "t27"."ss_item_sk" = "t28"."i_item_sk"
GROUP BY "t28"."i_item_id")
UNION ALL
SELECT NULL AS "i_item_id", NULL AS "s_state", 1 AS "g_state", AVG("agg1") AS "agg1", AVG("agg2") AS "agg2", AVG("agg3") AS "agg3", AVG("agg4") AS "agg4"
FROM "rs_table_27_0") AS "t35"
ORDER BY "i_item_id" NULLS FIRST, "s_state" NULLS FIRST
LIMIT 100
;
