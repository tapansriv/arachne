SELECT "t54"."customer_id0" AS "customer_id", "t54"."customer_first_name0" AS "customer_first_name", "t54"."customer_last_name0" AS "customer_last_name", "t54"."customer_preferred_cust_flag0" AS "customer_preferred_cust_flag"
FROM (SELECT "t35"."customer_id", "t35"."customer_id0", "t35"."customer_first_name0", "t35"."customer_last_name0", "t35"."customer_preferred_cust_flag0", "t53"."year_total" AS "year_total1", "t53".">", "t35"."CASE"
FROM (SELECT "t16"."customer_id", "t34"."customer_id" AS "customer_id0", "t34"."customer_first_name" AS "customer_first_name0", "t34"."customer_last_name" AS "customer_last_name0", "t34"."customer_preferred_cust_flag" AS "customer_preferred_cust_flag0", CASE WHEN "t16".">" THEN "t34"."*" / "t16"."year_total" ELSE 0.0 END AS "CASE"
FROM (SELECT "customer_id", "year_total", "year_total" > 0 AS ">"
FROM (SELECT "t1"."c_customer_id" AS "customer_id", "t1"."c_first_name" AS "customer_first_name", "t1"."c_last_name" AS "customer_last_name", "t1"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t1"."c_birth_country" AS "customer_birth_country", "t1"."c_login" AS "customer_login", "t1"."c_email_address" AS "customer_email_address", "t2"."d_year" AS "dyear", SUM("t1"."-") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t"."c_customer_id", "t"."c_first_name", "t"."c_last_name", "t"."c_preferred_cust_flag", "t"."c_birth_country", "t"."c_login", "t"."c_email_address", "t0"."ss_sold_date_sk", "t0"."-"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM customer) AS "t"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_ext_list_price" - "ss_ext_discount_amt" AS "-"
FROM store_sales) AS "t0" ON "t"."c_customer_sk" = "t0"."ss_customer_sk") AS "t1"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t2" ON "t1"."ss_sold_date_sk" = "t2"."d_date_sk"
GROUP BY "t1"."c_customer_id", "t1"."c_first_name", "t1"."c_last_name", "t1"."c_preferred_cust_flag", "t1"."c_birth_country", "t1"."c_login", "t1"."c_email_address", "t2"."d_year"
UNION ALL
SELECT "t8"."c_customer_id" AS "customer_id", "t8"."c_first_name" AS "customer_first_name", "t8"."c_last_name" AS "customer_last_name", "t8"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t8"."c_birth_country" AS "customer_birth_country", "t8"."c_login" AS "customer_login", "t8"."c_email_address" AS "customer_email_address", "t9"."d_year" AS "dyear", SUM("t8"."-") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t6"."c_customer_id", "t6"."c_first_name", "t6"."c_last_name", "t6"."c_preferred_cust_flag", "t6"."c_birth_country", "t6"."c_login", "t6"."c_email_address", "t7"."ws_sold_date_sk", "t7"."-"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM customer) AS "t6"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", "ws_ext_list_price" - "ws_ext_discount_amt" AS "-"
FROM web_sales) AS "t7" ON "t6"."c_customer_sk" = "t7"."ws_bill_customer_sk") AS "t8"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t9" ON "t8"."ws_sold_date_sk" = "t9"."d_date_sk"
GROUP BY "t8"."c_customer_id", "t8"."c_first_name", "t8"."c_last_name", "t8"."c_preferred_cust_flag", "t8"."c_birth_country", "t8"."c_login", "t8"."c_email_address", "t9"."d_year") AS "t13"
WHERE "sale_type" = 's' AND "dyear" = 2001 AND "year_total" > 0) AS "t16"
INNER JOIN (SELECT "customer_id", "customer_first_name", "customer_last_name", "customer_preferred_cust_flag", "year_total" * 1.0000 AS "*"
FROM (SELECT "t19"."c_customer_id" AS "customer_id", "t19"."c_first_name" AS "customer_first_name", "t19"."c_last_name" AS "customer_last_name", "t19"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t19"."c_birth_country" AS "customer_birth_country", "t19"."c_login" AS "customer_login", "t19"."c_email_address" AS "customer_email_address", "t20"."d_year" AS "dyear", SUM("t19"."-") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t17"."c_customer_id", "t17"."c_first_name", "t17"."c_last_name", "t17"."c_preferred_cust_flag", "t17"."c_birth_country", "t17"."c_login", "t17"."c_email_address", "t18"."ss_sold_date_sk", "t18"."-"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM customer) AS "t17"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_ext_list_price" - "ss_ext_discount_amt" AS "-"
FROM store_sales) AS "t18" ON "t17"."c_customer_sk" = "t18"."ss_customer_sk") AS "t19"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t20" ON "t19"."ss_sold_date_sk" = "t20"."d_date_sk"
GROUP BY "t19"."c_customer_id", "t19"."c_first_name", "t19"."c_last_name", "t19"."c_preferred_cust_flag", "t19"."c_birth_country", "t19"."c_login", "t19"."c_email_address", "t20"."d_year"
UNION ALL
SELECT "t26"."c_customer_id" AS "customer_id", "t26"."c_first_name" AS "customer_first_name", "t26"."c_last_name" AS "customer_last_name", "t26"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t26"."c_birth_country" AS "customer_birth_country", "t26"."c_login" AS "customer_login", "t26"."c_email_address" AS "customer_email_address", "t27"."d_year" AS "dyear", SUM("t26"."-") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t24"."c_customer_id", "t24"."c_first_name", "t24"."c_last_name", "t24"."c_preferred_cust_flag", "t24"."c_birth_country", "t24"."c_login", "t24"."c_email_address", "t25"."ws_sold_date_sk", "t25"."-"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM customer) AS "t24"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", "ws_ext_list_price" - "ws_ext_discount_amt" AS "-"
FROM web_sales) AS "t25" ON "t24"."c_customer_sk" = "t25"."ws_bill_customer_sk") AS "t26"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t27" ON "t26"."ws_sold_date_sk" = "t27"."d_date_sk"
GROUP BY "t26"."c_customer_id", "t26"."c_first_name", "t26"."c_last_name", "t26"."c_preferred_cust_flag", "t26"."c_birth_country", "t26"."c_login", "t26"."c_email_address", "t27"."d_year") AS "t31"
WHERE "sale_type" = 's' AND "dyear" = 2001 + 1) AS "t34" ON "t16"."customer_id" = "t34"."customer_id") AS "t35"
INNER JOIN (SELECT "customer_id", "year_total", "year_total" > 0 AS ">"
FROM (SELECT "t38"."c_customer_id" AS "customer_id", "t38"."c_first_name" AS "customer_first_name", "t38"."c_last_name" AS "customer_last_name", "t38"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t38"."c_birth_country" AS "customer_birth_country", "t38"."c_login" AS "customer_login", "t38"."c_email_address" AS "customer_email_address", "t39"."d_year" AS "dyear", SUM("t38"."-") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t36"."c_customer_id", "t36"."c_first_name", "t36"."c_last_name", "t36"."c_preferred_cust_flag", "t36"."c_birth_country", "t36"."c_login", "t36"."c_email_address", "t37"."ss_sold_date_sk", "t37"."-"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM customer) AS "t36"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_ext_list_price" - "ss_ext_discount_amt" AS "-"
FROM store_sales) AS "t37" ON "t36"."c_customer_sk" = "t37"."ss_customer_sk") AS "t38"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t39" ON "t38"."ss_sold_date_sk" = "t39"."d_date_sk"
GROUP BY "t38"."c_customer_id", "t38"."c_first_name", "t38"."c_last_name", "t38"."c_preferred_cust_flag", "t38"."c_birth_country", "t38"."c_login", "t38"."c_email_address", "t39"."d_year"
UNION ALL
SELECT "t45"."c_customer_id" AS "customer_id", "t45"."c_first_name" AS "customer_first_name", "t45"."c_last_name" AS "customer_last_name", "t45"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t45"."c_birth_country" AS "customer_birth_country", "t45"."c_login" AS "customer_login", "t45"."c_email_address" AS "customer_email_address", "t46"."d_year" AS "dyear", SUM("t45"."-") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t43"."c_customer_id", "t43"."c_first_name", "t43"."c_last_name", "t43"."c_preferred_cust_flag", "t43"."c_birth_country", "t43"."c_login", "t43"."c_email_address", "t44"."ws_sold_date_sk", "t44"."-"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM customer) AS "t43"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", "ws_ext_list_price" - "ws_ext_discount_amt" AS "-"
FROM web_sales) AS "t44" ON "t43"."c_customer_sk" = "t44"."ws_bill_customer_sk") AS "t45"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t46" ON "t45"."ws_sold_date_sk" = "t46"."d_date_sk"
GROUP BY "t45"."c_customer_id", "t45"."c_first_name", "t45"."c_last_name", "t45"."c_preferred_cust_flag", "t45"."c_birth_country", "t45"."c_login", "t45"."c_email_address", "t46"."d_year") AS "t50"
WHERE "sale_type" = 'w' AND "dyear" = 2001 AND "year_total" > 0) AS "t53" ON "t35"."customer_id" = "t53"."customer_id") AS "t54"
INNER JOIN (SELECT "customer_id", "year_total" * 1.0000 AS "*"
FROM (SELECT "t57"."c_customer_id" AS "customer_id", "t57"."c_first_name" AS "customer_first_name", "t57"."c_last_name" AS "customer_last_name", "t57"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t57"."c_birth_country" AS "customer_birth_country", "t57"."c_login" AS "customer_login", "t57"."c_email_address" AS "customer_email_address", "t58"."d_year" AS "dyear", SUM("t57"."-") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t55"."c_customer_id", "t55"."c_first_name", "t55"."c_last_name", "t55"."c_preferred_cust_flag", "t55"."c_birth_country", "t55"."c_login", "t55"."c_email_address", "t56"."ss_sold_date_sk", "t56"."-"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM customer) AS "t55"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_ext_list_price" - "ss_ext_discount_amt" AS "-"
FROM store_sales) AS "t56" ON "t55"."c_customer_sk" = "t56"."ss_customer_sk") AS "t57"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t58" ON "t57"."ss_sold_date_sk" = "t58"."d_date_sk"
GROUP BY "t57"."c_customer_id", "t57"."c_first_name", "t57"."c_last_name", "t57"."c_preferred_cust_flag", "t57"."c_birth_country", "t57"."c_login", "t57"."c_email_address", "t58"."d_year"
UNION ALL
SELECT "t64"."c_customer_id" AS "customer_id", "t64"."c_first_name" AS "customer_first_name", "t64"."c_last_name" AS "customer_last_name", "t64"."c_preferred_cust_flag" AS "customer_preferred_cust_flag", "t64"."c_birth_country" AS "customer_birth_country", "t64"."c_login" AS "customer_login", "t64"."c_email_address" AS "customer_email_address", "t65"."d_year" AS "dyear", SUM("t64"."-") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t62"."c_customer_id", "t62"."c_first_name", "t62"."c_last_name", "t62"."c_preferred_cust_flag", "t62"."c_birth_country", "t62"."c_login", "t62"."c_email_address", "t63"."ws_sold_date_sk", "t63"."-"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_country", "c_login", "c_email_address"
FROM customer) AS "t62"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", "ws_ext_list_price" - "ws_ext_discount_amt" AS "-"
FROM web_sales) AS "t63" ON "t62"."c_customer_sk" = "t63"."ws_bill_customer_sk") AS "t64"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t65" ON "t64"."ws_sold_date_sk" = "t65"."d_date_sk"
GROUP BY "t64"."c_customer_id", "t64"."c_first_name", "t64"."c_last_name", "t64"."c_preferred_cust_flag", "t64"."c_birth_country", "t64"."c_login", "t64"."c_email_address", "t65"."d_year") AS "t69"
WHERE "sale_type" = 'w' AND "dyear" = 2001 + 1) AS "t72" ON "t54"."customer_id" = "t72"."customer_id" AND CASE WHEN "t54".">" THEN "t72"."*" / "t54"."year_total1" ELSE 0.0 END > "t54"."CASE"
ORDER BY "t54"."customer_id0", "t54"."customer_first_name0", "t54"."customer_last_name0", "t54"."customer_preferred_cust_flag0"
LIMIT 100
;