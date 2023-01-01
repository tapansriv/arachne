CREATE TABLE rs_table_74_0 AS SELECT "t1"."c_customer_id" AS "customer_id", "t1"."c_first_name" AS "customer_first_name", "t1"."c_last_name" AS "customer_last_name", "t3"."d_year" AS "year_", SUM("t1"."ss_net_paid") AS "year_total", 's' AS "sale_type"
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
GROUP BY "t9"."c_customer_id", "t9"."c_first_name", "t9"."c_last_name", "t11"."d_year"
;
CREATE TABLE rs_table_74_1 AS SELECT "t1"."customer_id", "t3"."customer_id" AS "customer_id0", "t3"."customer_first_name" AS "customer_first_name0", "t3"."customer_last_name" AS "customer_last_name0", CASE WHEN "t1".">" THEN "t3"."year_total" / "t1"."year_total" ELSE NULL END AS "CASE"
FROM (SELECT "customer_id", "year_total", "year_total" > 0 AS ">"
FROM "rs_table_74_0"
WHERE "sale_type" = 's' AND "year_" = 2001 AND "year_total" > 0) AS "t1"
INNER JOIN (SELECT "customer_id", "customer_first_name", "customer_last_name", "year_total"
FROM "rs_table_74_0"
WHERE "sale_type" = 's' AND "year_" = 2001 + 1) AS "t3" ON "t1"."customer_id" = "t3"."customer_id"
;
SELECT "t20"."customer_id0" AS "customer_id", "t20"."customer_first_name0" AS "customer_first_name", "t20"."customer_last_name0" AS "customer_last_name"
FROM (SELECT "rs_table_74_1"."customer_id", "rs_table_74_1"."customer_id0", "rs_table_74_1"."customer_first_name0", "rs_table_74_1"."customer_last_name0", "t18"."year_total" AS "year_total1", "t18".">", "rs_table_74_1"."CASE"
FROM "rs_table_74_1"
INNER JOIN (SELECT "customer_id", "year_total", "year_total" > 0 AS ">"
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
WHERE "sale_type" = 'w' AND "year_" = 2001 AND "year_total" > 0) AS "t18" ON "rs_table_74_1"."customer_id" = "t18"."customer_id") AS "t20"
INNER JOIN (SELECT "customer_id", "year_total"
FROM (SELECT "t23"."c_customer_id" AS "customer_id", "t23"."c_first_name" AS "customer_first_name", "t23"."c_last_name" AS "customer_last_name", "t25"."d_year" AS "year_", SUM("t23"."ss_net_paid") AS "year_total", 's' AS "sale_type"
FROM (SELECT "t21"."c_customer_id", "t21"."c_first_name", "t21"."c_last_name", "t22"."ss_sold_date_sk", "t22"."ss_net_paid"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name"
FROM customer) AS "t21"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_net_paid"
FROM store_sales) AS "t22" ON "t21"."c_customer_sk" = "t22"."ss_customer_sk") AS "t23"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim
WHERE "d_year" = 2001 OR "d_year" = 2001 + 1) AS "t25" ON "t23"."ss_sold_date_sk" = "t25"."d_date_sk"
GROUP BY "t23"."c_customer_id", "t23"."c_first_name", "t23"."c_last_name", "t25"."d_year"
UNION ALL
SELECT "t31"."c_customer_id" AS "customer_id", "t31"."c_first_name" AS "customer_first_name", "t31"."c_last_name" AS "customer_last_name", "t33"."d_year" AS "year_", SUM("t31"."ws_net_paid") AS "year_total", 'w' AS "sale_type"
FROM (SELECT "t29"."c_customer_id", "t29"."c_first_name", "t29"."c_last_name", "t30"."ws_sold_date_sk", "t30"."ws_net_paid"
FROM (SELECT "c_customer_sk", "c_customer_id", "c_first_name", "c_last_name"
FROM customer) AS "t29"
INNER JOIN (SELECT "ws_sold_date_sk", "ws_bill_customer_sk", "ws_net_paid"
FROM web_sales) AS "t30" ON "t29"."c_customer_sk" = "t30"."ws_bill_customer_sk") AS "t31"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim
WHERE "d_year" = 2001 OR "d_year" = 2001 + 1) AS "t33" ON "t31"."ws_sold_date_sk" = "t33"."d_date_sk"
GROUP BY "t31"."c_customer_id", "t31"."c_first_name", "t31"."c_last_name", "t33"."d_year") AS "t37"
WHERE "sale_type" = 'w' AND "year_" = 2001 + 1) AS "t40" ON "t20"."customer_id" = "t40"."customer_id" AND CASE WHEN "t20".">" THEN CAST("t40"."year_total" / "t20"."year_total1" AS DECIMAL(19, 0)) ELSE NULL END > "t20"."CASE"
ORDER BY "t20"."customer_id0" NULLS FIRST
LIMIT 100
;