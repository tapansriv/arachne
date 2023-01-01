SELECT SUBSTRING("t16"."r_reason_desc" FROM 1 FOR 20), AVG("t15"."ws_quantity") AS "avg1", AVG("t15"."wr_refunded_cash") AS "avg2", AVG("t15"."wr_fee")
FROM (SELECT "t11"."ws_quantity", "t11"."wr_reason_sk", "t11"."wr_fee", "t11"."wr_refunded_cash"
FROM (SELECT "t9"."ws_sold_date_sk", "t9"."ws_quantity", "t9"."wr_reason_sk", "t9"."wr_fee", "t9"."wr_refunded_cash"
FROM (SELECT "t6"."ws_sold_date_sk", "t6"."ws_quantity", "t6"."wr_refunded_addr_sk", "t6"."wr_reason_sk", "t6"."wr_fee", "t6"."wr_refunded_cash", "t6"."AND" AS "SEARCH", "t6"."AND11" AS "SEARCH7", "t6"."AND12" AS "SEARCH8"
FROM (SELECT "t3"."ws_sold_date_sk", "t3"."ws_quantity", "t3"."ws_net_profit", "t3"."wr_refunded_addr_sk", "t3"."wr_returning_cdemo_sk", "t3"."wr_reason_sk", "t3"."wr_fee", "t3"."wr_refunded_cash", "t4"."cd_marital_status", "t4"."cd_education_status", "t3"."AND", "t3"."AND11", "t3"."AND12", "t4"."=", "t4"."=4" AS "=14", "t3"."AND13" AS "SEARCH", "t4"."=5" AS "=16", "t4"."=6" AS "=17", "t3"."AND14" AS "SEARCH18", "t4"."=7" AS "=19", "t4"."=8" AS "=20", "t3"."AND15" AS "SEARCH21"
FROM (SELECT "t1"."ws_sold_date_sk", "t1"."ws_quantity", "t1"."ws_sales_price", "t1"."ws_net_profit", "t1"."wr_refunded_cdemo_sk", "t1"."wr_refunded_addr_sk", "t1"."wr_returning_cdemo_sk", "t1"."wr_reason_sk", "t1"."wr_fee", "t1"."wr_refunded_cash", "t1"."AND", "t1"."AND12" AS "AND11", "t1"."AND13" AS "AND12", "t1"."AND14" AS "AND13", "t1"."AND15" AS "AND14", "t1"."AND16" AS "AND15"
FROM (SELECT "t"."ws_sold_date_sk", "t"."ws_web_page_sk", "t"."ws_quantity", "t"."ws_sales_price", "t"."ws_net_profit", "t0"."wr_refunded_cdemo_sk", "t0"."wr_refunded_addr_sk", "t0"."wr_returning_cdemo_sk", "t0"."wr_reason_sk", "t0"."wr_fee", "t0"."wr_refunded_cash", "t"."AND", "t"."AND8" AS "AND12", "t"."AND9" AS "AND13", "t"."AND10" AS "AND14", "t"."AND11" AS "AND15", "t"."AND12" AS "AND16"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_web_page_sk", "ws_order_number", "ws_quantity", "ws_sales_price", "ws_net_profit", "ws_net_profit" >= 100 AND "ws_net_profit" <= 200 AS "AND", "ws_net_profit" >= 150 AND "ws_net_profit" <= 300 AS "AND8", "ws_net_profit" >= 50 AND "ws_net_profit" <= 250 AS "AND9", "ws_sales_price" >= 100.00 AND "ws_sales_price" <= 150.00 AS "AND10", "ws_sales_price" >= 50.00 AND "ws_sales_price" <= 100.00 AS "AND11", "ws_sales_price" >= 150.00 AND "ws_sales_price" <= 200.00 AS "AND12"
FROM web_sales) AS "t"
INNER JOIN (SELECT "wr_item_sk", "wr_refunded_cdemo_sk", "wr_refunded_addr_sk", "wr_returning_cdemo_sk", "wr_reason_sk", "wr_order_number", "wr_fee", "wr_refunded_cash"
FROM web_returns) AS "t0" ON "t"."ws_item_sk" = "t0"."wr_item_sk" AND "t"."ws_order_number" = "t0"."wr_order_number") AS "t1"
INNER JOIN (SELECT "wp_web_page_sk"
FROM web_page) AS "t2" ON "t1"."ws_web_page_sk" = "t2"."wp_web_page_sk") AS "t3"
INNER JOIN (SELECT "cd_demo_sk", "cd_marital_status", "cd_education_status", "cd_marital_status" = 'M' AS "=", "cd_education_status" = 'Advanced Degree' AS "=4", "cd_marital_status" = 'S' AS "=5", "cd_education_status" = 'College' AS "=6", "cd_marital_status" = 'W' AS "=7", "cd_education_status" = '2 yr Degree' AS "=8"
FROM customer_demographics) AS "t4" ON "t3"."wr_refunded_cdemo_sk" = "t4"."cd_demo_sk") AS "t6"
INNER JOIN (SELECT "cd_demo_sk", "cd_marital_status", "cd_education_status"
FROM customer_demographics) AS "t7" ON "t6"."wr_returning_cdemo_sk" = "t7"."cd_demo_sk" AND ("t6"."=" AND "t6"."cd_marital_status" = "t7"."cd_marital_status" AND "t6"."=14" AND "t6"."cd_education_status" = "t7"."cd_education_status" AND "t6"."SEARCH" OR "t6"."=16" AND "t6"."cd_marital_status" = "t7"."cd_marital_status" AND "t6"."=17" AND "t6"."cd_education_status" = "t7"."cd_education_status" AND "t6"."SEARCH18" OR "t6"."=19" AND "t6"."cd_marital_status" = "t7"."cd_marital_status" AND "t6"."=20" AND "t6"."cd_education_status" = "t7"."cd_education_status" AND "t6"."SEARCH21")) AS "t9"
INNER JOIN (SELECT "ca_address_sk", "ca_country" = 'United States' AS "=", "ca_state" IN ('IN', 'NJ', 'OH') AS "SEARCH", "ca_state" IN ('CT', 'KY', 'WI') AS "SEARCH3", "ca_state" IN ('AR', 'IA', 'LA') AS "SEARCH4"
FROM customer_address) AS "t10" ON "t9"."wr_refunded_addr_sk" = "t10"."ca_address_sk" AND ("t10"."=" AND "t10"."SEARCH" AND "t9"."SEARCH" OR "t10"."=" AND "t10"."SEARCH3" AND "t9"."SEARCH7" OR "t10"."=" AND "t10"."SEARCH4" AND "t9"."SEARCH8")) AS "t11"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2000) AS "t14" ON "t11"."ws_sold_date_sk" = "t14"."d_date_sk") AS "t15"
INNER JOIN (SELECT "r_reason_sk", "r_reason_desc"
FROM reason) AS "t16" ON "t15"."wr_reason_sk" = "t16"."r_reason_sk"
GROUP BY "t16"."r_reason_desc"
ORDER BY SUBSTRING("t16"."r_reason_desc" FROM 1 FOR 20), AVG("t15"."ws_quantity"), AVG("t15"."wr_refunded_cash"), AVG("t15"."wr_fee")
LIMIT 100

