SELECT COUNT(DISTINCT "t19"."ws_order_number") AS "order count", SUM("t19"."ws_ext_ship_cost") AS "total shipping cost", SUM("t19"."ws_net_profit") AS "total net profit"
FROM (SELECT "t15"."ws_web_site_sk", "t15"."ws_order_number", "t15"."ws_ext_ship_cost", "t15"."ws_net_profit"
FROM (SELECT "t11"."ws_ship_addr_sk", "t11"."ws_web_site_sk", "t11"."ws_order_number", "t11"."ws_ext_ship_cost", "t11"."ws_net_profit"
FROM (SELECT "web_sales"."ws_ship_date_sk", "web_sales"."ws_ship_addr_sk", "web_sales"."ws_web_site_sk", "web_sales"."ws_order_number", "web_sales"."ws_ext_ship_cost", "web_sales"."ws_net_profit"
FROM web_sales
INNER JOIN (SELECT "web_sales0"."ws_order_number"
FROM web_sales AS "web_sales0",
web_sales AS "web_sales1"
WHERE "web_sales0"."ws_order_number" = "web_sales1"."ws_order_number" AND "web_sales0"."ws_warehouse_sk" <> "web_sales1"."ws_warehouse_sk"
GROUP BY "web_sales0"."ws_order_number") AS "t2" ON "web_sales"."ws_order_number" = "t2"."ws_order_number"
INNER JOIN (SELECT "web_returns"."wr_order_number"
FROM web_returns,
(SELECT "web_sales2"."ws_order_number", "web_sales2"."ws_warehouse_sk" AS "wh1", "web_sales3"."ws_warehouse_sk" AS "wh2"
FROM web_sales AS "web_sales2",
web_sales AS "web_sales3"
WHERE "web_sales2"."ws_order_number" = "web_sales3"."ws_order_number" AND "web_sales2"."ws_warehouse_sk" <> "web_sales3"."ws_warehouse_sk") AS "t5"
WHERE "web_returns"."wr_order_number" = "t5"."ws_order_number"
GROUP BY "web_returns"."wr_order_number") AS "t9" ON "web_sales"."ws_order_number" = "t9"."wr_order_number") AS "t11"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '1999-02-01' AND "d_date" <= DATE '1999-04-02') AS "t14" ON "t11"."ws_ship_date_sk" = "t14"."d_date_sk") AS "t15"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_state" = 'IL') AS "t18" ON "t15"."ws_ship_addr_sk" = "t18"."ca_address_sk") AS "t19"
INNER JOIN (SELECT "web_site_sk"
FROM web_site
WHERE "web_company_name" = 'pri') AS "t22" ON "t19"."ws_web_site_sk" = "t22"."web_site_sk"
ORDER BY COUNT(DISTINCT "t19"."ws_order_number")
LIMIT 100

