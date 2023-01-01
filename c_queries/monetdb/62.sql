SELECT "t6"."w_substr", "t6"."sm_type", "t6"."web_name", SUM("t6"."CASE") AS "days_30", SUM("t6"."CASE5") AS "days_31_60", SUM("t6"."CASE6") AS "days_61_90", SUM("t6"."CASE7") AS "days_90_120", SUM("t6"."CASE8") AS "days_over_120"
FROM (SELECT "t4"."ws_ship_date_sk", "t4"."w_substr", "t4"."sm_type", "t5"."web_name", "t4"."CASE", "t4"."CASE5", "t4"."CASE6", "t4"."CASE7", "t4"."CASE8"
FROM (SELECT "t2"."ws_ship_date_sk", "t2"."ws_web_site_sk", "t2"."w_substr", "t3"."sm_type", "t2"."CASE", "t2"."CASE5", "t2"."CASE6", "t2"."CASE7", "t2"."CASE8"
FROM (SELECT "t"."ws_ship_date_sk", "t"."ws_web_site_sk", "t"."ws_ship_mode_sk", "t1"."w_substr", "t"."CASE", "t"."CASE5", "t"."CASE6", "t"."CASE7", "t"."CASE8"
FROM (SELECT "ws_ship_date_sk", "ws_web_site_sk", "ws_ship_mode_sk", "ws_warehouse_sk", CASE WHEN "ws_ship_date_sk" - "ws_sold_date_sk" <= 30 THEN 1 ELSE 0 END AS "CASE", CASE WHEN "ws_ship_date_sk" - "ws_sold_date_sk" > 30 AND "ws_ship_date_sk" - "ws_sold_date_sk" <= 60 THEN 1 ELSE 0 END AS "CASE5", CASE WHEN "ws_ship_date_sk" - "ws_sold_date_sk" > 60 AND "ws_ship_date_sk" - "ws_sold_date_sk" <= 90 THEN 1 ELSE 0 END AS "CASE6", CASE WHEN "ws_ship_date_sk" - "ws_sold_date_sk" > 90 AND "ws_ship_date_sk" - "ws_sold_date_sk" <= 120 THEN 1 ELSE 0 END AS "CASE7", CASE WHEN "ws_ship_date_sk" - "ws_sold_date_sk" > 120 THEN 1 ELSE 0 END AS "CASE8"
FROM web_sales) AS "t"
INNER JOIN (SELECT SUBSTRING("w_warehouse_name" FROM 1 FOR 20) AS "w_substr", "w_warehouse_sk"
FROM warehouse) AS "t1" ON "t"."ws_warehouse_sk" = "t1"."w_warehouse_sk") AS "t2"
INNER JOIN (SELECT "sm_ship_mode_sk", "sm_type"
FROM ship_mode) AS "t3" ON "t2"."ws_ship_mode_sk" = "t3"."sm_ship_mode_sk") AS "t4"
INNER JOIN (SELECT "web_site_sk", "web_name"
FROM web_site) AS "t5" ON "t4"."ws_web_site_sk" = "t5"."web_site_sk") AS "t6"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t9" ON "t6"."ws_ship_date_sk" = "t9"."d_date_sk"
GROUP BY "t6"."w_substr", "t6"."sm_type", "t6"."web_name"
ORDER BY "t6"."w_substr", "t6"."sm_type", "t6"."web_name"
LIMIT 100
;
