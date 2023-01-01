SELECT *
FROM (SELECT "t18"."c_last_name", "t18"."c_first_name", SUM("t18"."""*""") AS "sales"
FROM (SELECT "t5"."cs_bill_customer_sk", "t5"."c_first_name", "t5"."c_last_name", "t5"."""*""" AS "*"
FROM (SELECT "t1"."cs_bill_customer_sk", "t1"."cs_item_sk", "t1"."c_first_name", "t1"."c_last_name", "t1"."""*""" AS "*"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_bill_customer_sk", "t"."cs_item_sk", "t0"."c_first_name", "t0"."c_last_name", "t"."""*""" AS "*"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_item_sk", "cs_quantity" * "cs_list_price" AS "*"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t"
INNER JOIN (SELECT "c_customer_sk", "c_first_name", "c_last_name"
FROM tpcds.sf1000.customer AS customer) AS "t0" ON "t"."cs_bill_customer_sk" = "t0"."c_customer_sk") AS "t1"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 2000 AND "d_moy" = 2) AS "t4" ON "t1"."cs_sold_date_sk" = "t4"."d_date_sk") AS "t5"
INNER JOIN (SELECT "t12"."i_item_sk" AS "item_sk"
FROM (SELECT "t6"."ss_item_sk", "t9"."d_date"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t6"
INNER JOIN (SELECT "d_date_sk", "d_date"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 2000 OR "d_year" = 2000 + 1 OR "d_year" = 2000 + 2 OR "d_year" = 2000 + 3) AS "t9" ON "t6"."ss_sold_date_sk" = "t9"."d_date_sk") AS "t10"
INNER JOIN (SELECT SUBSTR("i_item_desc", 1, 30) AS "itemdesc", "i_item_sk"
FROM tpcds.sf1000.item AS item) AS "t12" ON "t10"."ss_item_sk" = "t12"."i_item_sk"
GROUP BY "t12"."itemdesc", "t12"."i_item_sk", "t10"."d_date"
HAVING COUNT(*) > 4) AS "t17" ON "t5"."cs_item_sk" = "t17"."item_sk") AS "t18"
INNER JOIN (SELECT "t21"."c_customer_sk"
FROM (SELECT "t20"."c_customer_sk", "t19"."""*""" AS "*"
FROM (SELECT "ss_customer_sk", "ss_quantity" * "ss_sales_price" AS "*"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t19"
INNER JOIN (SELECT "c_customer_sk"
FROM tpcds.sf1000.customer AS customer) AS "t20" ON "t19"."ss_customer_sk" = "t20"."c_customer_sk") AS "t21",
(SELECT MAX("t30"."csales") AS "tpcds_cmax"
FROM (SELECT SUM("t24"."""*""") AS "csales"
FROM (SELECT "t22"."ss_sold_date_sk", "t23"."c_customer_sk", "t22"."""*""" AS "*"
FROM (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_quantity" * "ss_sales_price" AS "*"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t22"
INNER JOIN (SELECT "c_customer_sk"
FROM tpcds.sf1000.customer AS customer) AS "t23" ON "t22"."ss_customer_sk" = "t23"."c_customer_sk") AS "t24"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 2000 OR "d_year" = 2000 + 1 OR "d_year" = 2000 + 2 OR "d_year" = 2000 + 3) AS "t27" ON "t24"."ss_sold_date_sk" = "t27"."d_date_sk"
GROUP BY "t24"."c_customer_sk") AS "t30") AS "t32"
GROUP BY "t21"."c_customer_sk"
HAVING SUM("t21"."""*""") > 50 / 100.0 * MAX("t32"."tpcds_cmax")) AS "t36" ON "t18"."cs_bill_customer_sk" = "t36"."c_customer_sk"
GROUP BY "t18"."c_last_name", "t18"."c_first_name"
UNION ALL
SELECT "t58"."c_last_name", "t58"."c_first_name", SUM("t58"."""*""") AS "sales"
FROM (SELECT "t45"."ws_bill_customer_sk", "t45"."c_first_name", "t45"."c_last_name", "t45"."""*""" AS "*"
FROM (SELECT "t41"."ws_item_sk", "t41"."ws_bill_customer_sk", "t41"."c_first_name", "t41"."c_last_name", "t41"."""*""" AS "*"
FROM (SELECT "t39"."ws_sold_date_sk", "t39"."ws_item_sk", "t39"."ws_bill_customer_sk", "t40"."c_first_name", "t40"."c_last_name", "t39"."""*""" AS "*"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_bill_customer_sk", "ws_quantity" * "ws_list_price" AS "*"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t39"
INNER JOIN (SELECT "c_customer_sk", "c_first_name", "c_last_name"
FROM tpcds.sf1000.customer AS customer) AS "t40" ON "t39"."ws_bill_customer_sk" = "t40"."c_customer_sk") AS "t41"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 2000 AND "d_moy" = 2) AS "t44" ON "t41"."ws_sold_date_sk" = "t44"."d_date_sk") AS "t45"
INNER JOIN (SELECT "t52"."i_item_sk" AS "item_sk"
FROM (SELECT "t46"."ss_item_sk", "t49"."d_date"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t46"
INNER JOIN (SELECT "d_date_sk", "d_date"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 2000 OR "d_year" = 2000 + 1 OR "d_year" = 2000 + 2 OR "d_year" = 2000 + 3) AS "t49" ON "t46"."ss_sold_date_sk" = "t49"."d_date_sk") AS "t50"
INNER JOIN (SELECT SUBSTR("i_item_desc", 1, 30) AS "itemdesc", "i_item_sk"
FROM tpcds.sf1000.item AS item) AS "t52" ON "t50"."ss_item_sk" = "t52"."i_item_sk"
GROUP BY "t52"."itemdesc", "t52"."i_item_sk", "t50"."d_date"
HAVING COUNT(*) > 4) AS "t57" ON "t45"."ws_item_sk" = "t57"."item_sk") AS "t58"
INNER JOIN (SELECT "t61"."c_customer_sk"
FROM (SELECT "t60"."c_customer_sk", "t59"."""*""" AS "*"
FROM (SELECT "ss_customer_sk", "ss_quantity" * "ss_sales_price" AS "*"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t59"
INNER JOIN (SELECT "c_customer_sk"
FROM tpcds.sf1000.customer AS customer) AS "t60" ON "t59"."ss_customer_sk" = "t60"."c_customer_sk") AS "t61",
(SELECT MAX("t70"."csales") AS "tpcds_cmax"
FROM (SELECT SUM("t64"."""*""") AS "csales"
FROM (SELECT "t62"."ss_sold_date_sk", "t63"."c_customer_sk", "t62"."""*""" AS "*"
FROM (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_quantity" * "ss_sales_price" AS "*"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t62"
INNER JOIN (SELECT "c_customer_sk"
FROM tpcds.sf1000.customer AS customer) AS "t63" ON "t62"."ss_customer_sk" = "t63"."c_customer_sk") AS "t64"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 2000 OR "d_year" = 2000 + 1 OR "d_year" = 2000 + 2 OR "d_year" = 2000 + 3) AS "t67" ON "t64"."ss_sold_date_sk" = "t67"."d_date_sk"
GROUP BY "t64"."c_customer_sk") AS "t70") AS "t72"
GROUP BY "t61"."c_customer_sk"
HAVING SUM("t61"."""*""") > 50 / 100.0 * MAX("t72"."tpcds_cmax")) AS "t76" ON "t58"."ws_bill_customer_sk" = "t76"."c_customer_sk"
GROUP BY "t58"."c_last_name", "t58"."c_first_name") AS "t79"
ORDER BY "c_last_name", "c_first_name", "sales"
LIMIT 100

