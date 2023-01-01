SELECT COUNT(DISTINCT "t18"."ws_order_number") AS "order count", SUM("t18"."ws_ext_ship_cost") AS "total shipping cost", SUM("t18"."ws_net_profit") AS "total net profit"
FROM (SELECT "t14"."ws_web_site_sk", "t14"."ws_order_number", "t14"."ws_ext_ship_cost", "t14"."ws_net_profit"
FROM (SELECT "t10"."ws_ship_addr_sk", "t10"."ws_web_site_sk", "t10"."ws_order_number", "t10"."ws_ext_ship_cost", "t10"."ws_net_profit"
FROM (SELECT "$cor0"."ws_ship_date_sk", "$cor0"."ws_ship_addr_sk", "$cor0"."ws_web_site_sk", "$cor0"."ws_order_number", "$cor0"."ws_ext_ship_cost", "$cor0"."ws_net_profit"
FROM ('/mnt/disks/tpcds/parquet/web_sales.parquet' AS "$cor0", LATERAL (SELECT TRUE AS "i"
FROM (SELECT "ws_warehouse_sk", "ws_order_number"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t"
WHERE "$cor0"."ws_order_number" = "ws_order_number" AND "$cor0"."ws_warehouse_sk" <> "ws_warehouse_sk"
GROUP BY TRUE) AS "t2") AS "$cor0",
LATERAL (SELECT TRUE AS "i"
FROM (SELECT "wr_order_number"
FROM '/mnt/disks/tpcds/parquet/web_returns.parquet' AS web_returns) AS "t3"
WHERE "$cor0"."ws_order_number" = "wr_order_number"
GROUP BY TRUE) AS "t6"
WHERE "$cor0"."i0" IS NULL) AS "t10"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_date" >= DATE '1999-02-01' AND "d_date" <= DATE '1999-04-02') AS "t13" ON "t10"."ws_ship_date_sk" = "t13"."d_date_sk") AS "t14"
INNER JOIN (SELECT "ca_address_sk"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address
WHERE "ca_state" = 'IL') AS "t17" ON "t14"."ws_ship_addr_sk" = "t17"."ca_address_sk") AS "t18"
INNER JOIN (SELECT "web_site_sk"
FROM '/mnt/disks/tpcds/parquet/web_site.parquet' AS web_site
WHERE "web_company_name" = 'pri') AS "t21" ON "t18"."ws_web_site_sk" = "t21"."web_site_sk"
ORDER BY COUNT(DISTINCT "t18"."ws_order_number")
FETCH NEXT 100 ROWS ONLY

