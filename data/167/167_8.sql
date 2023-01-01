CREATE TABLE duck_table_167_0 AS SELECT "t5"."ws_item_sk", "t5"."d_year", "t5"."d_moy", "t5"."d_qoy", "t5"."wp_web_page_id", "t5"."*" AS "*", "t6"."i_item_sk", "t6"."i_brand", "t6"."i_class", "t6"."i_category", "t6"."i_product_name"
FROM (SELECT "t3"."ws_item_sk", "t3"."d_year", "t3"."d_moy", "t3"."d_qoy", "t4"."wp_web_page_id", "t3"."*" AS "*"
FROM (SELECT "t"."ws_item_sk", "t"."ws_web_page_sk", "t2"."d_year", "t2"."d_moy", "t2"."d_qoy", "t"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ws_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t4" ON "t3"."ws_web_page_sk" = "t4"."wp_web_page_sk") AS "t5"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t6" ON "t5"."ws_item_sk" = "t6"."i_item_sk"
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
FROM (SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id", SUM("*") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id"
UNION ALL
SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM (SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", SUM("*") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id") AS "t4"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy") AS "t"
UNION ALL
SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM (SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", SUM("*") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id") AS "t10"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy") AS "t"
UNION ALL
SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM (SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", SUM("*") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id") AS "t16"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year") AS "t"
UNION ALL
SELECT "i_category", "i_class", "i_brand", "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM (SELECT "i_category", "i_class", "i_brand", "i_product_name", SUM("*") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id") AS "t22"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name") AS "t"
UNION ALL
SELECT "i_category", "i_class", "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM (SELECT "i_category", "i_class", "i_brand", SUM("*") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id") AS "t28"
GROUP BY "i_category", "i_class", "i_brand") AS "t"
UNION ALL
SELECT "i_category", "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM (SELECT "i_category", "i_class", SUM("*") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id") AS "t34"
GROUP BY "i_category", "i_class") AS "t"
UNION ALL
SELECT "i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM (SELECT "i_category", SUM("*") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id") AS "t40"
GROUP BY "i_category") AS "t"
UNION ALL
SELECT NULL AS "i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM (SELECT SUM("*") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id") AS "t46") AS "t49") AS "t50"
WHERE "rk" <= 100
ORDER BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id", "sumsales", "rk"
FETCH NEXT 100 ROWS ONLY
;
