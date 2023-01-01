CREATE TABLE rs_table_74_0 AS SELECT "customer_id", "year_total"
FROM (SELECT "t1"."c_customer_id" AS "customer_id", "t1"."c_first_name" AS "customer_first_name", "t1"."c_last_name" AS "customer_last_name", "t3"."d_year" AS "year_", SUM("t1"."ss_net_paid") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t"."c_customer_id", "t"."c_first_name", "t"."c_last_name", "t0"."ss_sold_date_sk", "t0"."ss_net_paid"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name"
FROM customer) AS "t"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_net_paid"
FROM store_sales) AS "t0" ON "t"."c_customer_sk" = "t0"."ss_customer_sk") AS "t1"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim
WHERE "d_year" = 2001 OR "d_year" = 2001 + 1) AS "t3" ON "t1"."ss_sold_date_sk" = "t3"."d_date_sk"
GROUP BY "t1"."c_customer_id", "t1"."c_first_name", "t1"."c_last_name", "t3"."d_year"
UNION ALL
SELECT "t9"."c_customer_id" AS "customer_id", "t9"."c_first_name" AS "customer_first_name", "t9"."c_last_name" AS "customer_last_name", "t11"."d_year" AS "year_", SUM("t9"."ws_net_paid") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t7"."c_customer_id", "t7"."c_first_name", "t7"."c_last_name", "t8"."ws_sold_date_sk", "t8"."ws_net_paid"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name"
FROM customer) AS "t7"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", "ws_net_paid"
FROM web_sales) AS "t8" ON "t7"."c_customer_sk" = "t8"."ws_bill_customer_sk") AS "t9"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim
WHERE "d_year" = 2001 OR "d_year" = 2001 + 1) AS "t11" ON "t9"."ws_sold_date_sk" = "t11"."d_date_sk"
GROUP BY "t9"."c_customer_id", "t9"."c_first_name", "t9"."c_last_name", "t11"."d_year") AS "t15"
WHERE "sale_type" = 'w' AND "year_" = 2001 + 1
;
SELECT "t60"."customer_id0" AS "customer_id", "t60"."customer_first_name0" AS "customer_first_name", "t60"."customer_last_name0" AS "customer_last_name"
FROM (SELECT "t38"."customer_id", "t38"."customer_id0", "t38"."customer_first_name0", "t38"."customer_last_name0", "t58"."year_total" AS "year_total1", "t58".">", "t38"."CASE"
FROM (SELECT "t18"."customer_id", "t37"."customer_id" AS "customer_id0", "t37"."customer_first_name" AS "customer_first_name0", "t37"."customer_last_name" AS "customer_last_name0", CASE WHEN "t18".">" THEN "t37"."year_total" / "t18"."year_total" ELSE NULL END AS "CASE"
FROM (SELECT "customer_id", "year_total", "year_total" > 0 AS ">"
FROM (SELECT "t1"."c_customer_id" AS "customer_id", "t1"."c_first_name" AS "customer_first_name", "t1"."c_last_name" AS "customer_last_name", "t3"."d_year" AS "year_", SUM("t1"."ss_net_paid") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t"."c_customer_id", "t"."c_first_name", "t"."c_last_name", "t0"."ss_sold_date_sk", "t0"."ss_net_paid"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name"
FROM customer) AS "t"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_net_paid"
FROM store_sales) AS "t0" ON "t"."c_customer_sk" = "t0"."ss_customer_sk") AS "t1"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim
WHERE "d_year" = 2001 OR "d_year" = 2001 + 1) AS "t3" ON "t1"."ss_sold_date_sk" = "t3"."d_date_sk"
GROUP BY "t1"."c_customer_id", "t1"."c_first_name", "t1"."c_last_name", "t3"."d_year"
UNION ALL
SELECT "t9"."c_customer_id" AS "customer_id", "t9"."c_first_name" AS "customer_first_name", "t9"."c_last_name" AS "customer_last_name", "t11"."d_year" AS "year_", SUM("t9"."ws_net_paid") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t7"."c_customer_id", "t7"."c_first_name", "t7"."c_last_name", "t8"."ws_sold_date_sk", "t8"."ws_net_paid"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name"
FROM customer) AS "t7"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", "ws_net_paid"
FROM web_sales) AS "t8" ON "t7"."c_customer_sk" = "t8"."ws_bill_customer_sk") AS "t9"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim
WHERE "d_year" = 2001 OR "d_year" = 2001 + 1) AS "t11" ON "t9"."ws_sold_date_sk" = "t11"."d_date_sk"
GROUP BY "t9"."c_customer_id", "t9"."c_first_name", "t9"."c_last_name", "t11"."d_year") AS "t15"
WHERE "sale_type" = 's' AND "year_" = 2001 AND "year_total" > 0) AS "t18"
INNER JOIN (SELECT "customer_id", "customer_first_name", "customer_last_name", "year_total"
FROM (SELECT "t21"."c_customer_id" AS "customer_id", "t21"."c_first_name" AS "customer_first_name", "t21"."c_last_name" AS "customer_last_name", "t23"."d_year" AS "year_", SUM("t21"."ss_net_paid") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t19"."c_customer_id", "t19"."c_first_name", "t19"."c_last_name", "t20"."ss_sold_date_sk", "t20"."ss_net_paid"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name"
FROM customer) AS "t19"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_net_paid"
FROM store_sales) AS "t20" ON "t19"."c_customer_sk" = "t20"."ss_customer_sk") AS "t21"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim
WHERE "d_year" = 2001 OR "d_year" = 2001 + 1) AS "t23" ON "t21"."ss_sold_date_sk" = "t23"."d_date_sk"
GROUP BY "t21"."c_customer_id", "t21"."c_first_name", "t21"."c_last_name", "t23"."d_year"
UNION ALL
SELECT "t29"."c_customer_id" AS "customer_id", "t29"."c_first_name" AS "customer_first_name", "t29"."c_last_name" AS "customer_last_name", "t31"."d_year" AS "year_", SUM("t29"."ws_net_paid") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t27"."c_customer_id", "t27"."c_first_name", "t27"."c_last_name", "t28"."ws_sold_date_sk", "t28"."ws_net_paid"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name"
FROM customer) AS "t27"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", "ws_net_paid"
FROM web_sales) AS "t28" ON "t27"."c_customer_sk" = "t28"."ws_bill_customer_sk") AS "t29"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim
WHERE "d_year" = 2001 OR "d_year" = 2001 + 1) AS "t31" ON "t29"."ws_sold_date_sk" = "t31"."d_date_sk"
GROUP BY "t29"."c_customer_id", "t29"."c_first_name", "t29"."c_last_name", "t31"."d_year") AS "t35"
WHERE "sale_type" = 's' AND "year_" = 2001 + 1) AS "t37" ON "t18"."customer_id" = "t37"."customer_id") AS "t38"
INNER JOIN (SELECT "customer_id", "year_total", "year_total" > 0 AS ">"
FROM (SELECT "t41"."c_customer_id" AS "customer_id", "t41"."c_first_name" AS "customer_first_name", "t41"."c_last_name" AS "customer_last_name", "t43"."d_year" AS "year_", SUM("t41"."ss_net_paid") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t39"."c_customer_id", "t39"."c_first_name", "t39"."c_last_name", "t40"."ss_sold_date_sk", "t40"."ss_net_paid"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name"
FROM customer) AS "t39"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_net_paid"
FROM store_sales) AS "t40" ON "t39"."c_customer_sk" = "t40"."ss_customer_sk") AS "t41"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim
WHERE "d_year" = 2001 OR "d_year" = 2001 + 1) AS "t43" ON "t41"."ss_sold_date_sk" = "t43"."d_date_sk"
GROUP BY "t41"."c_customer_id", "t41"."c_first_name", "t41"."c_last_name", "t43"."d_year"
UNION ALL
SELECT "t49"."c_customer_id" AS "customer_id", "t49"."c_first_name" AS "customer_first_name", "t49"."c_last_name" AS "customer_last_name", "t51"."d_year" AS "year_", SUM("t49"."ws_net_paid") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t47"."c_customer_id", "t47"."c_first_name", "t47"."c_last_name", "t48"."ws_sold_date_sk", "t48"."ws_net_paid"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name"
FROM customer) AS "t47"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", "ws_net_paid"
FROM web_sales) AS "t48" ON "t47"."c_customer_sk" = "t48"."ws_bill_customer_sk") AS "t49"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim
WHERE "d_year" = 2001 OR "d_year" = 2001 + 1) AS "t51" ON "t49"."ws_sold_date_sk" = "t51"."d_date_sk"
GROUP BY "t49"."c_customer_id", "t49"."c_first_name", "t49"."c_last_name", "t51"."d_year") AS "t55"
WHERE "sale_type" = 'w' AND "year_" = 2001 AND "year_total" > 0) AS "t58" ON "t38"."customer_id" = "t58"."customer_id") AS "t60"
INNER JOIN "rs_table_74_0" ON "t60"."customer_id" = "rs_table_74_0"."customer_id" AND CASE WHEN "t60".">" THEN CAST("rs_table_74_0"."year_total" / "t60"."year_total1" AS DECIMAL(19, 0)) ELSE NULL END > "t60"."CASE"
ORDER BY "t60"."customer_id0" NULLS FIRST
LIMIT 100
;
