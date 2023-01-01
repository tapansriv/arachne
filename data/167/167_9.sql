CREATE TABLE duck_table_167_0 AS SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11
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
FROM (SELECT "t3"."i_category", "t3"."i_class", "t3"."i_brand", "t3"."i_product_name", "t2"."d_year", "t2"."d_qoy", "t2"."d_moy", "t2"."wp_web_page_id", SUM("t2"."*") AS "sumsales"
FROM (SELECT "t0"."ws_item_sk", "t0"."d_year", "t0"."d_moy", "t0"."d_qoy", "t1"."wp_web_page_id", "t0"."*" AS "*"
FROM (SELECT "t"."ws_item_sk", "t"."ws_web_page_sk", "duck_table_167_0"."d_year", "duck_table_167_0"."d_moy", "duck_table_167_0"."d_qoy", "t"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t"
INNER JOIN "duck_table_167_0" ON "t"."ws_sold_date_sk" = "duck_table_167_0"."d_date_sk") AS "t0"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t1" ON "t0"."ws_web_page_sk" = "t1"."wp_web_page_sk") AS "t2"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t3" ON "t2"."ws_item_sk" = "t3"."i_item_sk"
GROUP BY "t3"."i_category", "t3"."i_class", "t3"."i_brand", "t3"."i_product_name", "t2"."d_year", "t2"."d_qoy", "t2"."d_moy", "t2"."wp_web_page_id"
UNION ALL
SELECT "t14"."i_category", "t14"."i_class", "t14"."i_brand", "t14"."i_product_name", "t14"."d_year", "t14"."d_qoy", "t14"."d_moy", NULL AS "wp_web_page_id", SUM("t14"."sumsales") AS "sumsales"
FROM (SELECT "t11"."i_category", "t11"."i_class", "t11"."i_brand", "t11"."i_product_name", "t10"."d_year", "t10"."d_qoy", "t10"."d_moy", SUM("t10"."*") AS "sumsales"
FROM (SELECT "t8"."ws_item_sk", "t8"."d_year", "t8"."d_moy", "t8"."d_qoy", "t9"."wp_web_page_id", "t8"."*" AS "*"
FROM (SELECT "t7"."ws_item_sk", "t7"."ws_web_page_sk", "duck_table_167_00"."d_year", "duck_table_167_00"."d_moy", "duck_table_167_00"."d_qoy", "t7"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t7"
INNER JOIN "duck_table_167_0" AS "duck_table_167_00" ON "t7"."ws_sold_date_sk" = "duck_table_167_00"."d_date_sk") AS "t8"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t9" ON "t8"."ws_web_page_sk" = "t9"."wp_web_page_sk") AS "t10"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t11" ON "t10"."ws_item_sk" = "t11"."i_item_sk"
GROUP BY "t11"."i_category", "t11"."i_class", "t11"."i_brand", "t11"."i_product_name", "t10"."d_year", "t10"."d_qoy", "t10"."d_moy", "t10"."wp_web_page_id") AS "t14"
GROUP BY "t14"."i_category", "t14"."i_class", "t14"."i_brand", "t14"."i_product_name", "t14"."d_year", "t14"."d_qoy", "t14"."d_moy") AS "t"
UNION ALL
SELECT "t25"."i_category", "t25"."i_class", "t25"."i_brand", "t25"."i_product_name", "t25"."d_year", "t25"."d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t25"."sumsales") AS "sumsales"
FROM (SELECT "t22"."i_category", "t22"."i_class", "t22"."i_brand", "t22"."i_product_name", "t21"."d_year", "t21"."d_qoy", SUM("t21"."*") AS "sumsales"
FROM (SELECT "t19"."ws_item_sk", "t19"."d_year", "t19"."d_moy", "t19"."d_qoy", "t20"."wp_web_page_id", "t19"."*" AS "*"
FROM (SELECT "t18"."ws_item_sk", "t18"."ws_web_page_sk", "duck_table_167_01"."d_year", "duck_table_167_01"."d_moy", "duck_table_167_01"."d_qoy", "t18"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t18"
INNER JOIN "duck_table_167_0" AS "duck_table_167_01" ON "t18"."ws_sold_date_sk" = "duck_table_167_01"."d_date_sk") AS "t19"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t20" ON "t19"."ws_web_page_sk" = "t20"."wp_web_page_sk") AS "t21"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t22" ON "t21"."ws_item_sk" = "t22"."i_item_sk"
GROUP BY "t22"."i_category", "t22"."i_class", "t22"."i_brand", "t22"."i_product_name", "t21"."d_year", "t21"."d_qoy", "t21"."d_moy", "t21"."wp_web_page_id") AS "t25"
GROUP BY "t25"."i_category", "t25"."i_class", "t25"."i_brand", "t25"."i_product_name", "t25"."d_year", "t25"."d_qoy") AS "t"
UNION ALL
SELECT "t36"."i_category", "t36"."i_class", "t36"."i_brand", "t36"."i_product_name", "t36"."d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t36"."sumsales") AS "sumsales"
FROM (SELECT "t33"."i_category", "t33"."i_class", "t33"."i_brand", "t33"."i_product_name", "t32"."d_year", SUM("t32"."*") AS "sumsales"
FROM (SELECT "t30"."ws_item_sk", "t30"."d_year", "t30"."d_moy", "t30"."d_qoy", "t31"."wp_web_page_id", "t30"."*" AS "*"
FROM (SELECT "t29"."ws_item_sk", "t29"."ws_web_page_sk", "duck_table_167_02"."d_year", "duck_table_167_02"."d_moy", "duck_table_167_02"."d_qoy", "t29"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t29"
INNER JOIN "duck_table_167_0" AS "duck_table_167_02" ON "t29"."ws_sold_date_sk" = "duck_table_167_02"."d_date_sk") AS "t30"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t31" ON "t30"."ws_web_page_sk" = "t31"."wp_web_page_sk") AS "t32"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t33" ON "t32"."ws_item_sk" = "t33"."i_item_sk"
GROUP BY "t33"."i_category", "t33"."i_class", "t33"."i_brand", "t33"."i_product_name", "t32"."d_year", "t32"."d_qoy", "t32"."d_moy", "t32"."wp_web_page_id") AS "t36"
GROUP BY "t36"."i_category", "t36"."i_class", "t36"."i_brand", "t36"."i_product_name", "t36"."d_year") AS "t"
UNION ALL
SELECT "t47"."i_category", "t47"."i_class", "t47"."i_brand", "t47"."i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t47"."sumsales") AS "sumsales"
FROM (SELECT "t44"."i_category", "t44"."i_class", "t44"."i_brand", "t44"."i_product_name", SUM("t43"."*") AS "sumsales"
FROM (SELECT "t41"."ws_item_sk", "t41"."d_year", "t41"."d_moy", "t41"."d_qoy", "t42"."wp_web_page_id", "t41"."*" AS "*"
FROM (SELECT "t40"."ws_item_sk", "t40"."ws_web_page_sk", "duck_table_167_03"."d_year", "duck_table_167_03"."d_moy", "duck_table_167_03"."d_qoy", "t40"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t40"
INNER JOIN "duck_table_167_0" AS "duck_table_167_03" ON "t40"."ws_sold_date_sk" = "duck_table_167_03"."d_date_sk") AS "t41"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t42" ON "t41"."ws_web_page_sk" = "t42"."wp_web_page_sk") AS "t43"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t44" ON "t43"."ws_item_sk" = "t44"."i_item_sk"
GROUP BY "t44"."i_category", "t44"."i_class", "t44"."i_brand", "t44"."i_product_name", "t43"."d_year", "t43"."d_qoy", "t43"."d_moy", "t43"."wp_web_page_id") AS "t47"
GROUP BY "t47"."i_category", "t47"."i_class", "t47"."i_brand", "t47"."i_product_name") AS "t"
UNION ALL
SELECT "t58"."i_category", "t58"."i_class", "t58"."i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t58"."sumsales") AS "sumsales"
FROM (SELECT "t55"."i_category", "t55"."i_class", "t55"."i_brand", SUM("t54"."*") AS "sumsales"
FROM (SELECT "t52"."ws_item_sk", "t52"."d_year", "t52"."d_moy", "t52"."d_qoy", "t53"."wp_web_page_id", "t52"."*" AS "*"
FROM (SELECT "t51"."ws_item_sk", "t51"."ws_web_page_sk", "duck_table_167_04"."d_year", "duck_table_167_04"."d_moy", "duck_table_167_04"."d_qoy", "t51"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t51"
INNER JOIN "duck_table_167_0" AS "duck_table_167_04" ON "t51"."ws_sold_date_sk" = "duck_table_167_04"."d_date_sk") AS "t52"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t53" ON "t52"."ws_web_page_sk" = "t53"."wp_web_page_sk") AS "t54"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t55" ON "t54"."ws_item_sk" = "t55"."i_item_sk"
GROUP BY "t55"."i_category", "t55"."i_class", "t55"."i_brand", "t55"."i_product_name", "t54"."d_year", "t54"."d_qoy", "t54"."d_moy", "t54"."wp_web_page_id") AS "t58"
GROUP BY "t58"."i_category", "t58"."i_class", "t58"."i_brand") AS "t"
UNION ALL
SELECT "t69"."i_category", "t69"."i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t69"."sumsales") AS "sumsales"
FROM (SELECT "t66"."i_category", "t66"."i_class", SUM("t65"."*") AS "sumsales"
FROM (SELECT "t63"."ws_item_sk", "t63"."d_year", "t63"."d_moy", "t63"."d_qoy", "t64"."wp_web_page_id", "t63"."*" AS "*"
FROM (SELECT "t62"."ws_item_sk", "t62"."ws_web_page_sk", "duck_table_167_05"."d_year", "duck_table_167_05"."d_moy", "duck_table_167_05"."d_qoy", "t62"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t62"
INNER JOIN "duck_table_167_0" AS "duck_table_167_05" ON "t62"."ws_sold_date_sk" = "duck_table_167_05"."d_date_sk") AS "t63"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t64" ON "t63"."ws_web_page_sk" = "t64"."wp_web_page_sk") AS "t65"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t66" ON "t65"."ws_item_sk" = "t66"."i_item_sk"
GROUP BY "t66"."i_category", "t66"."i_class", "t66"."i_brand", "t66"."i_product_name", "t65"."d_year", "t65"."d_qoy", "t65"."d_moy", "t65"."wp_web_page_id") AS "t69"
GROUP BY "t69"."i_category", "t69"."i_class") AS "t"
UNION ALL
SELECT "t80"."i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t80"."sumsales") AS "sumsales"
FROM (SELECT "t77"."i_category", SUM("t76"."*") AS "sumsales"
FROM (SELECT "t74"."ws_item_sk", "t74"."d_year", "t74"."d_moy", "t74"."d_qoy", "t75"."wp_web_page_id", "t74"."*" AS "*"
FROM (SELECT "t73"."ws_item_sk", "t73"."ws_web_page_sk", "duck_table_167_06"."d_year", "duck_table_167_06"."d_moy", "duck_table_167_06"."d_qoy", "t73"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t73"
INNER JOIN "duck_table_167_0" AS "duck_table_167_06" ON "t73"."ws_sold_date_sk" = "duck_table_167_06"."d_date_sk") AS "t74"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t75" ON "t74"."ws_web_page_sk" = "t75"."wp_web_page_sk") AS "t76"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t77" ON "t76"."ws_item_sk" = "t77"."i_item_sk"
GROUP BY "t77"."i_category", "t77"."i_class", "t77"."i_brand", "t77"."i_product_name", "t76"."d_year", "t76"."d_qoy", "t76"."d_moy", "t76"."wp_web_page_id") AS "t80"
GROUP BY "t80"."i_category") AS "t"
UNION ALL
SELECT NULL AS "i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "wp_web_page_id", SUM("t91"."sumsales") AS "sumsales"
FROM (SELECT SUM("t87"."*") AS "sumsales"
FROM (SELECT "t85"."ws_item_sk", "t85"."d_year", "t85"."d_moy", "t85"."d_qoy", "t86"."wp_web_page_id", "t85"."*" AS "*"
FROM (SELECT "t84"."ws_item_sk", "t84"."ws_web_page_sk", "duck_table_167_07"."d_year", "duck_table_167_07"."d_moy", "duck_table_167_07"."d_qoy", "t84"."*" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_sales_price" * "ws_quantity" AS "*"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t84"
INNER JOIN "duck_table_167_0" AS "duck_table_167_07" ON "t84"."ws_sold_date_sk" = "duck_table_167_07"."d_date_sk") AS "t85"
INNER JOIN (SELECT "wp_web_page_sk", "wp_web_page_id"
FROM '/mnt/disks/tpcds/parquet/web_page.parquet' AS web_page) AS "t86" ON "t85"."ws_web_page_sk" = "t86"."wp_web_page_sk") AS "t87"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t88" ON "t87"."ws_item_sk" = "t88"."i_item_sk"
GROUP BY "t88"."i_category", "t88"."i_class", "t88"."i_brand", "t88"."i_product_name", "t87"."d_year", "t87"."d_qoy", "t87"."d_moy", "t87"."wp_web_page_id") AS "t91") AS "t94") AS "t95"
WHERE "rk" <= 100
ORDER BY "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "wp_web_page_id", "sumsales", "rk"
FETCH NEXT 100 ROWS ONLY
;
