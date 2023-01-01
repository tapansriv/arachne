SELECT *
FROM (SELECT "i_category", "i_class", "i_brand", "i_product_name", "d_year", "d_qoy", "d_moy", "s_store_id", "sumsales", RANK() OVER (PARTITION BY "i_category" ORDER BY "sumsales" IS NULL DESC, "sumsales" DESC) AS "rk"
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "t6"."i_category", "t6"."i_class", "t6"."i_brand", "t6"."i_product_name", "t5"."d_year", "t5"."d_qoy", "t5"."d_moy", "t5"."s_store_id", SUM("t5"."*") AS "sumsales"
FROM (SELECT "t3"."ss_item_sk", "t3"."d_year", "t3"."d_moy", "t3"."d_qoy", "t4"."s_store_id", "t3"."*" AS "*"
FROM (SELECT "t"."ss_item_sk", "t"."ss_store_sk", "t2"."d_year", "t2"."d_moy", "t2"."d_qoy", "t"."*" AS "*"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price" * "ss_quantity" AS "*"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "s_store_sk", "s_store_id"
FROM store) AS "t4" ON "t3"."ss_store_sk" = "t4"."s_store_sk") AS "t5"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM item) AS "t6" ON "t5"."ss_item_sk" = "t6"."i_item_sk"
GROUP BY "t6"."i_category", "t6"."i_class", "t6"."i_brand", "t6"."i_product_name", "t5"."d_year", "t5"."d_qoy", "t5"."d_moy", "t5"."s_store_id"
UNION ALL
SELECT "t20"."i_category", "t20"."i_class", "t20"."i_brand", "t20"."i_product_name", "t20"."d_year", "t20"."d_qoy", "t20"."d_moy", NULL AS "s_store_id", SUM("t20"."sumsales") AS "sumsales"
FROM (SELECT "t17"."i_category", "t17"."i_class", "t17"."i_brand", "t17"."i_product_name", "t16"."d_year", "t16"."d_qoy", "t16"."d_moy", SUM("t16"."*") AS "sumsales"
FROM (SELECT "t14"."ss_item_sk", "t14"."d_year", "t14"."d_moy", "t14"."d_qoy", "t15"."s_store_id", "t14"."*" AS "*"
FROM (SELECT "t10"."ss_item_sk", "t10"."ss_store_sk", "t13"."d_year", "t13"."d_moy", "t13"."d_qoy", "t10"."*" AS "*"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price" * "ss_quantity" AS "*"
FROM store_sales) AS "t10"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t13" ON "t10"."ss_sold_date_sk" = "t13"."d_date_sk") AS "t14"
INNER JOIN (SELECT "s_store_sk", "s_store_id"
FROM store) AS "t15" ON "t14"."ss_store_sk" = "t15"."s_store_sk") AS "t16"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM item) AS "t17" ON "t16"."ss_item_sk" = "t17"."i_item_sk"
GROUP BY "t17"."i_category", "t17"."i_class", "t17"."i_brand", "t17"."i_product_name", "t16"."d_year", "t16"."d_qoy", "t16"."d_moy", "t16"."s_store_id") AS "t20"
GROUP BY "t20"."i_category", "t20"."i_class", "t20"."i_brand", "t20"."i_product_name", "t20"."d_year", "t20"."d_qoy", "t20"."d_moy") AS "t"
UNION ALL
SELECT "t34"."i_category", "t34"."i_class", "t34"."i_brand", "t34"."i_product_name", "t34"."d_year", "t34"."d_qoy", NULL AS "d_moy", NULL AS "s_store_id", SUM("t34"."sumsales") AS "sumsales"
FROM (SELECT "t31"."i_category", "t31"."i_class", "t31"."i_brand", "t31"."i_product_name", "t30"."d_year", "t30"."d_qoy", SUM("t30"."*") AS "sumsales"
FROM (SELECT "t28"."ss_item_sk", "t28"."d_year", "t28"."d_moy", "t28"."d_qoy", "t29"."s_store_id", "t28"."*" AS "*"
FROM (SELECT "t24"."ss_item_sk", "t24"."ss_store_sk", "t27"."d_year", "t27"."d_moy", "t27"."d_qoy", "t24"."*" AS "*"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price" * "ss_quantity" AS "*"
FROM store_sales) AS "t24"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t27" ON "t24"."ss_sold_date_sk" = "t27"."d_date_sk") AS "t28"
INNER JOIN (SELECT "s_store_sk", "s_store_id"
FROM store) AS "t29" ON "t28"."ss_store_sk" = "t29"."s_store_sk") AS "t30"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM item) AS "t31" ON "t30"."ss_item_sk" = "t31"."i_item_sk"
GROUP BY "t31"."i_category", "t31"."i_class", "t31"."i_brand", "t31"."i_product_name", "t30"."d_year", "t30"."d_qoy", "t30"."d_moy", "t30"."s_store_id") AS "t34"
GROUP BY "t34"."i_category", "t34"."i_class", "t34"."i_brand", "t34"."i_product_name", "t34"."d_year", "t34"."d_qoy") AS "t"
UNION ALL
SELECT "t48"."i_category", "t48"."i_class", "t48"."i_brand", "t48"."i_product_name", "t48"."d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "s_store_id", SUM("t48"."sumsales") AS "sumsales"
FROM (SELECT "t45"."i_category", "t45"."i_class", "t45"."i_brand", "t45"."i_product_name", "t44"."d_year", SUM("t44"."*") AS "sumsales"
FROM (SELECT "t42"."ss_item_sk", "t42"."d_year", "t42"."d_moy", "t42"."d_qoy", "t43"."s_store_id", "t42"."*" AS "*"
FROM (SELECT "t38"."ss_item_sk", "t38"."ss_store_sk", "t41"."d_year", "t41"."d_moy", "t41"."d_qoy", "t38"."*" AS "*"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price" * "ss_quantity" AS "*"
FROM store_sales) AS "t38"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t41" ON "t38"."ss_sold_date_sk" = "t41"."d_date_sk") AS "t42"
INNER JOIN (SELECT "s_store_sk", "s_store_id"
FROM store) AS "t43" ON "t42"."ss_store_sk" = "t43"."s_store_sk") AS "t44"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM item) AS "t45" ON "t44"."ss_item_sk" = "t45"."i_item_sk"
GROUP BY "t45"."i_category", "t45"."i_class", "t45"."i_brand", "t45"."i_product_name", "t44"."d_year", "t44"."d_qoy", "t44"."d_moy", "t44"."s_store_id") AS "t48"
GROUP BY "t48"."i_category", "t48"."i_class", "t48"."i_brand", "t48"."i_product_name", "t48"."d_year") AS "t"
UNION ALL
SELECT "t62"."i_category", "t62"."i_class", "t62"."i_brand", "t62"."i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "s_store_id", SUM("t62"."sumsales") AS "sumsales"
FROM (SELECT "t59"."i_category", "t59"."i_class", "t59"."i_brand", "t59"."i_product_name", SUM("t58"."*") AS "sumsales"
FROM (SELECT "t56"."ss_item_sk", "t56"."d_year", "t56"."d_moy", "t56"."d_qoy", "t57"."s_store_id", "t56"."*" AS "*"
FROM (SELECT "t52"."ss_item_sk", "t52"."ss_store_sk", "t55"."d_year", "t55"."d_moy", "t55"."d_qoy", "t52"."*" AS "*"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price" * "ss_quantity" AS "*"
FROM store_sales) AS "t52"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t55" ON "t52"."ss_sold_date_sk" = "t55"."d_date_sk") AS "t56"
INNER JOIN (SELECT "s_store_sk", "s_store_id"
FROM store) AS "t57" ON "t56"."ss_store_sk" = "t57"."s_store_sk") AS "t58"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM item) AS "t59" ON "t58"."ss_item_sk" = "t59"."i_item_sk"
GROUP BY "t59"."i_category", "t59"."i_class", "t59"."i_brand", "t59"."i_product_name", "t58"."d_year", "t58"."d_qoy", "t58"."d_moy", "t58"."s_store_id") AS "t62"
GROUP BY "t62"."i_category", "t62"."i_class", "t62"."i_brand", "t62"."i_product_name") AS "t"
UNION ALL
SELECT "t76"."i_category", "t76"."i_class", "t76"."i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "s_store_id", SUM("t76"."sumsales") AS "sumsales"
FROM (SELECT "t73"."i_category", "t73"."i_class", "t73"."i_brand", SUM("t72"."*") AS "sumsales"
FROM (SELECT "t70"."ss_item_sk", "t70"."d_year", "t70"."d_moy", "t70"."d_qoy", "t71"."s_store_id", "t70"."*" AS "*"
FROM (SELECT "t66"."ss_item_sk", "t66"."ss_store_sk", "t69"."d_year", "t69"."d_moy", "t69"."d_qoy", "t66"."*" AS "*"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price" * "ss_quantity" AS "*"
FROM store_sales) AS "t66"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t69" ON "t66"."ss_sold_date_sk" = "t69"."d_date_sk") AS "t70"
INNER JOIN (SELECT "s_store_sk", "s_store_id"
FROM store) AS "t71" ON "t70"."ss_store_sk" = "t71"."s_store_sk") AS "t72"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM item) AS "t73" ON "t72"."ss_item_sk" = "t73"."i_item_sk"
GROUP BY "t73"."i_category", "t73"."i_class", "t73"."i_brand", "t73"."i_product_name", "t72"."d_year", "t72"."d_qoy", "t72"."d_moy", "t72"."s_store_id") AS "t76"
GROUP BY "t76"."i_category", "t76"."i_class", "t76"."i_brand") AS "t"
UNION ALL
SELECT "t90"."i_category", "t90"."i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "s_store_id", SUM("t90"."sumsales") AS "sumsales"
FROM (SELECT "t87"."i_category", "t87"."i_class", SUM("t86"."*") AS "sumsales"
FROM (SELECT "t84"."ss_item_sk", "t84"."d_year", "t84"."d_moy", "t84"."d_qoy", "t85"."s_store_id", "t84"."*" AS "*"
FROM (SELECT "t80"."ss_item_sk", "t80"."ss_store_sk", "t83"."d_year", "t83"."d_moy", "t83"."d_qoy", "t80"."*" AS "*"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price" * "ss_quantity" AS "*"
FROM store_sales) AS "t80"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t83" ON "t80"."ss_sold_date_sk" = "t83"."d_date_sk") AS "t84"
INNER JOIN (SELECT "s_store_sk", "s_store_id"
FROM store) AS "t85" ON "t84"."ss_store_sk" = "t85"."s_store_sk") AS "t86"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM item) AS "t87" ON "t86"."ss_item_sk" = "t87"."i_item_sk"
GROUP BY "t87"."i_category", "t87"."i_class", "t87"."i_brand", "t87"."i_product_name", "t86"."d_year", "t86"."d_qoy", "t86"."d_moy", "t86"."s_store_id") AS "t90"
GROUP BY "t90"."i_category", "t90"."i_class") AS "t"
UNION ALL
SELECT "t104"."i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "s_store_id", SUM("t104"."sumsales") AS "sumsales"
FROM (SELECT "t101"."i_category", SUM("t100"."*") AS "sumsales"
FROM (SELECT "t98"."ss_item_sk", "t98"."d_year", "t98"."d_moy", "t98"."d_qoy", "t99"."s_store_id", "t98"."*" AS "*"
FROM (SELECT "t94"."ss_item_sk", "t94"."ss_store_sk", "t97"."d_year", "t97"."d_moy", "t97"."d_qoy", "t94"."*" AS "*"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price" * "ss_quantity" AS "*"
FROM store_sales) AS "t94"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t97" ON "t94"."ss_sold_date_sk" = "t97"."d_date_sk") AS "t98"
INNER JOIN (SELECT "s_store_sk", "s_store_id"
FROM store) AS "t99" ON "t98"."ss_store_sk" = "t99"."s_store_sk") AS "t100"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM item) AS "t101" ON "t100"."ss_item_sk" = "t101"."i_item_sk"
GROUP BY "t101"."i_category", "t101"."i_class", "t101"."i_brand", "t101"."i_product_name", "t100"."d_year", "t100"."d_qoy", "t100"."d_moy", "t100"."s_store_id") AS "t104"
GROUP BY "t104"."i_category") AS "t"
UNION ALL
SELECT NULL AS "i_category", NULL AS "i_class", NULL AS "i_brand", NULL AS "i_product_name", NULL AS "d_year", NULL AS "d_qoy", NULL AS "d_moy", NULL AS "s_store_id", SUM("t118"."sumsales") AS "sumsales"
FROM (SELECT SUM("t114"."*") AS "sumsales"
FROM (SELECT "t112"."ss_item_sk", "t112"."d_year", "t112"."d_moy", "t112"."d_qoy", "t113"."s_store_id", "t112"."*" AS "*"
FROM (SELECT "t108"."ss_item_sk", "t108"."ss_store_sk", "t111"."d_year", "t111"."d_moy", "t111"."d_qoy", "t108"."*" AS "*"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price" * "ss_quantity" AS "*"
FROM store_sales) AS "t108"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy", "d_qoy"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t111" ON "t108"."ss_sold_date_sk" = "t111"."d_date_sk") AS "t112"
INNER JOIN (SELECT "s_store_sk", "s_store_id"
FROM store) AS "t113" ON "t112"."ss_store_sk" = "t113"."s_store_sk") AS "t114"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM item) AS "t115" ON "t114"."ss_item_sk" = "t115"."i_item_sk"
GROUP BY "t115"."i_category", "t115"."i_class", "t115"."i_brand", "t115"."i_product_name", "t114"."d_year", "t114"."d_qoy", "t114"."d_moy", "t114"."s_store_id") AS "t118") AS "t121") AS "t122"
WHERE "rk" <= 100
ORDER BY "i_category" IS NULL, "i_category", "i_class" IS NULL, "i_class", "i_brand" IS NULL, "i_brand", "i_product_name" IS NULL, "i_product_name", "d_year" IS NULL, "d_year", "d_qoy" IS NULL, "d_qoy", "d_moy" IS NULL, "d_moy", "s_store_id" IS NULL, "s_store_id", "sumsales" IS NULL, "sumsales", "rk" IS NULL, "rk"
LIMIT 100
;
