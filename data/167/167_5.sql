CREATE TABLE duck_table_167_0 AS SELECT "t3"."ws_item_sk", "t3"."ws_web_page_sk", "t3"."d_year", "t3"."d_moy", "t3"."d_qoy", "t3"."*" AS "*", "t4"."wp_web_page_sk", "t4"."wp_web_page_id"
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
FROM (SELECT "t0"."i_category", "t0"."i_class", "t0"."i_brand", "t0"."i_product_name", "t"."d_year", "t"."d_qoy", "t"."d_moy", "t"."wp_web_page_id", SUM("t"."*") AS "sumsales"
FROM (SELECT "ws_item_sk", "d_year", "d_moy", "d_qoy", "wp_web_page_id", "*"
FROM "duck_table_167_0") AS "t"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t0" ON "t"."ws_item_sk" = "t0"."i_item_sk"
GROUP BY "t0"."i_category", "t0"."i_class", "t0"."i_brand", "t0"."i_product_name", "t"."d_year", "t"."d_qoy", "t"."d_moy", "t"."wp_web_page_id"
UNION ALL
SELECT "t8"."i_category", "t8"."i_class", "t8"."i_brand", "t8"."i_product_name", "t8"."d_year", "t8"."d_qoy", "t8"."d_moy", NULL AS "wp_web_page_id", SUM("t8"."sumsales") AS "sumsales"
FROM (SELECT "t5"."i_category", "t5"."i_class", "t5"."i_brand", "t5"."i_product_name", "t4"."d_year", "t4"."d_qoy", "t4"."d_moy", SUM("t4"."*") AS "sumsales"
FROM (SELECT "ws_item_sk", "d_year", "d_moy", "d_qoy", "wp_web_page_id", "*"
FROM "duck_table_167_0") AS "t4"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t5" ON "t4"."ws_item_sk" = "t5"."i_item_sk"
GROUP BY "t5"."i_category", "t5"."i_class", "t5"."i_brand", "t5"."i_product_name", "t4"."d_year", "t4"."d_qoy", "t4"."d_moy", "t4"."wp_web_page_id") AS "t8"
GROUP BY "t8"."i_category", "t8"."i_class", "t8"."i_brand", "t8"."i_product_name", "t8"."d_year", "t8"."d_qoy", "t8"."d_moy") AS "t"
UNION ALL
SELECT "t16"."i_category", "t16"."i_class", "t16"."i_brand", "t16"."i_product_name", "t16"."d_year", "t16"."d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t16"."sumsales") AS "sumsales"
FROM (SELECT "t13"."i_category", "t13"."i_class", "t13"."i_brand", "t13"."i_product_name", "t12"."d_year", "t12"."d_qoy", SUM("t12"."*") AS "sumsales"
FROM (SELECT "ws_item_sk", "d_year", "d_moy", "d_qoy", "wp_web_page_id", "*"
FROM "duck_table_167_0") AS "t12"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t13" ON "t12"."ws_item_sk" = "t13"."i_item_sk"
GROUP BY "t13"."i_category", "t13"."i_class", "t13"."i_brand", "t13"."i_product_name", "t12"."d_year", "t12"."d_qoy", "t12"."d_moy", "t12"."wp_web_page_id") AS "t16"
GROUP BY "t16"."i_category", "t16"."i_class", "t16"."i_brand", "t16"."i_product_name", "t16"."d_year", "t16"."d_qoy") AS "t"
UNION ALL
SELECT "t24"."i_category", "t24"."i_class", "t24"."i_brand", "t24"."i_product_name", "t24"."d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t24"."sumsales") AS "sumsales"
FROM (SELECT "t21"."i_category", "t21"."i_class", "t21"."i_brand", "t21"."i_product_name", "t20"."d_year", SUM("t20"."*") AS "sumsales"
FROM (SELECT "ws_item_sk", "d_year", "d_moy", "d_qoy", "wp_web_page_id", "*"
FROM "duck_table_167_0") AS "t20"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t21" ON "t20"."ws_item_sk" = "t21"."i_item_sk"
GROUP BY "t21"."i_category", "t21"."i_class", "t21"."i_brand", "t21"."i_product_name", "t20"."d_year", "t20"."d_qoy", "t20"."d_moy", "t20"."wp_web_page_id") AS "t24"
GROUP BY "t24"."i_category", "t24"."i_class", "t24"."i_brand", "t24"."i_product_name", "t24"."d_year") AS "t"
UNION ALL
SELECT "t32"."i_category", "t32"."i_class", "t32"."i_brand", "t32"."i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t32"."sumsales") AS "sumsales"
FROM (SELECT "t29"."i_category", "t29"."i_class", "t29"."i_brand", "t29"."i_product_name", SUM("t28"."*") AS "sumsales"
FROM (SELECT "ws_item_sk", "d_year", "d_moy", "d_qoy", "wp_web_page_id", "*"
FROM "duck_table_167_0") AS "t28"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t29" ON "t28"."ws_item_sk" = "t29"."i_item_sk"
GROUP BY "t29"."i_category", "t29"."i_class", "t29"."i_brand", "t29"."i_product_name", "t28"."d_year", "t28"."d_qoy", "t28"."d_moy", "t28"."wp_web_page_id") AS "t32"
GROUP BY "t32"."i_category", "t32"."i_class", "t32"."i_brand", "t32"."i_product_name") AS "t"
UNION ALL
SELECT "t40"."i_category", "t40"."i_class", "t40"."i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t40"."sumsales") AS "sumsales"
FROM (SELECT "t37"."i_category", "t37"."i_class", "t37"."i_brand", SUM("t36"."*") AS "sumsales"
FROM (SELECT "ws_item_sk", "d_year", "d_moy", "d_qoy", "wp_web_page_id", "*"
FROM "duck_table_167_0") AS "t36"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t37" ON "t36"."ws_item_sk" = "t37"."i_item_sk"
GROUP BY "t37"."i_category", "t37"."i_class", "t37"."i_brand", "t37"."i_product_name", "t36"."d_year", "t36"."d_qoy", "t36"."d_moy", "t36"."wp_web_page_id") AS "t40"
GROUP BY "t40"."i_category", "t40"."i_class", "t40"."i_brand") AS "t"
UNION ALL
SELECT "t48"."i_category", "t48"."i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t48"."sumsales") AS "sumsales"
FROM (SELECT "t45"."i_category", "t45"."i_class", SUM("t44"."*") AS "sumsales"
FROM (SELECT "ws_item_sk", "d_year", "d_moy", "d_qoy", "wp_web_page_id", "*"
FROM "duck_table_167_0") AS "t44"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t45" ON "t44"."ws_item_sk" = "t45"."i_item_sk"
GROUP BY "t45"."i_category", "t45"."i_class", "t45"."i_brand", "t45"."i_product_name", "t44"."d_year", "t44"."d_qoy", "t44"."d_moy", "t44"."wp_web_page_id") AS "t48"
GROUP BY "t48"."i_category", "t48"."i_class") AS "t"
UNION ALL
SELECT "t56"."i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t56"."sumsales") AS "sumsales"
FROM (SELECT "t53"."i_category", SUM("t52"."*") AS "sumsales"
FROM (SELECT "ws_item_sk", "d_year", "d_moy", "d_qoy", "wp_web_page_id", "*"
FROM "duck_table_167_0") AS "t52"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t53" ON "t52"."ws_item_sk" = "t53"."i_item_sk"
GROUP BY "t53"."i_category", "t53"."i_class", "t53"."i_brand", "t53"."i_product_name", "t52"."d_year", "t52"."d_qoy", "t52"."d_moy", "t52"."wp_web_page_id") AS "t56"
GROUP BY "t56"."i_category") AS "t"
UNION ALL
SELECT NULL AS "i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t64"."sumsales") AS "sumsales"
FROM (SELECT SUM("t60"."*") AS "sumsales"
FROM (SELECT "ws_item_sk", "d_year", "d_moy", "d_qoy", "wp_web_page_id", "*"
FROM "duck_table_167_0") AS "t60"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t61" ON "t60"."ws_item_sk" = "t61"."i_item_sk"
GROUP BY "t61"."i_category", "t61"."i_class", "t61"."i_brand", "t61"."i_product_name", "t60"."d_year", "t60"."d_qoy", "t60"."d_moy", "t60"."wp_web_page_id") AS "t64") AS "t67") AS "t68"
WHERE "rk" <= 100
ORDER BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id", "sumsales", "rk"
FETCH NEXT 100 ROWS ONLY
;
