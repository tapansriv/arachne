SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "t17"."i_item_id", "t16"."ca_country", "t16"."ca_state", "t16"."ca_county", AVG("t16"."CAST") AS "agg1", AVG("t16"."CAST5") AS "agg2", AVG("t16"."CAST6") AS "agg3", AVG("t16"."CAST7") AS "agg4", AVG("t16"."CAST8") AS "agg5", AVG("t16"."CAST9") AS "agg6", AVG("t16"."CAST10") AS "agg7"
FROM (SELECT "t12"."cs_item_sk", "t12"."ca_county", "t12"."ca_state", "t12"."ca_country", "t12"."CAST", "t12"."CAST6" AS "CAST5", "t12"."CAST7" AS "CAST6", "t12"."CAST8" AS "CAST7", "t12"."CAST9" AS "CAST8", "t12"."CAST10" AS "CAST9", "t12"."CAST11" AS "CAST10"
FROM (SELECT "t9"."cs_sold_date_sk", "t9"."cs_item_sk", "t11"."ca_county", "t11"."ca_state", "t11"."ca_country", "t9"."CAST", "t9"."CAST4" AS "CAST6", "t9"."CAST5" AS "CAST7", "t9"."CAST6" AS "CAST8", "t9"."CAST7" AS "CAST9", "t9"."CAST8" AS "CAST10", "t9"."CAST9" AS "CAST11"
FROM (SELECT "t5"."cs_sold_date_sk", "t5"."cs_item_sk", "t8"."c_current_addr_sk", "t5"."CAST", "t5"."CAST5" AS "CAST4", "t5"."CAST6" AS "CAST5", "t5"."CAST7" AS "CAST6", "t5"."CAST8" AS "CAST7", "t8"."CAST" AS "CAST8", "t5"."CAST9"
FROM (SELECT "t3"."cs_sold_date_sk", "t3"."cs_bill_customer_sk", "t3"."cs_item_sk", "t4"."cd_demo_sk" AS "cd_demo_sk0", "t3"."CAST", "t3"."CAST4" AS "CAST5", "t3"."CAST5" AS "CAST6", "t3"."CAST6" AS "CAST7", "t3"."CAST7" AS "CAST8", "t3"."CAST8" AS "CAST9"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_bill_customer_sk", "t"."cs_item_sk", "t"."CAST", "t"."CAST5" AS "CAST4", "t"."CAST6" AS "CAST5", "t"."CAST7" AS "CAST6", "t"."CAST8" AS "CAST7", "t2"."CAST" AS "CAST8"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_bill_cdemo_sk", "cs_item_sk", CAST("cs_quantity" AS DECIMAL(12, 2)) AS "CAST", CAST("cs_list_price" AS DECIMAL(12, 2)) AS "CAST5", CAST("cs_coupon_amt" AS DECIMAL(12, 2)) AS "CAST6", CAST("cs_sales_price" AS DECIMAL(12, 2)) AS "CAST7", CAST("cs_net_profit" AS DECIMAL(12, 2)) AS "CAST8"
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales) AS "t"
INNER JOIN (SELECT "cd_demo_sk", CAST("cd_dep_count" AS DECIMAL(12, 2)) AS "CAST"
FROM '/mnt/disks/tpcds/parquet/customer_demographics.parquet' AS customer_demographics
WHERE "cd_gender" = 'F' AND "cd_education_status" = 'Unknown') AS "t2" ON "t"."cs_bill_cdemo_sk" = "t2"."cd_demo_sk") AS "t3",
(SELECT "cd_demo_sk"
FROM '/mnt/disks/tpcds/parquet/customer_demographics.parquet' AS customer_demographics) AS "t4") AS "t5"
INNER JOIN (SELECT "c_customer_sk", "c_current_cdemo_sk", "c_current_addr_sk", CAST("c_birth_year" AS DECIMAL(12, 2)) AS "CAST"
FROM '/mnt/disks/tpcds/parquet/customer.parquet' AS customer
WHERE "c_birth_month" IN (1, 2, 6, 8, 9, 12)) AS "t8" ON "t5"."cs_bill_customer_sk" = "t8"."c_customer_sk" AND "t5"."cd_demo_sk0" = "t8"."c_current_cdemo_sk") AS "t9"
INNER JOIN (SELECT "ca_address_sk", "ca_county", "ca_state", "ca_country"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address
WHERE "ca_state" IN ('IN', 'MS', 'ND', 'NM', 'OK', 'VA')) AS "t11" ON "t9"."c_current_addr_sk" = "t11"."ca_address_sk") AS "t12"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 1998) AS "t15" ON "t12"."cs_sold_date_sk" = "t15"."d_date_sk") AS "t16"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t17" ON "t16"."cs_item_sk" = "t17"."i_item_sk"
GROUP BY "t17"."i_item_id", "t16"."ca_country", "t16"."ca_state", "t16"."ca_county"
UNION ALL
SELECT "t38"."i_item_id", "t37"."ca_country", "t37"."ca_state", NULL AS "county", AVG("t37"."CAST") AS "agg1", AVG("t37"."CAST4") AS "agg2", AVG("t37"."CAST5") AS "agg3", AVG("t37"."CAST6") AS "agg4", AVG("t37"."CAST7") AS "agg5", AVG("t37"."CAST8") AS "agg6", AVG("t37"."CAST9") AS "agg7"
FROM (SELECT "t33"."cs_item_sk", "t33"."ca_state", "t33"."ca_country", "t33"."CAST", "t33"."CAST5" AS "CAST4", "t33"."CAST6" AS "CAST5", "t33"."CAST7" AS "CAST6", "t33"."CAST8" AS "CAST7", "t33"."CAST9" AS "CAST8", "t33"."CAST10" AS "CAST9"
FROM (SELECT "t30"."cs_sold_date_sk", "t30"."cs_item_sk", "t32"."ca_state", "t32"."ca_country", "t30"."CAST", "t30"."CAST4" AS "CAST5", "t30"."CAST5" AS "CAST6", "t30"."CAST6" AS "CAST7", "t30"."CAST7" AS "CAST8", "t30"."CAST8" AS "CAST9", "t30"."CAST9" AS "CAST10"
FROM (SELECT "t26"."cs_sold_date_sk", "t26"."cs_item_sk", "t29"."c_current_addr_sk", "t26"."CAST", "t26"."CAST5" AS "CAST4", "t26"."CAST6" AS "CAST5", "t26"."CAST7" AS "CAST6", "t26"."CAST8" AS "CAST7", "t29"."CAST" AS "CAST8", "t26"."CAST9"
FROM (SELECT "t24"."cs_sold_date_sk", "t24"."cs_bill_customer_sk", "t24"."cs_item_sk", "t25"."cd_demo_sk" AS "cd_demo_sk0", "t24"."CAST", "t24"."CAST4" AS "CAST5", "t24"."CAST5" AS "CAST6", "t24"."CAST6" AS "CAST7", "t24"."CAST7" AS "CAST8", "t24"."CAST8" AS "CAST9"
FROM (SELECT "t20"."cs_sold_date_sk", "t20"."cs_bill_customer_sk", "t20"."cs_item_sk", "t20"."CAST", "t20"."CAST5" AS "CAST4", "t20"."CAST6" AS "CAST5", "t20"."CAST7" AS "CAST6", "t20"."CAST8" AS "CAST7", "t23"."CAST" AS "CAST8"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_bill_cdemo_sk", "cs_item_sk", CAST("cs_quantity" AS DECIMAL(12, 2)) AS "CAST", CAST("cs_list_price" AS DECIMAL(12, 2)) AS "CAST5", CAST("cs_coupon_amt" AS DECIMAL(12, 2)) AS "CAST6", CAST("cs_sales_price" AS DECIMAL(12, 2)) AS "CAST7", CAST("cs_net_profit" AS DECIMAL(12, 2)) AS "CAST8"
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales) AS "t20"
INNER JOIN (SELECT "cd_demo_sk", CAST("cd_dep_count" AS DECIMAL(12, 2)) AS "CAST"
FROM '/mnt/disks/tpcds/parquet/customer_demographics.parquet' AS customer_demographics
WHERE "cd_gender" = 'F' AND "cd_education_status" = 'Unknown') AS "t23" ON "t20"."cs_bill_cdemo_sk" = "t23"."cd_demo_sk") AS "t24",
(SELECT "cd_demo_sk"
FROM '/mnt/disks/tpcds/parquet/customer_demographics.parquet' AS customer_demographics) AS "t25") AS "t26"
INNER JOIN (SELECT "c_customer_sk", "c_current_cdemo_sk", "c_current_addr_sk", CAST("c_birth_year" AS DECIMAL(12, 2)) AS "CAST"
FROM '/mnt/disks/tpcds/parquet/customer.parquet' AS customer
WHERE "c_birth_month" IN (1, 2, 6, 8, 9, 12)) AS "t29" ON "t26"."cs_bill_customer_sk" = "t29"."c_customer_sk" AND "t26"."cd_demo_sk0" = "t29"."c_current_cdemo_sk") AS "t30"
INNER JOIN (SELECT "ca_address_sk", "ca_state", "ca_country"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address
WHERE "ca_state" IN ('IN', 'MS', 'ND', 'NM', 'OK', 'VA')) AS "t32" ON "t30"."c_current_addr_sk" = "t32"."ca_address_sk") AS "t33"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 1998) AS "t36" ON "t33"."cs_sold_date_sk" = "t36"."d_date_sk") AS "t37"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t38" ON "t37"."cs_item_sk" = "t38"."i_item_sk"
GROUP BY "t38"."i_item_id", "t37"."ca_country", "t37"."ca_state") AS "t"
UNION ALL
SELECT "t62"."i_item_id", "t61"."ca_country", NULL AS "ca_state", NULL AS "county", AVG("t61"."CAST") AS "agg1", AVG("t61"."CAST3") AS "agg2", AVG("t61"."CAST4") AS "agg3", AVG("t61"."CAST5") AS "agg4", AVG("t61"."CAST6") AS "agg5", AVG("t61"."CAST7") AS "agg6", AVG("t61"."CAST8") AS "agg7"
FROM (SELECT "t57"."cs_item_sk", "t57"."ca_country", "t57"."CAST", "t57"."CAST4" AS "CAST3", "t57"."CAST5" AS "CAST4", "t57"."CAST6" AS "CAST5", "t57"."CAST7" AS "CAST6", "t57"."CAST8" AS "CAST7", "t57"."CAST9" AS "CAST8"
FROM (SELECT "t53"."cs_sold_date_sk", "t53"."cs_item_sk", "t56"."ca_country", "t53"."CAST", "t53"."CAST4", "t53"."CAST5", "t53"."CAST6", "t53"."CAST7", "t53"."CAST8", "t53"."CAST9"
FROM (SELECT "t49"."cs_sold_date_sk", "t49"."cs_item_sk", "t52"."c_current_addr_sk", "t49"."CAST", "t49"."CAST5" AS "CAST4", "t49"."CAST6" AS "CAST5", "t49"."CAST7" AS "CAST6", "t49"."CAST8" AS "CAST7", "t52"."CAST" AS "CAST8", "t49"."CAST9"
FROM (SELECT "t47"."cs_sold_date_sk", "t47"."cs_bill_customer_sk", "t47"."cs_item_sk", "t48"."cd_demo_sk" AS "cd_demo_sk0", "t47"."CAST", "t47"."CAST4" AS "CAST5", "t47"."CAST5" AS "CAST6", "t47"."CAST6" AS "CAST7", "t47"."CAST7" AS "CAST8", "t47"."CAST8" AS "CAST9"
FROM (SELECT "t43"."cs_sold_date_sk", "t43"."cs_bill_customer_sk", "t43"."cs_item_sk", "t43"."CAST", "t43"."CAST5" AS "CAST4", "t43"."CAST6" AS "CAST5", "t43"."CAST7" AS "CAST6", "t43"."CAST8" AS "CAST7", "t46"."CAST" AS "CAST8"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_bill_cdemo_sk", "cs_item_sk", CAST("cs_quantity" AS DECIMAL(12, 2)) AS "CAST", CAST("cs_list_price" AS DECIMAL(12, 2)) AS "CAST5", CAST("cs_coupon_amt" AS DECIMAL(12, 2)) AS "CAST6", CAST("cs_sales_price" AS DECIMAL(12, 2)) AS "CAST7", CAST("cs_net_profit" AS DECIMAL(12, 2)) AS "CAST8"
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales) AS "t43"
INNER JOIN (SELECT "cd_demo_sk", CAST("cd_dep_count" AS DECIMAL(12, 2)) AS "CAST"
FROM '/mnt/disks/tpcds/parquet/customer_demographics.parquet' AS customer_demographics
WHERE "cd_gender" = 'F' AND "cd_education_status" = 'Unknown') AS "t46" ON "t43"."cs_bill_cdemo_sk" = "t46"."cd_demo_sk") AS "t47",
(SELECT "cd_demo_sk"
FROM '/mnt/disks/tpcds/parquet/customer_demographics.parquet' AS customer_demographics) AS "t48") AS "t49"
INNER JOIN (SELECT "c_customer_sk", "c_current_cdemo_sk", "c_current_addr_sk", CAST("c_birth_year" AS DECIMAL(12, 2)) AS "CAST"
FROM '/mnt/disks/tpcds/parquet/customer.parquet' AS customer
WHERE "c_birth_month" IN (1, 2, 6, 8, 9, 12)) AS "t52" ON "t49"."cs_bill_customer_sk" = "t52"."c_customer_sk" AND "t49"."cd_demo_sk0" = "t52"."c_current_cdemo_sk") AS "t53"
INNER JOIN (SELECT "ca_address_sk", "ca_country"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address
WHERE "ca_state" IN ('IN', 'MS', 'ND', 'NM', 'OK', 'VA')) AS "t56" ON "t53"."c_current_addr_sk" = "t56"."ca_address_sk") AS "t57"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 1998) AS "t60" ON "t57"."cs_sold_date_sk" = "t60"."d_date_sk") AS "t61"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t62" ON "t61"."cs_item_sk" = "t62"."i_item_sk"
GROUP BY "t62"."i_item_id", "t61"."ca_country") AS "t"
UNION ALL
SELECT "t86"."i_item_id", NULL AS "ca_country", NULL AS "ca_state", NULL AS "county", AVG("t85"."CAST") AS "agg1", AVG("t85"."CAST2") AS "agg2", AVG("t85"."CAST3") AS "agg3", AVG("t85"."CAST4") AS "agg4", AVG("t85"."CAST5") AS "agg5", AVG("t85"."CAST6") AS "agg6", AVG("t85"."CAST7") AS "agg7"
FROM (SELECT "t81"."cs_item_sk", "t81"."CAST", "t81"."CAST3" AS "CAST2", "t81"."CAST4" AS "CAST3", "t81"."CAST5" AS "CAST4", "t81"."CAST6" AS "CAST5", "t81"."CAST7" AS "CAST6", "t81"."CAST8" AS "CAST7"
FROM (SELECT "t77"."cs_sold_date_sk", "t77"."cs_item_sk", "t77"."CAST", "t77"."CAST4" AS "CAST3", "t77"."CAST5" AS "CAST4", "t77"."CAST6" AS "CAST5", "t77"."CAST7" AS "CAST6", "t77"."CAST8" AS "CAST7", "t77"."CAST9" AS "CAST8"
FROM (SELECT "t73"."cs_sold_date_sk", "t73"."cs_item_sk", "t76"."c_current_addr_sk", "t73"."CAST", "t73"."CAST5" AS "CAST4", "t73"."CAST6" AS "CAST5", "t73"."CAST7" AS "CAST6", "t73"."CAST8" AS "CAST7", "t76"."CAST" AS "CAST8", "t73"."CAST9"
FROM (SELECT "t71"."cs_sold_date_sk", "t71"."cs_bill_customer_sk", "t71"."cs_item_sk", "t72"."cd_demo_sk" AS "cd_demo_sk0", "t71"."CAST", "t71"."CAST4" AS "CAST5", "t71"."CAST5" AS "CAST6", "t71"."CAST6" AS "CAST7", "t71"."CAST7" AS "CAST8", "t71"."CAST8" AS "CAST9"
FROM (SELECT "t67"."cs_sold_date_sk", "t67"."cs_bill_customer_sk", "t67"."cs_item_sk", "t67"."CAST", "t67"."CAST5" AS "CAST4", "t67"."CAST6" AS "CAST5", "t67"."CAST7" AS "CAST6", "t67"."CAST8" AS "CAST7", "t70"."CAST" AS "CAST8"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_bill_cdemo_sk", "cs_item_sk", CAST("cs_quantity" AS DECIMAL(12, 2)) AS "CAST", CAST("cs_list_price" AS DECIMAL(12, 2)) AS "CAST5", CAST("cs_coupon_amt" AS DECIMAL(12, 2)) AS "CAST6", CAST("cs_sales_price" AS DECIMAL(12, 2)) AS "CAST7", CAST("cs_net_profit" AS DECIMAL(12, 2)) AS "CAST8"
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales) AS "t67"
INNER JOIN (SELECT "cd_demo_sk", CAST("cd_dep_count" AS DECIMAL(12, 2)) AS "CAST"
FROM '/mnt/disks/tpcds/parquet/customer_demographics.parquet' AS customer_demographics
WHERE "cd_gender" = 'F' AND "cd_education_status" = 'Unknown') AS "t70" ON "t67"."cs_bill_cdemo_sk" = "t70"."cd_demo_sk") AS "t71",
(SELECT "cd_demo_sk"
FROM '/mnt/disks/tpcds/parquet/customer_demographics.parquet' AS customer_demographics) AS "t72") AS "t73"
INNER JOIN (SELECT "c_customer_sk", "c_current_cdemo_sk", "c_current_addr_sk", CAST("c_birth_year" AS DECIMAL(12, 2)) AS "CAST"
FROM '/mnt/disks/tpcds/parquet/customer.parquet' AS customer
WHERE "c_birth_month" IN (1, 2, 6, 8, 9, 12)) AS "t76" ON "t73"."cs_bill_customer_sk" = "t76"."c_customer_sk" AND "t73"."cd_demo_sk0" = "t76"."c_current_cdemo_sk") AS "t77"
INNER JOIN (SELECT "ca_address_sk"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address
WHERE "ca_state" IN ('IN', 'MS', 'ND', 'NM', 'OK', 'VA')) AS "t80" ON "t77"."c_current_addr_sk" = "t80"."ca_address_sk") AS "t81"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 1998) AS "t84" ON "t81"."cs_sold_date_sk" = "t84"."d_date_sk") AS "t85"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t86" ON "t85"."cs_item_sk" = "t86"."i_item_sk"
GROUP BY "t86"."i_item_id") AS "t"
UNION ALL
SELECT NULL AS "i_item_id", NULL AS "ca_country", NULL AS "ca_state", NULL AS "county", AVG("t109"."CAST") AS "agg1", AVG("t109"."CAST2") AS "agg2", AVG("t109"."CAST3") AS "agg3", AVG("t109"."CAST4") AS "agg4", AVG("t109"."CAST5") AS "agg5", AVG("t109"."CAST6") AS "agg6", AVG("t109"."CAST7") AS "agg7"
FROM (SELECT "t105"."cs_item_sk", "t105"."CAST", "t105"."CAST3" AS "CAST2", "t105"."CAST4" AS "CAST3", "t105"."CAST5" AS "CAST4", "t105"."CAST6" AS "CAST5", "t105"."CAST7" AS "CAST6", "t105"."CAST8" AS "CAST7"
FROM (SELECT "t101"."cs_sold_date_sk", "t101"."cs_item_sk", "t101"."CAST", "t101"."CAST4" AS "CAST3", "t101"."CAST5" AS "CAST4", "t101"."CAST6" AS "CAST5", "t101"."CAST7" AS "CAST6", "t101"."CAST8" AS "CAST7", "t101"."CAST9" AS "CAST8"
FROM (SELECT "t97"."cs_sold_date_sk", "t97"."cs_item_sk", "t100"."c_current_addr_sk", "t97"."CAST", "t97"."CAST5" AS "CAST4", "t97"."CAST6" AS "CAST5", "t97"."CAST7" AS "CAST6", "t97"."CAST8" AS "CAST7", "t100"."CAST" AS "CAST8", "t97"."CAST9"
FROM (SELECT "t95"."cs_sold_date_sk", "t95"."cs_bill_customer_sk", "t95"."cs_item_sk", "t96"."cd_demo_sk" AS "cd_demo_sk0", "t95"."CAST", "t95"."CAST4" AS "CAST5", "t95"."CAST5" AS "CAST6", "t95"."CAST6" AS "CAST7", "t95"."CAST7" AS "CAST8", "t95"."CAST8" AS "CAST9"
FROM (SELECT "t91"."cs_sold_date_sk", "t91"."cs_bill_customer_sk", "t91"."cs_item_sk", "t91"."CAST", "t91"."CAST5" AS "CAST4", "t91"."CAST6" AS "CAST5", "t91"."CAST7" AS "CAST6", "t91"."CAST8" AS "CAST7", "t94"."CAST" AS "CAST8"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_bill_cdemo_sk", "cs_item_sk", CAST("cs_quantity" AS DECIMAL(12, 2)) AS "CAST", CAST("cs_list_price" AS DECIMAL(12, 2)) AS "CAST5", CAST("cs_coupon_amt" AS DECIMAL(12, 2)) AS "CAST6", CAST("cs_sales_price" AS DECIMAL(12, 2)) AS "CAST7", CAST("cs_net_profit" AS DECIMAL(12, 2)) AS "CAST8"
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales) AS "t91"
INNER JOIN (SELECT "cd_demo_sk", CAST("cd_dep_count" AS DECIMAL(12, 2)) AS "CAST"
FROM '/mnt/disks/tpcds/parquet/customer_demographics.parquet' AS customer_demographics
WHERE "cd_gender" = 'F' AND "cd_education_status" = 'Unknown') AS "t94" ON "t91"."cs_bill_cdemo_sk" = "t94"."cd_demo_sk") AS "t95",
(SELECT "cd_demo_sk"
FROM '/mnt/disks/tpcds/parquet/customer_demographics.parquet' AS customer_demographics) AS "t96") AS "t97"
INNER JOIN (SELECT "c_customer_sk", "c_current_cdemo_sk", "c_current_addr_sk", CAST("c_birth_year" AS DECIMAL(12, 2)) AS "CAST"
FROM '/mnt/disks/tpcds/parquet/customer.parquet' AS customer
WHERE "c_birth_month" IN (1, 2, 6, 8, 9, 12)) AS "t100" ON "t97"."cs_bill_customer_sk" = "t100"."c_customer_sk" AND "t97"."cd_demo_sk0" = "t100"."c_current_cdemo_sk") AS "t101"
INNER JOIN (SELECT "ca_address_sk"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address
WHERE "ca_state" IN ('IN', 'MS', 'ND', 'NM', 'OK', 'VA')) AS "t104" ON "t101"."c_current_addr_sk" = "t104"."ca_address_sk") AS "t105"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 1998) AS "t108" ON "t105"."cs_sold_date_sk" = "t108"."d_date_sk") AS "t109"
INNER JOIN (SELECT "i_item_sk"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t110" ON "t109"."cs_item_sk" = "t110"."i_item_sk") AS "t114"
ORDER BY "ca_country" NULLS FIRST, "ca_state" NULLS FIRST, "ca_county" NULLS FIRST, "i_item_id" NULLS FIRST
FETCH NEXT 100 ROWS ONLY

