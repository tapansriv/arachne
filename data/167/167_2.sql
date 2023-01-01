CREATE TABLE duck_table_167_0 AS SELECT "t"."ws_item_sk", "t"."ws_web_page_sk", "t2"."d_year", "t2"."d_moy", "t2"."d_qoy", "t"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ws_sold_date_sk" = "t2"."d_date_sk"
;
SELECT *
FROM (SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id", "sumsales", RANK() OVER (PARTITION BY "i_category" ORDER BY "sumsales" DESC) AS "rk"
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "t1"."i_category", "t1"."i_class", "t1"."i_brand", "t1"."i_product_name", "t0"."d_year", "t0"."d_qoy", "t0"."d_moy", "t0"."wp_web_page_id", SUM("t0"."*") AS "sumsales"
FROM (SELECT "duck_table_167_0"."ws_item_sk", "duck_table_167_0"."d_year", "duck_table_167_0"."d_moy", "duck_table_167_0"."d_qoy", "t"."wp_web_page_id", "duck_table_167_0"."*"
FROM "duck_table_167_0"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t" ON "duck_table_167_0"."ws_web_page_sk" = "t"."wp_web_page_sk") AS "t0"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t1" ON "t0"."ws_item_sk" = "t1"."i_item_sk"
GROUP BY "t1"."i_category", "t1"."i_class", "t1"."i_brand", "t1"."i_product_name", "t0"."d_year", "t0"."d_qoy", "t0"."d_moy", "t0"."wp_web_page_id"
UNION ALL
SELECT "t10"."i_category", "t10"."i_class", "t10"."i_brand", "t10"."i_product_name", "t10"."d_year", "t10"."d_qoy", "t10"."d_moy", NULL AS "wp_web_page_id", SUM("t10"."sumsales") AS "sumsales"
FROM (SELECT "t7"."i_category", "t7"."i_class", "t7"."i_brand", "t7"."i_product_name", "t6"."d_year", "t6"."d_qoy", "t6"."d_moy", SUM("t6"."*") AS "sumsales"
FROM (SELECT "duck_table_167_00"."ws_item_sk", "duck_table_167_00"."d_year", "duck_table_167_00"."d_moy", "duck_table_167_00"."d_qoy", "t5"."wp_web_page_id", "duck_table_167_00"."*"
FROM "duck_table_167_0" AS "duck_table_167_00"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t5" ON "duck_table_167_00"."ws_web_page_sk" = "t5"."wp_web_page_sk") AS "t6"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t7" ON "t6"."ws_item_sk" = "t7"."i_item_sk"
GROUP BY "t7"."i_category", "t7"."i_class", "t7"."i_brand", "t7"."i_product_name", "t6"."d_year", "t6"."d_qoy", "t6"."d_moy", "t6"."wp_web_page_id") AS "t10"
GROUP BY "t10"."i_category", "t10"."i_class", "t10"."i_brand", "t10"."i_product_name", "t10"."d_year", "t10"."d_qoy", "t10"."d_moy") AS "t"
UNION ALL
SELECT "t19"."i_category", "t19"."i_class", "t19"."i_brand", "t19"."i_product_name", "t19"."d_year", "t19"."d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t19"."sumsales") AS "sumsales"
FROM (SELECT "t16"."i_category", "t16"."i_class", "t16"."i_brand", "t16"."i_product_name", "t15"."d_year", "t15"."d_qoy", SUM("t15"."*") AS "sumsales"
FROM (SELECT "duck_table_167_01"."ws_item_sk", "duck_table_167_01"."d_year", "duck_table_167_01"."d_moy", "duck_table_167_01"."d_qoy", "t14"."wp_web_page_id", "duck_table_167_01"."*"
FROM "duck_table_167_0" AS "duck_table_167_01"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t14" ON "duck_table_167_01"."ws_web_page_sk" = "t14"."wp_web_page_sk") AS "t15"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t16" ON "t15"."ws_item_sk" = "t16"."i_item_sk"
GROUP BY "t16"."i_category", "t16"."i_class", "t16"."i_brand", "t16"."i_product_name", "t15"."d_year", "t15"."d_qoy", "t15"."d_moy", "t15"."wp_web_page_id") AS "t19"
GROUP BY "t19"."i_category", "t19"."i_class", "t19"."i_brand", "t19"."i_product_name", "t19"."d_year", "t19"."d_qoy") AS "t"
UNION ALL
SELECT "t28"."i_category", "t28"."i_class", "t28"."i_brand", "t28"."i_product_name", "t28"."d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t28"."sumsales") AS "sumsales"
FROM (SELECT "t25"."i_category", "t25"."i_class", "t25"."i_brand", "t25"."i_product_name", "t24"."d_year", SUM("t24"."*") AS "sumsales"
FROM (SELECT "duck_table_167_02"."ws_item_sk", "duck_table_167_02"."d_year", "duck_table_167_02"."d_moy", "duck_table_167_02"."d_qoy", "t23"."wp_web_page_id", "duck_table_167_02"."*"
FROM "duck_table_167_0" AS "duck_table_167_02"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t23" ON "duck_table_167_02"."ws_web_page_sk" = "t23"."wp_web_page_sk") AS "t24"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t25" ON "t24"."ws_item_sk" = "t25"."i_item_sk"
GROUP BY "t25"."i_category", "t25"."i_class", "t25"."i_brand", "t25"."i_product_name", "t24"."d_year", "t24"."d_qoy", "t24"."d_moy", "t24"."wp_web_page_id") AS "t28"
GROUP BY "t28"."i_category", "t28"."i_class", "t28"."i_brand", "t28"."i_product_name", "t28"."d_year") AS "t"
UNION ALL
SELECT "t37"."i_category", "t37"."i_class", "t37"."i_brand", "t37"."i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t37"."sumsales") AS "sumsales"
FROM (SELECT "t34"."i_category", "t34"."i_class", "t34"."i_brand", "t34"."i_product_name", SUM("t33"."*") AS "sumsales"
FROM (SELECT "duck_table_167_03"."ws_item_sk", "duck_table_167_03"."d_year", "duck_table_167_03"."d_moy", "duck_table_167_03"."d_qoy", "t32"."wp_web_page_id", "duck_table_167_03"."*"
FROM "duck_table_167_0" AS "duck_table_167_03"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t32" ON "duck_table_167_03"."ws_web_page_sk" = "t32"."wp_web_page_sk") AS "t33"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t34" ON "t33"."ws_item_sk" = "t34"."i_item_sk"
GROUP BY "t34"."i_category", "t34"."i_class", "t34"."i_brand", "t34"."i_product_name", "t33"."d_year", "t33"."d_qoy", "t33"."d_moy", "t33"."wp_web_page_id") AS "t37"
GROUP BY "t37"."i_category", "t37"."i_class", "t37"."i_brand", "t37"."i_product_name") AS "t"
UNION ALL
SELECT "t46"."i_category", "t46"."i_class", "t46"."i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t46"."sumsales") AS "sumsales"
FROM (SELECT "t43"."i_category", "t43"."i_class", "t43"."i_brand", SUM("t42"."*") AS "sumsales"
FROM (SELECT "duck_table_167_04"."ws_item_sk", "duck_table_167_04"."d_year", "duck_table_167_04"."d_moy", "duck_table_167_04"."d_qoy", "t41"."wp_web_page_id", "duck_table_167_04"."*"
FROM "duck_table_167_0" AS "duck_table_167_04"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t41" ON "duck_table_167_04"."ws_web_page_sk" = "t41"."wp_web_page_sk") AS "t42"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t43" ON "t42"."ws_item_sk" = "t43"."i_item_sk"
GROUP BY "t43"."i_category", "t43"."i_class", "t43"."i_brand", "t43"."i_product_name", "t42"."d_year", "t42"."d_qoy", "t42"."d_moy", "t42"."wp_web_page_id") AS "t46"
GROUP BY "t46"."i_category", "t46"."i_class", "t46"."i_brand") AS "t"
UNION ALL
SELECT "t55"."i_category", "t55"."i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t55"."sumsales") AS "sumsales"
FROM (SELECT "t52"."i_category", "t52"."i_class", SUM("t51"."*") AS "sumsales"
FROM (SELECT "duck_table_167_05"."ws_item_sk", "duck_table_167_05"."d_year", "duck_table_167_05"."d_moy", "duck_table_167_05"."d_qoy", "t50"."wp_web_page_id", "duck_table_167_05"."*"
FROM "duck_table_167_0" AS "duck_table_167_05"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t50" ON "duck_table_167_05"."ws_web_page_sk" = "t50"."wp_web_page_sk") AS "t51"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t52" ON "t51"."ws_item_sk" = "t52"."i_item_sk"
GROUP BY "t52"."i_category", "t52"."i_class", "t52"."i_brand", "t52"."i_product_name", "t51"."d_year", "t51"."d_qoy", "t51"."d_moy", "t51"."wp_web_page_id") AS "t55"
GROUP BY "t55"."i_category", "t55"."i_class") AS "t"
UNION ALL
SELECT "t64"."i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t64"."sumsales") AS "sumsales"
FROM (SELECT "t61"."i_category", SUM("t60"."*") AS "sumsales"
FROM (SELECT "duck_table_167_06"."ws_item_sk", "duck_table_167_06"."d_year", "duck_table_167_06"."d_moy", "duck_table_167_06"."d_qoy", "t59"."wp_web_page_id", "duck_table_167_06"."*"
FROM "duck_table_167_0" AS "duck_table_167_06"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t59" ON "duck_table_167_06"."ws_web_page_sk" = "t59"."wp_web_page_sk") AS "t60"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t61" ON "t60"."ws_item_sk" = "t61"."i_item_sk"
GROUP BY "t61"."i_category", "t61"."i_class", "t61"."i_brand", "t61"."i_product_name", "t60"."d_year", "t60"."d_qoy", "t60"."d_moy", "t60"."wp_web_page_id") AS "t64"
GROUP BY "t64"."i_category") AS "t"
UNION ALL
SELECT NULL AS "i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t73"."sumsales") AS "sumsales"
FROM (SELECT SUM("t69"."*") AS "sumsales"
FROM (SELECT "duck_table_167_07"."ws_item_sk", "duck_table_167_07"."d_year", "duck_table_167_07"."d_moy", "duck_table_167_07"."d_qoy", "t68"."wp_web_page_id", "duck_table_167_07"."*"
FROM "duck_table_167_0" AS "duck_table_167_07"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t68" ON "duck_table_167_07"."ws_web_page_sk" = "t68"."wp_web_page_sk") AS "t69"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t70" ON "t69"."ws_item_sk" = "t70"."i_item_sk"
GROUP BY "t70"."i_category", "t70"."i_class", "t70"."i_brand", "t70"."i_product_name", "t69"."d_year", "t69"."d_qoy", "t69"."d_moy", "t69"."wp_web_page_id") AS "t73") AS "t76") AS "t77"
WHERE "rk" <= 100
ORDER BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id", "sumsales", "rk"
FETCH NEXT 100 ROWS ONLY
;