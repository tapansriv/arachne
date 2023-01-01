SELECT "t11"."i_brand_id" AS "brand_id", "t11"."i_brand" AS "brand", "t11"."i_manufact_id", "t11"."i_manufact", SUM("t11"."ss_ext_sales_price") AS "ext_price"
FROM (SELECT "t9"."ss_store_sk", "t9"."ss_ext_sales_price", "t9"."i_brand_id", "t9"."i_brand", "t9"."i_manufact_id", "t9"."i_manufact", "t10"."SUBSTRING"
FROM (SELECT "t7"."ss_store_sk", "t7"."ss_ext_sales_price", "t7"."i_brand_id", "t7"."i_brand", "t7"."i_manufact_id", "t7"."i_manufact", "t8"."c_current_addr_sk"
FROM (SELECT "t3"."ss_customer_sk", "t3"."ss_store_sk", "t3"."ss_ext_sales_price", "t6"."i_brand_id", "t6"."i_brand", "t6"."i_manufact_id", "t6"."i_manufact"
FROM (SELECT "t2"."ss_item_sk", "t2"."ss_customer_sk", "t2"."ss_store_sk", "t2"."ss_ext_sales_price"
FROM (SELECT "d_date_sk"
FROM date_dim
WHERE "d_moy" = 11 AND "d_year" = 1998) AS "t1"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_customer_sk", "ss_store_sk", "ss_ext_sales_price"
FROM store_sales) AS "t2" ON "t1"."d_date_sk" = "t2"."ss_sold_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_brand", "i_manufact_id", "i_manufact"
FROM item
WHERE "i_manager_id" = 8) AS "t6" ON "t3"."ss_item_sk" = "t6"."i_item_sk") AS "t7"
INNER JOIN (SELECT "c_customer_sk", "c_current_addr_sk"
FROM customer) AS "t8" ON "t7"."ss_customer_sk" = "t8"."c_customer_sk") AS "t9"
INNER JOIN (SELECT "ca_address_sk", SUBSTRING("ca_zip" FROM 1 FOR 5) AS "SUBSTRING"
FROM customer_address) AS "t10" ON "t9"."c_current_addr_sk" = "t10"."ca_address_sk") AS "t11"
INNER JOIN (SELECT "s_store_sk", SUBSTRING("s_zip" FROM 1 FOR 5) AS "SUBSTRING"
FROM store) AS "t12" ON "t11"."SUBSTRING" <> "t12"."SUBSTRING" AND "t11"."ss_store_sk" = "t12"."s_store_sk"
GROUP BY "t11"."i_brand", "t11"."i_brand_id", "t11"."i_manufact_id", "t11"."i_manufact"
ORDER BY SUM("t11"."ss_ext_sales_price") DESC, "t11"."i_brand" IS NULL, "t11"."i_brand", "t11"."i_brand_id" IS NULL, "t11"."i_brand_id", "t11"."i_manufact_id" IS NULL, "t11"."i_manufact_id", "t11"."i_manufact" IS NULL, "t11"."i_manufact"
LIMIT 100
;
