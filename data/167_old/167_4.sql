CREATE TABLE duck_table_167_0 AS SELECT "t3"."ws_item_sk", "t3"."d_year", "t3"."d_moy", "t3"."d_qoy", "t4"."wp_web_page_id", "t3"."*" AS "*"
FROM (SELECT "t"."ws_item_sk", "t"."ws_web_page_sk", "t2"."d_year", "t2"."d_moy", "t2"."d_qoy", "t"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ws_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t4" ON "t3"."ws_web_page_sk" = "t4"."wp_web_page_sk"
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
FROM (SELECT "t"."i_category", "t"."i_class", "t"."i_brand", "t"."i_product_name", "duck_table_167_0"."d_year", "duck_table_167_0"."d_qoy", "duck_table_167_0"."d_moy", "duck_table_167_0"."wp_web_page_id", SUM("duck_table_167_0"."*") AS "sumsales"
FROM "duck_table_167_0"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t" ON "duck_table_167_0"."ws_item_sk" = "t"."i_item_sk"
GROUP BY "t"."i_category", "t"."i_class", "t"."i_brand", "t"."i_product_name", "duck_table_167_0"."d_year", "duck_table_167_0"."d_qoy", "duck_table_167_0"."d_moy", "duck_table_167_0"."wp_web_page_id"
UNION ALL
SELECT "t6"."i_category", "t6"."i_class", "t6"."i_brand", "t6"."i_product_name", "t6"."d_year", "t6"."d_qoy", "t6"."d_moy", NULL AS "wp_web_page_id", SUM("t6"."sumsales") AS "sumsales"
FROM (SELECT "t3"."i_category", "t3"."i_class", "t3"."i_brand", "t3"."i_product_name", "duck_table_167_00"."d_year", "duck_table_167_00"."d_qoy", "duck_table_167_00"."d_moy", SUM("duck_table_167_00"."*") AS "sumsales"
FROM "duck_table_167_0" AS "duck_table_167_00"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t3" ON "duck_table_167_00"."ws_item_sk" = "t3"."i_item_sk"
GROUP BY "t3"."i_category", "t3"."i_class", "t3"."i_brand", "t3"."i_product_name", "duck_table_167_00"."d_year", "duck_table_167_00"."d_qoy", "duck_table_167_00"."d_moy", "duck_table_167_00"."wp_web_page_id") AS "t6"
GROUP BY "t6"."i_category", "t6"."i_class", "t6"."i_brand", "t6"."i_product_name", "t6"."d_year", "t6"."d_qoy", "t6"."d_moy") AS "t"
UNION ALL
SELECT "t13"."i_category", "t13"."i_class", "t13"."i_brand", "t13"."i_product_name", "t13"."d_year", "t13"."d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t13"."sumsales") AS "sumsales"
FROM (SELECT "t10"."i_category", "t10"."i_class", "t10"."i_brand", "t10"."i_product_name", "duck_table_167_01"."d_year", "duck_table_167_01"."d_qoy", SUM("duck_table_167_01"."*") AS "sumsales"
FROM "duck_table_167_0" AS "duck_table_167_01"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t10" ON "duck_table_167_01"."ws_item_sk" = "t10"."i_item_sk"
GROUP BY "t10"."i_category", "t10"."i_class", "t10"."i_brand", "t10"."i_product_name", "duck_table_167_01"."d_year", "duck_table_167_01"."d_qoy", "duck_table_167_01"."d_moy", "duck_table_167_01"."wp_web_page_id") AS "t13"
GROUP BY "t13"."i_category", "t13"."i_class", "t13"."i_brand", "t13"."i_product_name", "t13"."d_year", "t13"."d_qoy") AS "t"
UNION ALL
SELECT "t20"."i_category", "t20"."i_class", "t20"."i_brand", "t20"."i_product_name", "t20"."d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t20"."sumsales") AS "sumsales"
FROM (SELECT "t17"."i_category", "t17"."i_class", "t17"."i_brand", "t17"."i_product_name", "duck_table_167_02"."d_year", SUM("duck_table_167_02"."*") AS "sumsales"
FROM "duck_table_167_0" AS "duck_table_167_02"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t17" ON "duck_table_167_02"."ws_item_sk" = "t17"."i_item_sk"
GROUP BY "t17"."i_category", "t17"."i_class", "t17"."i_brand", "t17"."i_product_name", "duck_table_167_02"."d_year", "duck_table_167_02"."d_qoy", "duck_table_167_02"."d_moy", "duck_table_167_02"."wp_web_page_id") AS "t20"
GROUP BY "t20"."i_category", "t20"."i_class", "t20"."i_brand", "t20"."i_product_name", "t20"."d_year") AS "t"
UNION ALL
SELECT "t27"."i_category", "t27"."i_class", "t27"."i_brand", "t27"."i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t27"."sumsales") AS "sumsales"
FROM (SELECT "t24"."i_category", "t24"."i_class", "t24"."i_brand", "t24"."i_product_name", SUM("duck_table_167_03"."*") AS "sumsales"
FROM "duck_table_167_0" AS "duck_table_167_03"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t24" ON "duck_table_167_03"."ws_item_sk" = "t24"."i_item_sk"
GROUP BY "t24"."i_category", "t24"."i_class", "t24"."i_brand", "t24"."i_product_name", "duck_table_167_03"."d_year", "duck_table_167_03"."d_qoy", "duck_table_167_03"."d_moy", "duck_table_167_03"."wp_web_page_id") AS "t27"
GROUP BY "t27"."i_category", "t27"."i_class", "t27"."i_brand", "t27"."i_product_name") AS "t"
UNION ALL
SELECT "t34"."i_category", "t34"."i_class", "t34"."i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t34"."sumsales") AS "sumsales"
FROM (SELECT "t31"."i_category", "t31"."i_class", "t31"."i_brand", SUM("duck_table_167_04"."*") AS "sumsales"
FROM "duck_table_167_0" AS "duck_table_167_04"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t31" ON "duck_table_167_04"."ws_item_sk" = "t31"."i_item_sk"
GROUP BY "t31"."i_category", "t31"."i_class", "t31"."i_brand", "t31"."i_product_name", "duck_table_167_04"."d_year", "duck_table_167_04"."d_qoy", "duck_table_167_04"."d_moy", "duck_table_167_04"."wp_web_page_id") AS "t34"
GROUP BY "t34"."i_category", "t34"."i_class", "t34"."i_brand") AS "t"
UNION ALL
SELECT "t41"."i_category", "t41"."i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t41"."sumsales") AS "sumsales"
FROM (SELECT "t38"."i_category", "t38"."i_class", SUM("duck_table_167_05"."*") AS "sumsales"
FROM "duck_table_167_0" AS "duck_table_167_05"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t38" ON "duck_table_167_05"."ws_item_sk" = "t38"."i_item_sk"
GROUP BY "t38"."i_category", "t38"."i_class", "t38"."i_brand", "t38"."i_product_name", "duck_table_167_05"."d_year", "duck_table_167_05"."d_qoy", "duck_table_167_05"."d_moy", "duck_table_167_05"."wp_web_page_id") AS "t41"
GROUP BY "t41"."i_category", "t41"."i_class") AS "t"
UNION ALL
SELECT "t48"."i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t48"."sumsales") AS "sumsales"
FROM (SELECT "t45"."i_category", SUM("duck_table_167_06"."*") AS "sumsales"
FROM "duck_table_167_0" AS "duck_table_167_06"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t45" ON "duck_table_167_06"."ws_item_sk" = "t45"."i_item_sk"
GROUP BY "t45"."i_category", "t45"."i_class", "t45"."i_brand", "t45"."i_product_name", "duck_table_167_06"."d_year", "duck_table_167_06"."d_qoy", "duck_table_167_06"."d_moy", "duck_table_167_06"."wp_web_page_id") AS "t48"
GROUP BY "t48"."i_category") AS "t"
UNION ALL
SELECT NULL AS "i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t55"."sumsales") AS "sumsales"
FROM (SELECT SUM("duck_table_167_07"."*") AS "sumsales"
FROM "duck_table_167_0" AS "duck_table_167_07"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t52" ON "duck_table_167_07"."ws_item_sk" = "t52"."i_item_sk"
GROUP BY "t52"."i_category", "t52"."i_class", "t52"."i_brand", "t52"."i_product_name", "duck_table_167_07"."d_year", "duck_table_167_07"."d_qoy", "duck_table_167_07"."d_moy", "duck_table_167_07"."wp_web_page_id") AS "t55") AS "t58") AS "t59"
WHERE "rk" <= 100
ORDER BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id", "sumsales", "rk"
FETCH NEXT 100 ROWS ONLY
;
