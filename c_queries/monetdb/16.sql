SELECT COUNT(DISTINCT "t18"."cs_order_number") AS "order count", SUM("t18"."cs_ext_ship_cost") AS "total shipping cost", SUM("t18"."cs_net_profit") AS "total net profit"
FROM (SELECT "t14"."cs_call_center_sk", "t14"."cs_order_number", "t14"."cs_ext_ship_cost", "t14"."cs_net_profit"
FROM (SELECT "t10"."cs_ship_addr_sk", "t10"."cs_call_center_sk", "t10"."cs_order_number", "t10"."cs_ext_ship_cost", "t10"."cs_net_profit"
FROM (SELECT "$cor0"."cs_ship_date_sk", "$cor0"."cs_ship_addr_sk", "$cor0"."cs_call_center_sk", "$cor0"."cs_order_number", "$cor0"."cs_ext_ship_cost", "$cor0"."cs_net_profit"
FROM (catalog_sales AS "$cor0", LATERAL (SELECT TRUE AS "i"
FROM (SELECT "cs_warehouse_sk", "cs_order_number"
FROM catalog_sales) AS "t"
WHERE "$cor0"."cs_order_number" = "cs_order_number" AND "$cor0"."cs_warehouse_sk" <> "cs_warehouse_sk"
GROUP BY TRUE) AS "t2") AS "$cor0",
LATERAL (SELECT TRUE AS "i"
FROM (SELECT "cr_order_number"
FROM catalog_returns) AS "t3"
WHERE "$cor0"."cs_order_number" = "cr_order_number"
GROUP BY TRUE) AS "t6"
WHERE "$cor0"."i0" IS NULL) AS "t10"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2002-02-01' AND "d_date" <= DATE '2002-04-02') AS "t13" ON "t10"."cs_ship_date_sk" = "t13"."d_date_sk") AS "t14"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_state" = 'GA') AS "t17" ON "t14"."cs_ship_addr_sk" = "t17"."ca_address_sk") AS "t18"
INNER JOIN (SELECT "cc_call_center_sk"
FROM call_center
WHERE "cc_county" = 'Williamson County') AS "t21" ON "t18"."cs_call_center_sk" = "t21"."cc_call_center_sk"
ORDER BY COUNT(DISTINCT "t18"."cs_order_number") IS NULL, COUNT(DISTINCT "t18"."cs_order_number")
LIMIT 100
;
