CREATE TABLE duck_table_167_0 AS SELECT "t6"."i_category", "t6"."i_class", "t6"."i_brand", "t6"."i_product_name", "t5"."d_year", "t5"."d_qoy", "t5"."d_moy", "t5"."wp_web_page_id", SUM("t5"."*") AS "sumsales"
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
GROUP BY "t6"."i_category", "t6"."i_class", "t6"."i_brand", "t6"."i_product_name", "t5"."d_year", "t5"."d_qoy", "t5"."d_moy", "t5"."wp_web_page_id"
;
CREATE TABLE duck_table_167_1 AS SELECT "i_category", "i_class", SUM("sumsales") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class"
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
FROM (SELECT *
FROM "duck_table_167_0"
UNION ALL
SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy") AS "t"
UNION ALL
SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy") AS "t"
UNION ALL
SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name", "d_year") AS "t"
UNION ALL
SELECT "i_category", "i_class", "i_brand", "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand", "i_product_name") AS "t"
UNION ALL
SELECT "i_category", "i_class", "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category", "i_class", "i_brand") AS "t"
UNION ALL
SELECT "i_category", "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", "sumsales"
FROM "duck_table_167_1") AS "t"
UNION ALL
SELECT "i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM "duck_table_167_0"
GROUP BY "i_category") AS "t"
UNION ALL
SELECT NULL AS "i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("sumsales") AS "sumsales"
FROM "duck_table_167_0") AS "t29") AS "t30"
WHERE "rk" <= 100
ORDER BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id", "sumsales", "rk"
FETCH NEXT 100 ROWS ONLY
;
