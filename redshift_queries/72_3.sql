CREATE TABLE rs_table_72_0 AS SELECT "cr_item_sk", "cr_order_number"
FROM catalog_returns
;
SELECT "t23"."i_item_desc", "t23"."w_warehouse_name", "t23"."d_week_seq", SUM("t23"."CASE") AS "no_promo", SUM("t23"."CASE6") AS "promo", COUNT(*) AS "total_cnt"
FROM (SELECT "t21"."cs_item_sk", "t21"."cs_order_number", "t21"."w_warehouse_name", "t21"."i_item_desc", "t21"."d_week_seq", CASE WHEN "t22"."p_promo_sk" IS NULL THEN 1 ELSE 0 END AS "CASE", CASE WHEN "t22"."p_promo_sk" IS NOT NULL THEN 1 ELSE 0 END AS "CASE6"
FROM (SELECT "t19"."cs_item_sk", "t19"."cs_promo_sk", "t19"."cs_order_number", "t19"."w_warehouse_name", "t19"."i_item_desc", "t19"."d_week_seq"
FROM (SELECT "t17"."cs_ship_date_sk", "t17"."cs_item_sk", "t17"."cs_promo_sk", "t17"."cs_order_number", "t17"."w_warehouse_name", "t17"."i_item_desc", "t17"."d_week_seq", "t17"."+"
FROM (SELECT "t13"."cs_ship_date_sk", "t13"."cs_item_sk", "t13"."cs_promo_sk", "t13"."cs_order_number", "t13"."inv_date_sk", "t13"."w_warehouse_name", "t13"."i_item_desc", "t16"."d_week_seq", "t16"."+"
FROM (SELECT "t9"."cs_sold_date_sk", "t9"."cs_ship_date_sk", "t9"."cs_item_sk", "t9"."cs_promo_sk", "t9"."cs_order_number", "t9"."inv_date_sk", "t9"."w_warehouse_name", "t9"."i_item_desc"
FROM (SELECT "t5"."cs_sold_date_sk", "t5"."cs_ship_date_sk", "t5"."cs_bill_hdemo_sk", "t5"."cs_item_sk", "t5"."cs_promo_sk", "t5"."cs_order_number", "t5"."inv_date_sk", "t5"."w_warehouse_name", "t5"."i_item_desc"
FROM (SELECT "t3"."cs_sold_date_sk", "t3"."cs_ship_date_sk", "t3"."cs_bill_cdemo_sk", "t3"."cs_bill_hdemo_sk", "t3"."cs_item_sk", "t3"."cs_promo_sk", "t3"."cs_order_number", "t3"."inv_date_sk", "t3"."w_warehouse_name", "t4"."i_item_desc"
FROM (SELECT "t1"."cs_sold_date_sk", "t1"."cs_ship_date_sk", "t1"."cs_bill_cdemo_sk", "t1"."cs_bill_hdemo_sk", "t1"."cs_item_sk", "t1"."cs_promo_sk", "t1"."cs_order_number", "t1"."inv_date_sk", "t2"."w_warehouse_name"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_ship_date_sk", "t"."cs_bill_cdemo_sk", "t"."cs_bill_hdemo_sk", "t"."cs_item_sk", "t"."cs_promo_sk", "t"."cs_order_number", "t0"."inv_date_sk", "t0"."inv_warehouse_sk"
FROM (SELECT "cs_sold_date_sk", "cs_ship_date_sk", "cs_bill_cdemo_sk", "cs_bill_hdemo_sk", "cs_item_sk", "cs_promo_sk", "cs_order_number", "cs_quantity"
FROM catalog_sales) AS "t"
INNER JOIN (SELECT *
FROM inventory) AS "t0" ON "t"."cs_item_sk" = "t0"."inv_item_sk" AND "t"."cs_quantity" > "t0"."inv_quantity_on_hand") AS "t1"
INNER JOIN (SELECT "w_warehouse_sk", "w_warehouse_name"
FROM warehouse) AS "t2" ON "t1"."inv_warehouse_sk" = "t2"."w_warehouse_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_item_desc"
FROM item) AS "t4" ON "t3"."cs_item_sk" = "t4"."i_item_sk") AS "t5"
INNER JOIN (SELECT "cd_demo_sk"
FROM customer_demographics
WHERE "cd_marital_status" = 'D') AS "t8" ON "t5"."cs_bill_cdemo_sk" = "t8"."cd_demo_sk") AS "t9"
INNER JOIN (SELECT "hd_demo_sk"
FROM household_demographics
WHERE "hd_buy_potential" = '>10000') AS "t12" ON "t9"."cs_bill_hdemo_sk" = "t12"."hd_demo_sk") AS "t13"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", ("d_date" + 5 * INTERVAL '1' DAY) AS "+"
FROM date_dim
WHERE "d_year" = 1999) AS "t16" ON "t13"."cs_sold_date_sk" = "t16"."d_date_sk") AS "t17"
INNER JOIN (SELECT "d_date_sk", "d_week_seq"
FROM date_dim) AS "t18" ON "t17"."inv_date_sk" = "t18"."d_date_sk" AND "t17"."d_week_seq" = "t18"."d_week_seq") AS "t19"
INNER JOIN (SELECT "d_date_sk", "d_date"
FROM date_dim) AS "t20" ON "t19"."cs_ship_date_sk" = "t20"."d_date_sk" AND "t19"."+" < "t20"."d_date") AS "t21"
LEFT JOIN (SELECT "p_promo_sk"
FROM promotion) AS "t22" ON "t21"."cs_promo_sk" = "t22"."p_promo_sk") AS "t23"
LEFT JOIN "rs_table_72_0" ON "t23"."cs_item_sk" = "rs_table_72_0"."cr_item_sk" AND "t23"."cs_order_number" = "rs_table_72_0"."cr_order_number"
GROUP BY "t23"."i_item_desc", "t23"."w_warehouse_name", "t23"."d_week_seq"
ORDER BY COUNT(*) DESC, "t23"."i_item_desc" NULLS FIRST, "t23"."w_warehouse_name" NULLS FIRST, "t23"."d_week_seq" NULLS FIRST
LIMIT 100
;
