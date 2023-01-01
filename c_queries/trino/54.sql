SELECT "t29"."SEGMENT", COUNT(*) AS "num_customers", "t29"."SEGMENT" * 50 AS "segment_base"
FROM (SELECT CAST(ROUND(SUM("t13"."ss_ext_sales_price") / 50) AS INTEGER) AS "SEGMENT"
FROM (SELECT "t11"."c_customer_sk", "t11"."ss_sold_date_sk", "t11"."ss_ext_sales_price"
FROM (SELECT "t9"."c_customer_sk", "t9"."ss_sold_date_sk", "t9"."ss_ext_sales_price", "t10"."ca_county", "t10"."ca_state"
FROM (SELECT "t7"."c_customer_sk", "t7"."c_current_addr_sk", "t8"."ss_sold_date_sk", "t8"."ss_ext_sales_price"
FROM (SELECT "c_customer_sk", "c_current_addr_sk"
FROM (SELECT *
FROM (SELECT "cs_sold_date_sk" AS "sold_date_sk", "cs_bill_customer_sk" AS "customer_sk", "cs_item_sk" AS "item_sk"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t"
INNER JOIN (SELECT *
FROM tpcds.sf1000.item AS item
WHERE "i_category" = 'Women' AND "i_class" = 'maternity') AS "t0" ON "t"."item_sk" = "t0"."i_item_sk"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_moy" = 12 AND "d_year" = 1998) AS "t1" ON "t"."sold_date_sk" = "t1"."d_date_sk"
INNER JOIN tpcds.sf1000.customer AS customer ON "t"."customer_sk" = "customer"."c_customer_sk"
UNION ALL
SELECT *
FROM (SELECT "ws_sold_date_sk" AS "sold_date_sk", "ws_bill_customer_sk" AS "customer_sk", "ws_item_sk" AS "item_sk"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t2"
INNER JOIN (SELECT *
FROM tpcds.sf1000.item AS item
WHERE "i_category" = 'Women' AND "i_class" = 'maternity') AS "t3" ON "t2"."item_sk" = "t3"."i_item_sk"
INNER JOIN (SELECT *
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_moy" = 12 AND "d_year" = 1998) AS "t4" ON "t2"."sold_date_sk" = "t4"."d_date_sk"
INNER JOIN tpcds.sf1000.customer AS "customer0" ON "t2"."customer_sk" = "customer0"."c_customer_sk") AS "t5"
GROUP BY "c_customer_sk", "c_current_addr_sk") AS "t7"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_ext_sales_price"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t8" ON "t7"."c_customer_sk" = "t8"."ss_customer_sk") AS "t9"
INNER JOIN (SELECT "ca_address_sk", "ca_county", "ca_state"
FROM tpcds.sf1000.customer_address AS customer_address) AS "t10" ON "t9"."c_current_addr_sk" = "t10"."ca_address_sk") AS "t11"
INNER JOIN (SELECT "s_county", "s_state"
FROM tpcds.sf1000.store AS store) AS "t12" ON "t11"."ca_county" = "t12"."s_county" AND "t11"."ca_state" = "t12"."s_state") AS "t13"
INNER JOIN (SELECT "date_dim1"."d_date_sk"
FROM tpcds.sf1000.date_dim AS "date_dim1"
LEFT JOIN (SELECT SINGLE_VALUE("EXPR$0") AS "$f0"
FROM (SELECT "d_month_seq" + 1 AS "EXPR$0"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_moy" = 12 AND "d_year" = 1998
GROUP BY "d_month_seq" + 1) AS "t17") AS "t18" ON TRUE
LEFT JOIN (SELECT SINGLE_VALUE("EXPR$0") AS "$f0"
FROM (SELECT "d_month_seq" + 3 AS "EXPR$0"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_moy" = 12 AND "d_year" = 1998
GROUP BY "d_month_seq" + 3) AS "t22") AS "t23" ON TRUE
WHERE "date_dim1"."d_month_seq" >= "t18"."$f0" AND "date_dim1"."d_month_seq" <= "t23"."$f0") AS "t26" ON "t13"."ss_sold_date_sk" = "t26"."d_date_sk"
GROUP BY "t13"."c_customer_sk") AS "t29"
GROUP BY "t29"."SEGMENT"
ORDER BY "t29"."SEGMENT", COUNT(*), "t29"."SEGMENT" * 50 IS NULL, "t29"."SEGMENT" * 50
LIMIT 100

