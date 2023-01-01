SELECT COUNT(*)
FROM (SELECT *
FROM (SELECT "t4"."c_last_name", "t4"."c_first_name", "t3"."d_date"
FROM (SELECT "t"."ss_customer_sk", "t2"."d_date"
FROM (SELECT "ss_sold_date_sk", "ss_customer_sk"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_date"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "c_customer_sk", "c_first_name", "c_last_name"
FROM tpcds.sf1000.customer AS customer) AS "t4" ON "t3"."ss_customer_sk" = "t4"."c_customer_sk"
GROUP BY "t4"."c_last_name", "t4"."c_first_name", "t3"."d_date"
EXCEPT
SELECT "t12"."c_last_name", "t12"."c_first_name", "t11"."d_date"
FROM (SELECT "t7"."cs_bill_customer_sk", "t10"."d_date"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t7"
INNER JOIN (SELECT "d_date_sk", "d_date"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t10" ON "t7"."cs_sold_date_sk" = "t10"."d_date_sk") AS "t11"
INNER JOIN (SELECT "c_customer_sk", "c_first_name", "c_last_name"
FROM tpcds.sf1000.customer AS customer) AS "t12" ON "t11"."cs_bill_customer_sk" = "t12"."c_customer_sk"
GROUP BY "t12"."c_last_name", "t12"."c_first_name", "t11"."d_date") AS "t"
EXCEPT
SELECT "t21"."c_last_name", "t21"."c_first_name", "t20"."d_date"
FROM (SELECT "t16"."ws_bill_customer_sk", "t19"."d_date"
FROM (SELECT "ws_sold_date_sk", "ws_bill_customer_sk"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t16"
INNER JOIN (SELECT "d_date_sk", "d_date"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t19" ON "t16"."ws_sold_date_sk" = "t19"."d_date_sk") AS "t20"
INNER JOIN (SELECT "c_customer_sk", "c_first_name", "c_last_name"
FROM tpcds.sf1000.customer AS customer) AS "t21" ON "t20"."ws_bill_customer_sk" = "t21"."c_customer_sk"
GROUP BY "t21"."c_last_name", "t21"."c_first_name", "t20"."d_date") AS "t24"

