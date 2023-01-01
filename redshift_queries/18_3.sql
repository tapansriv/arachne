CREATE TABLE rs_table_18_0 AS SELECT "t17"."i_item_id", "t16"."ca_country", "t16"."ca_state", "t16"."ca_county", "t16"."CAST" AS "agg1", "t16"."CAST5" AS "agg2", "t16"."CAST6" AS "agg3", "t16"."CAST7" AS "agg4", "t16"."CAST8" AS "agg5", "t16"."CAST9" AS "agg6", "t16"."CAST10" AS "agg7"
FROM (SELECT "t12"."cs_item_sk", "t12"."ca_county", "t12"."ca_state", "t12"."ca_country", "t12"."CAST", "t12"."CAST6" AS "CAST5", "t12"."CAST7" AS "CAST6", "t12"."CAST8" AS "CAST7", "t12"."CAST9" AS "CAST8", "t12"."CAST10" AS "CAST9", "t12"."CAST11" AS "CAST10"
FROM (SELECT "t9"."cs_sold_date_sk", "t9"."cs_item_sk", "t11"."ca_county", "t11"."ca_state", "t11"."ca_country", "t9"."CAST", "t9"."CAST4" AS "CAST6", "t9"."CAST5" AS "CAST7", "t9"."CAST6" AS "CAST8", "t9"."CAST7" AS "CAST9", "t9"."CAST8" AS "CAST10", "t9"."CAST9" AS "CAST11"
FROM (SELECT "t5"."cs_sold_date_sk", "t5"."cs_item_sk", "t8"."c_current_addr_sk", "t5"."CAST", "t5"."CAST5" AS "CAST4", "t5"."CAST6" AS "CAST5", "t5"."CAST7" AS "CAST6", "t5"."CAST8" AS "CAST7", "t8"."CAST" AS "CAST8", "t5"."CAST9"
FROM (SELECT "t3"."cs_sold_date_sk", "t3"."cs_bill_customer_sk", "t3"."cs_item_sk", "t4"."cd_demo_sk" AS "cd_demo_sk0", "t3"."CAST", "t3"."CAST4" AS "CAST5", "t3"."CAST5" AS "CAST6", "t3"."CAST6" AS "CAST7", "t3"."CAST7" AS "CAST8", "t3"."CAST8" AS "CAST9"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_bill_customer_sk", "t"."cs_item_sk", "t"."CAST", "t"."CAST5" AS "CAST4", "t"."CAST6" AS "CAST5", "t"."CAST7" AS "CAST6", "t"."CAST8" AS "CAST7", "t2"."CAST" AS "CAST8"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_bill_cdemo_sk", "cs_item_sk", CAST("cs_quantity" AS DECIMAL(12, 2)) AS "CAST", CAST("cs_list_price" AS DECIMAL(12, 2)) AS "CAST5", CAST("cs_coupon_amt" AS DECIMAL(12, 2)) AS "CAST6", CAST("cs_sales_price" AS DECIMAL(12, 2)) AS "CAST7", CAST("cs_net_profit" AS DECIMAL(12, 2)) AS "CAST8"
FROM catalog_sales) AS "t"
INNER JOIN (SELECT "cd_demo_sk", CAST("cd_dep_count" AS DECIMAL(12, 2)) AS "CAST"
FROM customer_demographics
WHERE "cd_gender" = 'F' AND "cd_education_status" = 'Unknown') AS "t2" ON "t"."cs_bill_cdemo_sk" = "t2"."cd_demo_sk") AS "t3",
(SELECT "cd_demo_sk"
FROM customer_demographics) AS "t4") AS "t5"
INNER JOIN (SELECT "c_customer_sk", "c_current_cdemo_sk", "c_current_addr_sk", CAST("c_birth_year" AS DECIMAL(12, 2)) AS "CAST"
FROM customer
WHERE "c_birth_month" IN (1, 2, 6, 8, 9, 12)) AS "t8" ON "t5"."cs_bill_customer_sk" = "t8"."c_customer_sk" AND "t5"."cd_demo_sk0" = "t8"."c_current_cdemo_sk") AS "t9"
INNER JOIN (SELECT "ca_address_sk", "ca_county", "ca_state", "ca_country"
FROM customer_address
WHERE "ca_state" IN ('IN', 'MS', 'ND', 'NM', 'OK', 'VA')) AS "t11" ON "t9"."c_current_addr_sk" = "t11"."ca_address_sk") AS "t12"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1998) AS "t15" ON "t12"."cs_sold_date_sk" = "t15"."d_date_sk") AS "t16"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t17" ON "t16"."cs_item_sk" = "t17"."i_item_sk"
;
SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "i_item_id", "ca_country", "ca_state", "ca_county", AVG("agg1") AS "agg1", AVG("agg2") AS "agg2", AVG("agg3") AS "agg3", AVG("agg4") AS "agg4", AVG("agg5") AS "agg5", AVG("agg6") AS "agg6", AVG("agg7") AS "agg7"
FROM "rs_table_18_0"
GROUP BY "i_item_id", "ca_country", "ca_state", "ca_county"
UNION ALL
SELECT "t18"."i_item_id", "t17"."ca_country", "t17"."ca_state", NULL AS "county", AVG("t17"."CAST") AS "agg1", AVG("t17"."CAST4") AS "agg2", AVG("t17"."CAST5") AS "agg3", AVG("t17"."CAST6") AS "agg4", AVG("t17"."CAST7") AS "agg5", AVG("t17"."CAST8") AS "agg6", AVG("t17"."CAST9") AS "agg7"
FROM (SELECT "t13"."cs_item_sk", "t13"."ca_state", "t13"."ca_country", "t13"."CAST", "t13"."CAST5" AS "CAST4", "t13"."CAST6" AS "CAST5", "t13"."CAST7" AS "CAST6", "t13"."CAST8" AS "CAST7", "t13"."CAST9" AS "CAST8", "t13"."CAST10" AS "CAST9"
FROM (SELECT "t10"."cs_sold_date_sk", "t10"."cs_item_sk", "t12"."ca_state", "t12"."ca_country", "t10"."CAST", "t10"."CAST4" AS "CAST5", "t10"."CAST5" AS "CAST6", "t10"."CAST6" AS "CAST7", "t10"."CAST7" AS "CAST8", "t10"."CAST8" AS "CAST9", "t10"."CAST9" AS "CAST10"
FROM (SELECT "t6"."cs_sold_date_sk", "t6"."cs_item_sk", "t9"."c_current_addr_sk", "t6"."CAST", "t6"."CAST5" AS "CAST4", "t6"."CAST6" AS "CAST5", "t6"."CAST7" AS "CAST6", "t6"."CAST8" AS "CAST7", "t9"."CAST" AS "CAST8", "t6"."CAST9"
FROM (SELECT "t4"."cs_sold_date_sk", "t4"."cs_bill_customer_sk", "t4"."cs_item_sk", "t5"."cd_demo_sk" AS "cd_demo_sk0", "t4"."CAST", "t4"."CAST4" AS "CAST5", "t4"."CAST5" AS "CAST6", "t4"."CAST6" AS "CAST7", "t4"."CAST7" AS "CAST8", "t4"."CAST8" AS "CAST9"
FROM (SELECT "t0"."cs_sold_date_sk", "t0"."cs_bill_customer_sk", "t0"."cs_item_sk", "t0"."CAST", "t0"."CAST5" AS "CAST4", "t0"."CAST6" AS "CAST5", "t0"."CAST7" AS "CAST6", "t0"."CAST8" AS "CAST7", "t3"."CAST" AS "CAST8"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_bill_cdemo_sk", "cs_item_sk", CAST("cs_quantity" AS DECIMAL(12, 2)) AS "CAST", CAST("cs_list_price" AS DECIMAL(12, 2)) AS "CAST5", CAST("cs_coupon_amt" AS DECIMAL(12, 2)) AS "CAST6", CAST("cs_sales_price" AS DECIMAL(12, 2)) AS "CAST7", CAST("cs_net_profit" AS DECIMAL(12, 2)) AS "CAST8"
FROM catalog_sales) AS "t0"
INNER JOIN (SELECT "cd_demo_sk", CAST("cd_dep_count" AS DECIMAL(12, 2)) AS "CAST"
FROM customer_demographics
WHERE "cd_gender" = 'F' AND "cd_education_status" = 'Unknown') AS "t3" ON "t0"."cs_bill_cdemo_sk" = "t3"."cd_demo_sk") AS "t4",
(SELECT "cd_demo_sk"
FROM customer_demographics) AS "t5") AS "t6"
INNER JOIN (SELECT "c_customer_sk", "c_current_cdemo_sk", "c_current_addr_sk", CAST("c_birth_year" AS DECIMAL(12, 2)) AS "CAST"
FROM customer
WHERE "c_birth_month" IN (1, 2, 6, 8, 9, 12)) AS "t9" ON "t6"."cs_bill_customer_sk" = "t9"."c_customer_sk" AND "t6"."cd_demo_sk0" = "t9"."c_current_cdemo_sk") AS "t10"
INNER JOIN (SELECT "ca_address_sk", "ca_state", "ca_country"
FROM customer_address
WHERE "ca_state" IN ('IN', 'MS', 'ND', 'NM', 'OK', 'VA')) AS "t12" ON "t10"."c_current_addr_sk" = "t12"."ca_address_sk") AS "t13"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1998) AS "t16" ON "t13"."cs_sold_date_sk" = "t16"."d_date_sk") AS "t17"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t18" ON "t17"."cs_item_sk" = "t18"."i_item_sk"
GROUP BY "t18"."i_item_id", "t17"."ca_country", "t17"."ca_state")
UNION ALL
SELECT "t42"."i_item_id", "t41"."ca_country", NULL AS "ca_state", NULL AS "county", AVG("t41"."CAST") AS "agg1", AVG("t41"."CAST3") AS "agg2", AVG("t41"."CAST4") AS "agg3", AVG("t41"."CAST5") AS "agg4", AVG("t41"."CAST6") AS "agg5", AVG("t41"."CAST7") AS "agg6", AVG("t41"."CAST8") AS "agg7"
FROM (SELECT "t37"."cs_item_sk", "t37"."ca_country", "t37"."CAST", "t37"."CAST4" AS "CAST3", "t37"."CAST5" AS "CAST4", "t37"."CAST6" AS "CAST5", "t37"."CAST7" AS "CAST6", "t37"."CAST8" AS "CAST7", "t37"."CAST9" AS "CAST8"
FROM (SELECT "t33"."cs_sold_date_sk", "t33"."cs_item_sk", "t36"."ca_country", "t33"."CAST", "t33"."CAST4", "t33"."CAST5", "t33"."CAST6", "t33"."CAST7", "t33"."CAST8", "t33"."CAST9"
FROM (SELECT "t29"."cs_sold_date_sk", "t29"."cs_item_sk", "t32"."c_current_addr_sk", "t29"."CAST", "t29"."CAST5" AS "CAST4", "t29"."CAST6" AS "CAST5", "t29"."CAST7" AS "CAST6", "t29"."CAST8" AS "CAST7", "t32"."CAST" AS "CAST8", "t29"."CAST9"
FROM (SELECT "t27"."cs_sold_date_sk", "t27"."cs_bill_customer_sk", "t27"."cs_item_sk", "t28"."cd_demo_sk" AS "cd_demo_sk0", "t27"."CAST", "t27"."CAST4" AS "CAST5", "t27"."CAST5" AS "CAST6", "t27"."CAST6" AS "CAST7", "t27"."CAST7" AS "CAST8", "t27"."CAST8" AS "CAST9"
FROM (SELECT "t23"."cs_sold_date_sk", "t23"."cs_bill_customer_sk", "t23"."cs_item_sk", "t23"."CAST", "t23"."CAST5" AS "CAST4", "t23"."CAST6" AS "CAST5", "t23"."CAST7" AS "CAST6", "t23"."CAST8" AS "CAST7", "t26"."CAST" AS "CAST8"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_bill_cdemo_sk", "cs_item_sk", CAST("cs_quantity" AS DECIMAL(12, 2)) AS "CAST", CAST("cs_list_price" AS DECIMAL(12, 2)) AS "CAST5", CAST("cs_coupon_amt" AS DECIMAL(12, 2)) AS "CAST6", CAST("cs_sales_price" AS DECIMAL(12, 2)) AS "CAST7", CAST("cs_net_profit" AS DECIMAL(12, 2)) AS "CAST8"
FROM catalog_sales) AS "t23"
INNER JOIN (SELECT "cd_demo_sk", CAST("cd_dep_count" AS DECIMAL(12, 2)) AS "CAST"
FROM customer_demographics
WHERE "cd_gender" = 'F' AND "cd_education_status" = 'Unknown') AS "t26" ON "t23"."cs_bill_cdemo_sk" = "t26"."cd_demo_sk") AS "t27",
(SELECT "cd_demo_sk"
FROM customer_demographics) AS "t28") AS "t29"
INNER JOIN (SELECT "c_customer_sk", "c_current_cdemo_sk", "c_current_addr_sk", CAST("c_birth_year" AS DECIMAL(12, 2)) AS "CAST"
FROM customer
WHERE "c_birth_month" IN (1, 2, 6, 8, 9, 12)) AS "t32" ON "t29"."cs_bill_customer_sk" = "t32"."c_customer_sk" AND "t29"."cd_demo_sk0" = "t32"."c_current_cdemo_sk") AS "t33"
INNER JOIN (SELECT "ca_address_sk", "ca_country"
FROM customer_address
WHERE "ca_state" IN ('IN', 'MS', 'ND', 'NM', 'OK', 'VA')) AS "t36" ON "t33"."c_current_addr_sk" = "t36"."ca_address_sk") AS "t37"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1998) AS "t40" ON "t37"."cs_sold_date_sk" = "t40"."d_date_sk") AS "t41"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t42" ON "t41"."cs_item_sk" = "t42"."i_item_sk"
GROUP BY "t42"."i_item_id", "t41"."ca_country")
UNION ALL
SELECT "t66"."i_item_id", NULL AS "ca_country", NULL AS "ca_state", NULL AS "county", AVG("t65"."CAST") AS "agg1", AVG("t65"."CAST2") AS "agg2", AVG("t65"."CAST3") AS "agg3", AVG("t65"."CAST4") AS "agg4", AVG("t65"."CAST5") AS "agg5", AVG("t65"."CAST6") AS "agg6", AVG("t65"."CAST7") AS "agg7"
FROM (SELECT "t61"."cs_item_sk", "t61"."CAST", "t61"."CAST3" AS "CAST2", "t61"."CAST4" AS "CAST3", "t61"."CAST5" AS "CAST4", "t61"."CAST6" AS "CAST5", "t61"."CAST7" AS "CAST6", "t61"."CAST8" AS "CAST7"
FROM (SELECT "t57"."cs_sold_date_sk", "t57"."cs_item_sk", "t57"."CAST", "t57"."CAST4" AS "CAST3", "t57"."CAST5" AS "CAST4", "t57"."CAST6" AS "CAST5", "t57"."CAST7" AS "CAST6", "t57"."CAST8" AS "CAST7", "t57"."CAST9" AS "CAST8"
FROM (SELECT "t53"."cs_sold_date_sk", "t53"."cs_item_sk", "t56"."c_current_addr_sk", "t53"."CAST", "t53"."CAST5" AS "CAST4", "t53"."CAST6" AS "CAST5", "t53"."CAST7" AS "CAST6", "t53"."CAST8" AS "CAST7", "t56"."CAST" AS "CAST8", "t53"."CAST9"
FROM (SELECT "t51"."cs_sold_date_sk", "t51"."cs_bill_customer_sk", "t51"."cs_item_sk", "t52"."cd_demo_sk" AS "cd_demo_sk0", "t51"."CAST", "t51"."CAST4" AS "CAST5", "t51"."CAST5" AS "CAST6", "t51"."CAST6" AS "CAST7", "t51"."CAST7" AS "CAST8", "t51"."CAST8" AS "CAST9"
FROM (SELECT "t47"."cs_sold_date_sk", "t47"."cs_bill_customer_sk", "t47"."cs_item_sk", "t47"."CAST", "t47"."CAST5" AS "CAST4", "t47"."CAST6" AS "CAST5", "t47"."CAST7" AS "CAST6", "t47"."CAST8" AS "CAST7", "t50"."CAST" AS "CAST8"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_bill_cdemo_sk", "cs_item_sk", CAST("cs_quantity" AS DECIMAL(12, 2)) AS "CAST", CAST("cs_list_price" AS DECIMAL(12, 2)) AS "CAST5", CAST("cs_coupon_amt" AS DECIMAL(12, 2)) AS "CAST6", CAST("cs_sales_price" AS DECIMAL(12, 2)) AS "CAST7", CAST("cs_net_profit" AS DECIMAL(12, 2)) AS "CAST8"
FROM catalog_sales) AS "t47"
INNER JOIN (SELECT "cd_demo_sk", CAST("cd_dep_count" AS DECIMAL(12, 2)) AS "CAST"
FROM customer_demographics
WHERE "cd_gender" = 'F' AND "cd_education_status" = 'Unknown') AS "t50" ON "t47"."cs_bill_cdemo_sk" = "t50"."cd_demo_sk") AS "t51",
(SELECT "cd_demo_sk"
FROM customer_demographics) AS "t52") AS "t53"
INNER JOIN (SELECT "c_customer_sk", "c_current_cdemo_sk", "c_current_addr_sk", CAST("c_birth_year" AS DECIMAL(12, 2)) AS "CAST"
FROM customer
WHERE "c_birth_month" IN (1, 2, 6, 8, 9, 12)) AS "t56" ON "t53"."cs_bill_customer_sk" = "t56"."c_customer_sk" AND "t53"."cd_demo_sk0" = "t56"."c_current_cdemo_sk") AS "t57"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_state" IN ('IN', 'MS', 'ND', 'NM', 'OK', 'VA')) AS "t60" ON "t57"."c_current_addr_sk" = "t60"."ca_address_sk") AS "t61"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1998) AS "t64" ON "t61"."cs_sold_date_sk" = "t64"."d_date_sk") AS "t65"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t66" ON "t65"."cs_item_sk" = "t66"."i_item_sk"
GROUP BY "t66"."i_item_id")
UNION ALL
SELECT NULL AS "i_item_id", NULL AS "ca_country", NULL AS "ca_state", NULL AS "county", AVG("t89"."CAST") AS "agg1", AVG("t89"."CAST2") AS "agg2", AVG("t89"."CAST3") AS "agg3", AVG("t89"."CAST4") AS "agg4", AVG("t89"."CAST5") AS "agg5", AVG("t89"."CAST6") AS "agg6", AVG("t89"."CAST7") AS "agg7"
FROM (SELECT "t85"."cs_item_sk", "t85"."CAST", "t85"."CAST3" AS "CAST2", "t85"."CAST4" AS "CAST3", "t85"."CAST5" AS "CAST4", "t85"."CAST6" AS "CAST5", "t85"."CAST7" AS "CAST6", "t85"."CAST8" AS "CAST7"
FROM (SELECT "t81"."cs_sold_date_sk", "t81"."cs_item_sk", "t81"."CAST", "t81"."CAST4" AS "CAST3", "t81"."CAST5" AS "CAST4", "t81"."CAST6" AS "CAST5", "t81"."CAST7" AS "CAST6", "t81"."CAST8" AS "CAST7", "t81"."CAST9" AS "CAST8"
FROM (SELECT "t77"."cs_sold_date_sk", "t77"."cs_item_sk", "t80"."c_current_addr_sk", "t77"."CAST", "t77"."CAST5" AS "CAST4", "t77"."CAST6" AS "CAST5", "t77"."CAST7" AS "CAST6", "t77"."CAST8" AS "CAST7", "t80"."CAST" AS "CAST8", "t77"."CAST9"
FROM (SELECT "t75"."cs_sold_date_sk", "t75"."cs_bill_customer_sk", "t75"."cs_item_sk", "t76"."cd_demo_sk" AS "cd_demo_sk0", "t75"."CAST", "t75"."CAST4" AS "CAST5", "t75"."CAST5" AS "CAST6", "t75"."CAST6" AS "CAST7", "t75"."CAST7" AS "CAST8", "t75"."CAST8" AS "CAST9"
FROM (SELECT "t71"."cs_sold_date_sk", "t71"."cs_bill_customer_sk", "t71"."cs_item_sk", "t71"."CAST", "t71"."CAST5" AS "CAST4", "t71"."CAST6" AS "CAST5", "t71"."CAST7" AS "CAST6", "t71"."CAST8" AS "CAST7", "t74"."CAST" AS "CAST8"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_bill_cdemo_sk", "cs_item_sk", CAST("cs_quantity" AS DECIMAL(12, 2)) AS "CAST", CAST("cs_list_price" AS DECIMAL(12, 2)) AS "CAST5", CAST("cs_coupon_amt" AS DECIMAL(12, 2)) AS "CAST6", CAST("cs_sales_price" AS DECIMAL(12, 2)) AS "CAST7", CAST("cs_net_profit" AS DECIMAL(12, 2)) AS "CAST8"
FROM catalog_sales) AS "t71"
INNER JOIN (SELECT "cd_demo_sk", CAST("cd_dep_count" AS DECIMAL(12, 2)) AS "CAST"
FROM customer_demographics
WHERE "cd_gender" = 'F' AND "cd_education_status" = 'Unknown') AS "t74" ON "t71"."cs_bill_cdemo_sk" = "t74"."cd_demo_sk") AS "t75",
(SELECT "cd_demo_sk"
FROM customer_demographics) AS "t76") AS "t77"
INNER JOIN (SELECT "c_customer_sk", "c_current_cdemo_sk", "c_current_addr_sk", CAST("c_birth_year" AS DECIMAL(12, 2)) AS "CAST"
FROM customer
WHERE "c_birth_month" IN (1, 2, 6, 8, 9, 12)) AS "t80" ON "t77"."cs_bill_customer_sk" = "t80"."c_customer_sk" AND "t77"."cd_demo_sk0" = "t80"."c_current_cdemo_sk") AS "t81"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_state" IN ('IN', 'MS', 'ND', 'NM', 'OK', 'VA')) AS "t84" ON "t81"."c_current_addr_sk" = "t84"."ca_address_sk") AS "t85"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1998) AS "t88" ON "t85"."cs_sold_date_sk" = "t88"."d_date_sk") AS "t89"
INNER JOIN (SELECT "i_item_sk"
FROM item) AS "t90" ON "t89"."cs_item_sk" = "t90"."i_item_sk") AS "t94"
ORDER BY "ca_country" NULLS FIRST, "ca_state" NULLS FIRST, "ca_county" NULLS FIRST, "i_item_id" NULLS FIRST
LIMIT 100
;
