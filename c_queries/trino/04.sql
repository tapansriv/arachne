SELECT "t133"."customer_id0" AS "customer_id", "t133"."customer_first_name0" AS "customer_first_name", "t133"."customer_last_name0" AS "customer_last_name", "t133"."customer_preferred_cust_flag0" AS "customer_preferred_cust_flag"
FROM (SELECT "t105"."customer_id", "t105"."customer_id0", "t105"."customer_first_name0", "t105"."customer_last_name0", "t105"."customer_preferred_cust_flag0", "t131"."year_total" AS "year_total3", "t105"."CASE", "t131".">"
FROM (SELECT "t78"."customer_id", "t78"."customer_id0", "t78"."customer_first_name0", "t78"."customer_last_name0", "t78"."customer_preferred_cust_flag0", CASE WHEN "t78".">" THEN "t104"."year_total" / "t78"."year_total1" ELSE NULL END AS "CASE"
FROM (SELECT "t51"."customer_id", "t51"."customer_id0", "t51"."customer_first_name0", "t51"."customer_last_name0", "t51"."customer_preferred_cust_flag0", "t77"."year_total" AS "year_total1", "t77".">", "t51"."CASE"
FROM (SELECT "t24"."customer_id", "t50"."customer_id" AS "customer_id0", "t50"."customer_first_name" AS "customer_first_name0", "t50"."customer_last_name" AS "customer_last_name0", "t50"."customer_preferred_cust_flag" AS "customer_preferred_cust_flag0", CASE WHEN "t24".">" THEN "t50"."year_total" / "t24"."year_total" ELSE NULL END AS "CASE"
FROM (SELECT "customer_id", "year_total", "year_total" > 0 AS ">"
FROM (SELECT *
FROM (SELECT "t1"."c_customer_id" AS "customer_id", "t1"."c_first_name" AS "customer_first_name", "t1"."c_last_name" AS "customer_last_name", "t1"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t1"."c_birth_country" AS "customer_birth_country", "t1"."c_login" AS "customer_login", "t1"."c_email_address" AS "customer_email_address", "t2"."d_year" AS "dyear", SUM("t1"."/") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t"."c_customer_id", "t"."c_first_name", "t"."c_last_name", "t"."c_preferred_cust_flag", "t"."c_birth_country", "t"."c_login", "t"."c_email_address", "t0"."ss_sold_date_sk", "t0"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", ("ss_ext_list_price" - "ss_ext_wholesale_cost" - "ss_ext_discount_amt" + "ss_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t0" ON "t"."c_customer_sk" = "t0"."ss_customer_sk") AS "t1"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t2" ON "t1"."ss_sold_date_sk" = "t2"."d_date_sk"
GROUP BY "t1"."c_customer_id", "t1"."c_first_name", "t1"."c_last_name", "t1"."c_preferred_cust_flag", "t1"."c_birth_country", "t1"."c_login", "t1"."c_email_address", "t2"."d_year"
UNION ALL
SELECT "t8"."c_customer_id" AS "customer_id", "t8"."c_first_name" AS "customer_first_name", "t8"."c_last_name" AS "customer_last_name", "t8"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t8"."c_birth_country" AS "customer_birth_country", "t8"."c_login" AS "customer_login", "t8"."c_email_address" AS "customer_email_address", "t9"."d_year" AS "dyear", SUM("t8"."/") AS "year_total", 'c' AS "sale_type"
FROM (SELECT "t6"."c_customer_id", "t6"."c_first_name", "t6"."c_last_name", "t6"."c_preferred_cust_flag", "t6"."c_birth_country", "t6"."c_login", "t6"."c_email_address", "t7"."cs_sold_date_sk", "t7"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t6"
INNER JOIN (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", ("cs_ext_list_price" - "cs_ext_wholesale_cost" - "cs_ext_discount_amt" + "cs_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t7" ON "t6"."c_customer_sk" = "t7"."cs_bill_customer_sk") AS "t8"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t9" ON "t8"."cs_sold_date_sk" = "t9"."d_date_sk"
GROUP BY "t8"."c_customer_id", "t8"."c_first_name", "t8"."c_last_name", "t8"."c_preferred_cust_flag", "t8"."c_birth_country", "t8"."c_login", "t8"."c_email_address", "t9"."d_year") AS "t"
UNION ALL
SELECT "t16"."c_customer_id" AS "customer_id", "t16"."c_first_name" AS "customer_first_name", "t16"."c_last_name" AS "customer_last_name", "t16"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t16"."c_birth_country" AS "customer_birth_country", "t16"."c_login" AS "customer_login", "t16"."c_email_address" AS "customer_email_address", "t17"."d_year" AS "dyear", SUM("t16"."/") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t14"."c_customer_id", "t14"."c_first_name", "t14"."c_last_name", "t14"."c_preferred_cust_flag", "t14"."c_birth_country", "t14"."c_login", "t14"."c_email_address", "t15"."ws_sold_date_sk", "t15"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t14"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", ("ws_ext_list_price" - "ws_ext_wholesale_cost" - "ws_ext_discount_amt" + "ws_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t15" ON "t14"."c_customer_sk" = "t15"."ws_bill_customer_sk") AS "t16"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t17" ON "t16"."ws_sold_date_sk" = "t17"."d_date_sk"
GROUP BY "t16"."c_customer_id", "t16"."c_first_name", "t16"."c_last_name", "t16"."c_preferred_cust_flag", "t16"."c_birth_country", "t16"."c_login", "t16"."c_email_address", "t17"."d_year") AS "t21"
WHERE "sale_type" = 's' AND "dyear" = 2001 AND "year_total" > 0) AS "t24"
INNER JOIN (SELECT "customer_id", "customer_first_name", "customer_last_name", "customer_preferred_cust_flag", "year_total"
FROM (SELECT *
FROM (SELECT "t27"."c_customer_id" AS "customer_id", "t27"."c_first_name" AS "customer_first_name", "t27"."c_last_name" AS "customer_last_name", "t27"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t27"."c_birth_country" AS "customer_birth_country", "t27"."c_login" AS "customer_login", "t27"."c_email_address" AS "customer_email_address", "t28"."d_year" AS "dyear", SUM("t27"."/") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t25"."c_customer_id", "t25"."c_first_name", "t25"."c_last_name", "t25"."c_preferred_cust_flag", "t25"."c_birth_country", "t25"."c_login", "t25"."c_email_address", "t26"."ss_sold_date_sk", "t26"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t25"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", ("ss_ext_list_price" - "ss_ext_wholesale_cost" - "ss_ext_discount_amt" + "ss_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t26" ON "t25"."c_customer_sk" = "t26"."ss_customer_sk") AS "t27"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t28" ON "t27"."ss_sold_date_sk" = "t28"."d_date_sk"
GROUP BY "t27"."c_customer_id", "t27"."c_first_name", "t27"."c_last_name", "t27"."c_preferred_cust_flag", "t27"."c_birth_country", "t27"."c_login", "t27"."c_email_address", "t28"."d_year"
UNION ALL
SELECT "t34"."c_customer_id" AS "customer_id", "t34"."c_first_name" AS "customer_first_name", "t34"."c_last_name" AS "customer_last_name", "t34"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t34"."c_birth_country" AS "customer_birth_country", "t34"."c_login" AS "customer_login", "t34"."c_email_address" AS "customer_email_address", "t35"."d_year" AS "dyear", SUM("t34"."/") AS "year_total", 'c' AS "sale_type"
FROM (SELECT "t32"."c_customer_id", "t32"."c_first_name", "t32"."c_last_name", "t32"."c_preferred_cust_flag", "t32"."c_birth_country", "t32"."c_login", "t32"."c_email_address", "t33"."cs_sold_date_sk", "t33"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t32"
INNER JOIN (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", ("cs_ext_list_price" - "cs_ext_wholesale_cost" - "cs_ext_discount_amt" + "cs_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t33" ON "t32"."c_customer_sk" = "t33"."cs_bill_customer_sk") AS "t34"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t35" ON "t34"."cs_sold_date_sk" = "t35"."d_date_sk"
GROUP BY "t34"."c_customer_id", "t34"."c_first_name", "t34"."c_last_name", "t34"."c_preferred_cust_flag", "t34"."c_birth_country", "t34"."c_login", "t34"."c_email_address", "t35"."d_year") AS "t"
UNION ALL
SELECT "t42"."c_customer_id" AS "customer_id", "t42"."c_first_name" AS "customer_first_name", "t42"."c_last_name" AS "customer_last_name", "t42"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t42"."c_birth_country" AS "customer_birth_country", "t42"."c_login" AS "customer_login", "t42"."c_email_address" AS "customer_email_address", "t43"."d_year" AS "dyear", SUM("t42"."/") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t40"."c_customer_id", "t40"."c_first_name", "t40"."c_last_name", "t40"."c_preferred_cust_flag", "t40"."c_birth_country", "t40"."c_login", "t40"."c_email_address", "t41"."ws_sold_date_sk", "t41"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t40"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", ("ws_ext_list_price" - "ws_ext_wholesale_cost" - "ws_ext_discount_amt" + "ws_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t41" ON "t40"."c_customer_sk" = "t41"."ws_bill_customer_sk") AS "t42"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t43" ON "t42"."ws_sold_date_sk" = "t43"."d_date_sk"
GROUP BY "t42"."c_customer_id", "t42"."c_first_name", "t42"."c_last_name", "t42"."c_preferred_cust_flag", "t42"."c_birth_country", "t42"."c_login", "t42"."c_email_address", "t43"."d_year") AS "t47"
WHERE "sale_type" = 's' AND "dyear" = 2001 + 1) AS "t50" ON "t24"."customer_id" = "t50"."customer_id") AS "t51"
INNER JOIN (SELECT "customer_id", "year_total", "year_total" > 0 AS ">"
FROM (SELECT *
FROM (SELECT "t54"."c_customer_id" AS "customer_id", "t54"."c_first_name" AS "customer_first_name", "t54"."c_last_name" AS "customer_last_name", "t54"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t54"."c_birth_country" AS "customer_birth_country", "t54"."c_login" AS "customer_login", "t54"."c_email_address" AS "customer_email_address", "t55"."d_year" AS "dyear", SUM("t54"."/") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t52"."c_customer_id", "t52"."c_first_name", "t52"."c_last_name", "t52"."c_preferred_cust_flag", "t52"."c_birth_country", "t52"."c_login", "t52"."c_email_address", "t53"."ss_sold_date_sk", "t53"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t52"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", ("ss_ext_list_price" - "ss_ext_wholesale_cost" - "ss_ext_discount_amt" + "ss_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t53" ON "t52"."c_customer_sk" = "t53"."ss_customer_sk") AS "t54"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t55" ON "t54"."ss_sold_date_sk" = "t55"."d_date_sk"
GROUP BY "t54"."c_customer_id", "t54"."c_first_name", "t54"."c_last_name", "t54"."c_preferred_cust_flag", "t54"."c_birth_country", "t54"."c_login", "t54"."c_email_address", "t55"."d_year"
UNION ALL
SELECT "t61"."c_customer_id" AS "customer_id", "t61"."c_first_name" AS "customer_first_name", "t61"."c_last_name" AS "customer_last_name", "t61"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t61"."c_birth_country" AS "customer_birth_country", "t61"."c_login" AS "customer_login", "t61"."c_email_address" AS "customer_email_address", "t62"."d_year" AS "dyear", SUM("t61"."/") AS "year_total", 'c' AS "sale_type"
FROM (SELECT "t59"."c_customer_id", "t59"."c_first_name", "t59"."c_last_name", "t59"."c_preferred_cust_flag", "t59"."c_birth_country", "t59"."c_login", "t59"."c_email_address", "t60"."cs_sold_date_sk", "t60"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t59"
INNER JOIN (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", ("cs_ext_list_price" - "cs_ext_wholesale_cost" - "cs_ext_discount_amt" + "cs_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t60" ON "t59"."c_customer_sk" = "t60"."cs_bill_customer_sk") AS "t61"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t62" ON "t61"."cs_sold_date_sk" = "t62"."d_date_sk"
GROUP BY "t61"."c_customer_id", "t61"."c_first_name", "t61"."c_last_name", "t61"."c_preferred_cust_flag", "t61"."c_birth_country", "t61"."c_login", "t61"."c_email_address", "t62"."d_year") AS "t"
UNION ALL
SELECT "t69"."c_customer_id" AS "customer_id", "t69"."c_first_name" AS "customer_first_name", "t69"."c_last_name" AS "customer_last_name", "t69"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t69"."c_birth_country" AS "customer_birth_country", "t69"."c_login" AS "customer_login", "t69"."c_email_address" AS "customer_email_address", "t70"."d_year" AS "dyear", SUM("t69"."/") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t67"."c_customer_id", "t67"."c_first_name", "t67"."c_last_name", "t67"."c_preferred_cust_flag", "t67"."c_birth_country", "t67"."c_login", "t67"."c_email_address", "t68"."ws_sold_date_sk", "t68"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t67"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", ("ws_ext_list_price" - "ws_ext_wholesale_cost" - "ws_ext_discount_amt" + "ws_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t68" ON "t67"."c_customer_sk" = "t68"."ws_bill_customer_sk") AS "t69"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t70" ON "t69"."ws_sold_date_sk" = "t70"."d_date_sk"
GROUP BY "t69"."c_customer_id", "t69"."c_first_name", "t69"."c_last_name", "t69"."c_preferred_cust_flag", "t69"."c_birth_country", "t69"."c_login", "t69"."c_email_address", "t70"."d_year") AS "t74"
WHERE "sale_type" = 'c' AND "dyear" = 2001 AND "year_total" > 0) AS "t77" ON "t51"."customer_id" = "t77"."customer_id") AS "t78"
INNER JOIN (SELECT "customer_id", "year_total"
FROM (SELECT *
FROM (SELECT "t81"."c_customer_id" AS "customer_id", "t81"."c_first_name" AS "customer_first_name", "t81"."c_last_name" AS "customer_last_name", "t81"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t81"."c_birth_country" AS "customer_birth_country", "t81"."c_login" AS "customer_login", "t81"."c_email_address" AS "customer_email_address", "t82"."d_year" AS "dyear", SUM("t81"."/") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t79"."c_customer_id", "t79"."c_first_name", "t79"."c_last_name", "t79"."c_preferred_cust_flag", "t79"."c_birth_country", "t79"."c_login", "t79"."c_email_address", "t80"."ss_sold_date_sk", "t80"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t79"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", ("ss_ext_list_price" - "ss_ext_wholesale_cost" - "ss_ext_discount_amt" + "ss_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t80" ON "t79"."c_customer_sk" = "t80"."ss_customer_sk") AS "t81"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t82" ON "t81"."ss_sold_date_sk" = "t82"."d_date_sk"
GROUP BY "t81"."c_customer_id", "t81"."c_first_name", "t81"."c_last_name", "t81"."c_preferred_cust_flag", "t81"."c_birth_country", "t81"."c_login", "t81"."c_email_address", "t82"."d_year"
UNION ALL
SELECT "t88"."c_customer_id" AS "customer_id", "t88"."c_first_name" AS "customer_first_name", "t88"."c_last_name" AS "customer_last_name", "t88"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t88"."c_birth_country" AS "customer_birth_country", "t88"."c_login" AS "customer_login", "t88"."c_email_address" AS "customer_email_address", "t89"."d_year" AS "dyear", SUM("t88"."/") AS "year_total", 'c' AS "sale_type"
FROM (SELECT "t86"."c_customer_id", "t86"."c_first_name", "t86"."c_last_name", "t86"."c_preferred_cust_flag", "t86"."c_birth_country", "t86"."c_login", "t86"."c_email_address", "t87"."cs_sold_date_sk", "t87"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t86"
INNER JOIN (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", ("cs_ext_list_price" - "cs_ext_wholesale_cost" - "cs_ext_discount_amt" + "cs_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t87" ON "t86"."c_customer_sk" = "t87"."cs_bill_customer_sk") AS "t88"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t89" ON "t88"."cs_sold_date_sk" = "t89"."d_date_sk"
GROUP BY "t88"."c_customer_id", "t88"."c_first_name", "t88"."c_last_name", "t88"."c_preferred_cust_flag", "t88"."c_birth_country", "t88"."c_login", "t88"."c_email_address", "t89"."d_year") AS "t"
UNION ALL
SELECT "t96"."c_customer_id" AS "customer_id", "t96"."c_first_name" AS "customer_first_name", "t96"."c_last_name" AS "customer_last_name", "t96"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t96"."c_birth_country" AS "customer_birth_country", "t96"."c_login" AS "customer_login", "t96"."c_email_address" AS "customer_email_address", "t97"."d_year" AS "dyear", SUM("t96"."/") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t94"."c_customer_id", "t94"."c_first_name", "t94"."c_last_name", "t94"."c_preferred_cust_flag", "t94"."c_birth_country", "t94"."c_login", "t94"."c_email_address", "t95"."ws_sold_date_sk", "t95"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t94"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", ("ws_ext_list_price" - "ws_ext_wholesale_cost" - "ws_ext_discount_amt" + "ws_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t95" ON "t94"."c_customer_sk" = "t95"."ws_bill_customer_sk") AS "t96"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t97" ON "t96"."ws_sold_date_sk" = "t97"."d_date_sk"
GROUP BY "t96"."c_customer_id", "t96"."c_first_name", "t96"."c_last_name", "t96"."c_preferred_cust_flag", "t96"."c_birth_country", "t96"."c_login", "t96"."c_email_address", "t97"."d_year") AS "t101"
WHERE "sale_type" = 'c' AND "dyear" = 2001 + 1) AS "t104" ON "t78"."customer_id" = "t104"."customer_id" AND CASE WHEN "t78".">" THEN "t104"."year_total" / "t78"."year_total1" ELSE NULL END > "t78"."CASE") AS "t105"
INNER JOIN (SELECT "customer_id", "year_total", "year_total" > 0 AS ">"
FROM (SELECT *
FROM (SELECT "t108"."c_customer_id" AS "customer_id", "t108"."c_first_name" AS "customer_first_name", "t108"."c_last_name" AS "customer_last_name", "t108"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t108"."c_birth_country" AS "customer_birth_country", "t108"."c_login" AS "customer_login", "t108"."c_email_address" AS "customer_email_address", "t109"."d_year" AS "dyear", SUM("t108"."/") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t106"."c_customer_id", "t106"."c_first_name", "t106"."c_last_name", "t106"."c_preferred_cust_flag", "t106"."c_birth_country", "t106"."c_login", "t106"."c_email_address", "t107"."ss_sold_date_sk", "t107"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t106"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", ("ss_ext_list_price" - "ss_ext_wholesale_cost" - "ss_ext_discount_amt" + "ss_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t107" ON "t106"."c_customer_sk" = "t107"."ss_customer_sk") AS "t108"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t109" ON "t108"."ss_sold_date_sk" = "t109"."d_date_sk"
GROUP BY "t108"."c_customer_id", "t108"."c_first_name", "t108"."c_last_name", "t108"."c_preferred_cust_flag", "t108"."c_birth_country", "t108"."c_login", "t108"."c_email_address", "t109"."d_year"
UNION ALL
SELECT "t115"."c_customer_id" AS "customer_id", "t115"."c_first_name" AS "customer_first_name", "t115"."c_last_name" AS "customer_last_name", "t115"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t115"."c_birth_country" AS "customer_birth_country", "t115"."c_login" AS "customer_login", "t115"."c_email_address" AS "customer_email_address", "t116"."d_year" AS "dyear", SUM("t115"."/") AS "year_total", 'c' AS "sale_type"
FROM (SELECT "t113"."c_customer_id", "t113"."c_first_name", "t113"."c_last_name", "t113"."c_preferred_cust_flag", "t113"."c_birth_country", "t113"."c_login", "t113"."c_email_address", "t114"."cs_sold_date_sk", "t114"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t113"
INNER JOIN (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", ("cs_ext_list_price" - "cs_ext_wholesale_cost" - "cs_ext_discount_amt" + "cs_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t114" ON "t113"."c_customer_sk" = "t114"."cs_bill_customer_sk") AS "t115"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t116" ON "t115"."cs_sold_date_sk" = "t116"."d_date_sk"
GROUP BY "t115"."c_customer_id", "t115"."c_first_name", "t115"."c_last_name", "t115"."c_preferred_cust_flag", "t115"."c_birth_country", "t115"."c_login", "t115"."c_email_address", "t116"."d_year") AS "t"
UNION ALL
SELECT "t123"."c_customer_id" AS "customer_id", "t123"."c_first_name" AS "customer_first_name", "t123"."c_last_name" AS "customer_last_name", "t123"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t123"."c_birth_country" AS "customer_birth_country", "t123"."c_login" AS "customer_login", "t123"."c_email_address" AS "customer_email_address", "t124"."d_year" AS "dyear", SUM("t123"."/") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t121"."c_customer_id", "t121"."c_first_name", "t121"."c_last_name", "t121"."c_preferred_cust_flag", "t121"."c_birth_country", "t121"."c_login", "t121"."c_email_address", "t122"."ws_sold_date_sk", "t122"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t121"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", ("ws_ext_list_price" - "ws_ext_wholesale_cost" - "ws_ext_discount_amt" + "ws_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t122" ON "t121"."c_customer_sk" = "t122"."ws_bill_customer_sk") AS "t123"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t124" ON "t123"."ws_sold_date_sk" = "t124"."d_date_sk"
GROUP BY "t123"."c_customer_id", "t123"."c_first_name", "t123"."c_last_name", "t123"."c_preferred_cust_flag", "t123"."c_birth_country", "t123"."c_login", "t123"."c_email_address", "t124"."d_year") AS "t128"
WHERE "sale_type" = 'w' AND "dyear" = 2001 AND "year_total" > 0) AS "t131" ON "t105"."customer_id" = "t131"."customer_id") AS "t133"
INNER JOIN (SELECT "customer_id", "year_total"
FROM (SELECT *
FROM (SELECT "t136"."c_customer_id" AS "customer_id", "t136"."c_first_name" AS "customer_first_name", "t136"."c_last_name" AS "customer_last_name", "t136"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t136"."c_birth_country" AS "customer_birth_country", "t136"."c_login" AS "customer_login", "t136"."c_email_address" AS "customer_email_address", "t137"."d_year" AS "dyear", SUM("t136"."/") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t134"."c_customer_id", "t134"."c_first_name", "t134"."c_last_name", "t134"."c_preferred_cust_flag", "t134"."c_birth_country", "t134"."c_login", "t134"."c_email_address", "t135"."ss_sold_date_sk", "t135"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t134"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", ("ss_ext_list_price" - "ss_ext_wholesale_cost" - "ss_ext_discount_amt" + "ss_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t135" ON "t134"."c_customer_sk" = "t135"."ss_customer_sk") AS "t136"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t137" ON "t136"."ss_sold_date_sk" = "t137"."d_date_sk"
GROUP BY "t136"."c_customer_id", "t136"."c_first_name", "t136"."c_last_name", "t136"."c_preferred_cust_flag", "t136"."c_birth_country", "t136"."c_login", "t136"."c_email_address", "t137"."d_year"
UNION ALL
SELECT "t143"."c_customer_id" AS "customer_id", "t143"."c_first_name" AS "customer_first_name", "t143"."c_last_name" AS "customer_last_name", "t143"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t143"."c_birth_country" AS "customer_birth_country", "t143"."c_login" AS "customer_login", "t143"."c_email_address" AS "customer_email_address", "t144"."d_year" AS "dyear", SUM("t143"."/") AS "year_total", 'c' AS "sale_type"
FROM (SELECT "t141"."c_customer_id", "t141"."c_first_name", "t141"."c_last_name", "t141"."c_preferred_cust_flag", "t141"."c_birth_country", "t141"."c_login", "t141"."c_email_address", "t142"."cs_sold_date_sk", "t142"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t141"
INNER JOIN (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", ("cs_ext_list_price" - "cs_ext_wholesale_cost" - "cs_ext_discount_amt" + "cs_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t142" ON "t141"."c_customer_sk" = "t142"."cs_bill_customer_sk") AS "t143"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t144" ON "t143"."cs_sold_date_sk" = "t144"."d_date_sk"
GROUP BY "t143"."c_customer_id", "t143"."c_first_name", "t143"."c_last_name", "t143"."c_preferred_cust_flag", "t143"."c_birth_country", "t143"."c_login", "t143"."c_email_address", "t144"."d_year") AS "t"
UNION ALL
SELECT "t151"."c_customer_id" AS "customer_id", "t151"."c_first_name" AS "customer_first_name", "t151"."c_last_name" AS "customer_last_name", "t151"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t151"."c_birth_country" AS "customer_birth_country", "t151"."c_login" AS "customer_login", "t151"."c_email_address" AS "customer_email_address", "t152"."d_year" AS "dyear", SUM("t151"."/") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t149"."c_customer_id", "t149"."c_first_name", "t149"."c_last_name", "t149"."c_preferred_cust_flag", "t149"."c_birth_country", "t149"."c_login", "t149"."c_email_address", "t150"."ws_sold_date_sk", "t150"."/"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM tpcds.sf1000.customer AS customer) AS "t149"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", ("ws_ext_list_price" - "ws_ext_wholesale_cost" - "ws_ext_discount_amt" + "ws_ext_sales_price") / 2 AS "/"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t150" ON "t149"."c_customer_sk" = "t150"."ws_bill_customer_sk") AS "t151"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM tpcds.sf1000.date_dim AS date_dim) AS "t152" ON "t151"."ws_sold_date_sk" = "t152"."d_date_sk"
GROUP BY "t151"."c_customer_id", "t151"."c_first_name", "t151"."c_last_name", "t151"."c_preferred_cust_flag", "t151"."c_birth_country", "t151"."c_login", "t151"."c_email_address", "t152"."d_year") AS "t156"
WHERE "sale_type" = 'w' AND "dyear" = 2001 + 1) AS "t159" ON "t133"."customer_id" = "t159"."customer_id" AND "t133"."CASE" > CASE WHEN "t133".">" THEN CAST("t159"."year_total" / "t133"."year_total3" AS DECIMAL(19, 0)) ELSE NULL END
ORDER BY "t133"."customer_id0", "t133"."customer_first_name0", "t133"."customer_last_name0", "t133"."customer_preferred_cust_flag0"
LIMIT 100

