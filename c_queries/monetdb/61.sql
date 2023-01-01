SELECT "t23"."promotions", "t44"."total", "t23"."CAST" / "t44"."CAST" * 100
FROM (SELECT SUM("t17"."ss_ext_sales_price") AS "promotions", CAST(SUM("t17"."ss_ext_sales_price") AS DECIMAL(15, 4)) AS "CAST"
FROM (SELECT "t13"."ss_item_sk", "t13"."ss_ext_sales_price"
FROM (SELECT "t11"."ss_item_sk", "t11"."ss_ext_sales_price", "t12"."c_current_addr_sk"
FROM (SELECT "t7"."ss_item_sk", "t7"."ss_customer_sk", "t7"."ss_ext_sales_price"
FROM (SELECT "t3"."ss_sold_date_sk", "t3"."ss_item_sk", "t3"."ss_customer_sk", "t3"."ss_ext_sales_price"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_item_sk", "t"."ss_customer_sk", "t"."ss_promo_sk", "t"."ss_ext_sales_price"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_customer_sk", "ss_store_sk", "ss_promo_sk", "ss_ext_sales_price"
FROM store_sales) AS "t"
INNER JOIN (SELECT "s_store_sk"
FROM store
WHERE "s_gmt_offset" = -5) AS "t2" ON "t"."ss_store_sk" = "t2"."s_store_sk") AS "t3"
INNER JOIN (SELECT "p_promo_sk"
FROM promotion
WHERE "p_channel_dmail" = 'Y' OR "p_channel_email" = 'Y' OR "p_channel_tv" = 'Y') AS "t6" ON "t3"."ss_promo_sk" = "t6"."p_promo_sk") AS "t7"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1998 AND "d_moy" = 11) AS "t10" ON "t7"."ss_sold_date_sk" = "t10"."d_date_sk") AS "t11"
INNER JOIN (SELECT "c_customer_sk", "c_current_addr_sk"
FROM customer) AS "t12" ON "t11"."ss_customer_sk" = "t12"."c_customer_sk") AS "t13"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_gmt_offset" = -5) AS "t16" ON "t13"."c_current_addr_sk" = "t16"."ca_address_sk") AS "t17"
INNER JOIN (SELECT "i_item_sk"
FROM item
WHERE "i_category" = 'Jewelry') AS "t20" ON "t17"."ss_item_sk" = "t20"."i_item_sk") AS "t23",
(SELECT SUM("t38"."ss_ext_sales_price") AS "total", CAST(SUM("t38"."ss_ext_sales_price") AS DECIMAL(15, 4)) AS "CAST"
FROM (SELECT "t34"."ss_item_sk", "t34"."ss_ext_sales_price"
FROM (SELECT "t32"."ss_item_sk", "t32"."ss_ext_sales_price", "t33"."c_current_addr_sk"
FROM (SELECT "t28"."ss_item_sk", "t28"."ss_customer_sk", "t28"."ss_ext_sales_price"
FROM (SELECT "t24"."ss_sold_date_sk", "t24"."ss_item_sk", "t24"."ss_customer_sk", "t24"."ss_ext_sales_price"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_customer_sk", "ss_store_sk", "ss_ext_sales_price"
FROM store_sales) AS "t24"
INNER JOIN (SELECT "s_store_sk"
FROM store
WHERE "s_gmt_offset" = -5) AS "t27" ON "t24"."ss_store_sk" = "t27"."s_store_sk") AS "t28"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1998 AND "d_moy" = 11) AS "t31" ON "t28"."ss_sold_date_sk" = "t31"."d_date_sk") AS "t32"
INNER JOIN (SELECT "c_customer_sk", "c_current_addr_sk"
FROM customer) AS "t33" ON "t32"."ss_customer_sk" = "t33"."c_customer_sk") AS "t34"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_gmt_offset" = -5) AS "t37" ON "t34"."c_current_addr_sk" = "t37"."ca_address_sk") AS "t38"
INNER JOIN (SELECT "i_item_sk"
FROM item
WHERE "i_category" = 'Jewelry') AS "t41" ON "t38"."ss_item_sk" = "t41"."i_item_sk") AS "t44"
ORDER BY "t23"."promotions" IS NULL, "t23"."promotions", "t44"."total" IS NULL, "t44"."total"
LIMIT 100
;
