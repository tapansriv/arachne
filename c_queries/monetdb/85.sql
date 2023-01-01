SELECT SUBSTRING("t14"."r_reason_desc" FROM 1 FOR 20), AVG("t13"."ws_quantity") AS "avg1", AVG("t13"."wr_refunded_cash") AS "avg2", AVG("t13"."wr_fee")
FROM (SELECT "t9"."ws_quantity", "t9"."wr_reason_sk", "t9"."wr_fee", "t9"."wr_refunded_cash"
FROM (SELECT "t7"."ws_sold_date_sk", "t7"."ws_quantity", "t7"."wr_reason_sk", "t7"."wr_fee", "t7"."wr_refunded_cash"
FROM (SELECT "t5"."ws_sold_date_sk", "t5"."ws_quantity", "t5"."wr_refunded_addr_sk", "t5"."wr_reason_sk", "t5"."wr_fee", "t5"."wr_refunded_cash", "t5"."AND" AS "SEARCH", "t5"."AND10" AS "SEARCH7", "t5"."AND11" AS "SEARCH8"
FROM (SELECT "t3"."ws_sold_date_sk", "t3"."ws_quantity", "t3"."wr_refunded_addr_sk", "t3"."wr_returning_cdemo_sk", "t3"."wr_reason_sk", "t3"."wr_fee", "t3"."wr_refunded_cash", "t4"."cd_marital_status", "t4"."cd_education_status", "t3"."AND", "t3"."AND9" AS "AND10", "t3"."AND10" AS "AND11", "t4"."=", "t4"."=4" AS "=13", "t3"."AND11" AS "SEARCH", "t4"."=5" AS "=15", "t4"."=6" AS "=16", "t3"."AND12" AS "SEARCH17", "t4"."=7" AS "=18", "t4"."=8" AS "=19", "t3"."AND13" AS "SEARCH20"
FROM (SELECT "t1"."ws_sold_date_sk", "t1"."ws_quantity", "t1"."wr_refunded_cdemo_sk", "t1"."wr_refunded_addr_sk", "t1"."wr_returning_cdemo_sk", "t1"."wr_reason_sk", "t1"."wr_fee", "t1"."wr_refunded_cash", "t1"."AND", "t1"."AND10" AS "AND9", "t1"."AND11" AS "AND10", "t1"."AND12" AS "AND11", "t1"."AND13" AS "AND12", "t1"."AND14" AS "AND13"
FROM (SELECT "t"."ws_sold_date_sk", "t"."ws_web_page_sk", "t"."ws_quantity", "t0"."wr_refunded_cdemo_sk", "t0"."wr_refunded_addr_sk", "t0"."wr_returning_cdemo_sk", "t0"."wr_reason_sk", "t0"."wr_fee", "t0"."wr_refunded_cash", "t"."AND", "t"."AND6" AS "AND10", "t"."AND7" AS "AND11", "t"."AND8" AS "AND12", "t"."AND9" AS "AND13", "t"."AND10" AS "AND14"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_order_number", "ws_quantity", "ws_net_profit" >= 100 AND "ws_net_profit" <= 200 AS "AND", "ws_net_profit" >= 150 AND "ws_net_profit" <= 300 AS "AND6", "ws_net_profit" >= 50 AND "ws_net_profit" <= 250 AS "AND7", "ws_sales_price" >= 100.00 AND "ws_sales_price" <= 150.00 AS "AND8", "ws_sales_price" >= 50.00 AND "ws_sales_price" <= 100.00 AS "AND9", "ws_sales_price" >= 150.00 AND "ws_sales_price" <= 200.00 AS "AND10"
FROM web_sales) AS "t"
INNER JOIN (SELECT "wr_item_sk", "wr_refunded_cdemo_sk", "wr_refunded_addr_sk", "wr_returning_cdemo_sk", "wr_reason_sk", "wr_order_number", "wr_fee", "wr_refunded_cash"
FROM web_returns) AS "t0" ON "t"."ws_item_sk" = "t0"."wr_item_sk" AND "t"."ws_order_number" = "t0"."wr_order_number") AS "t1"
INNER JOIN (SELECT "wp_web_page_sk"
FROM web_page) AS "t2" ON "t1"."ws_web_page_sk" = "t2"."wp_web_page_sk") AS "t3"
INNER JOIN (SELECT "cd_demo_sk", "cd_marital_status", "cd_education_status", "cd_marital_status" = 'M' AS "=", "cd_education_status" = 'Advanced Degree' AS "=4", "cd_marital_status" = 'S' AS "=5", "cd_education_status" = 'College' AS "=6", "cd_marital_status" = 'W' AS "=7", "cd_education_status" = '2 yr Degree' AS "=8"
FROM customer_demographics) AS "t4" ON "t3"."wr_refunded_cdemo_sk" = "t4"."cd_demo_sk") AS "t5"
INNER JOIN (SELECT "cd_demo_sk", "cd_marital_status", "cd_education_status"
FROM customer_demographics) AS "t6" ON "t5"."wr_returning_cdemo_sk" = "t6"."cd_demo_sk" AND ("t5"."=" AND "t5"."cd_marital_status" = "t6"."cd_marital_status" AND "t5"."=13" AND "t5"."cd_education_status" = "t6"."cd_education_status" AND "t5"."SEARCH" OR "t5"."=15" AND "t5"."cd_marital_status" = "t6"."cd_marital_status" AND "t5"."=16" AND "t5"."cd_education_status" = "t6"."cd_education_status" AND "t5"."SEARCH17" OR "t5"."=18" AND "t5"."cd_marital_status" = "t6"."cd_marital_status" AND "t5"."=19" AND "t5"."cd_education_status" = "t6"."cd_education_status" AND "t5"."SEARCH20")) AS "t7"
INNER JOIN (SELECT "ca_address_sk", "ca_country" = 'United States' AS "=", "ca_state" IN ('IN', 'NJ', 'OH') AS "SEARCH", "ca_state" IN ('CT', 'KY', 'WI') AS "SEARCH3", "ca_state" IN ('AR', 'IA', 'LA') AS "SEARCH4"
FROM customer_address) AS "t8" ON "t7"."wr_refunded_addr_sk" = "t8"."ca_address_sk" AND ("t8"."=" AND "t8"."SEARCH" AND "t7"."SEARCH" OR "t8"."=" AND "t8"."SEARCH3" AND "t7"."SEARCH7" OR "t8"."=" AND "t8"."SEARCH4" AND "t7"."SEARCH8")) AS "t9"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2000) AS "t12" ON "t9"."ws_sold_date_sk" = "t12"."d_date_sk") AS "t13"
INNER JOIN (SELECT "r_reason_sk", "r_reason_desc"
FROM reason) AS "t14" ON "t13"."wr_reason_sk" = "t14"."r_reason_sk"
GROUP BY "t14"."r_reason_desc"
ORDER BY SUBSTRING("t14"."r_reason_desc" FROM 1 FOR 20) IS NULL, SUBSTRING("t14"."r_reason_desc" FROM 1 FOR 20), AVG("t13"."ws_quantity") IS NULL, AVG("t13"."ws_quantity"), AVG("t13"."wr_refunded_cash") IS NULL, AVG("t13"."wr_refunded_cash"), AVG("t13"."wr_fee") IS NULL, AVG("t13"."wr_fee")
LIMIT 100
;
