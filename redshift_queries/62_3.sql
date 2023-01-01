CREATE TABLE rs_table_62_0 AS SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11
;
SELECT "t7"."w_substr", "t7"."sm_type", "t7"."web_name", SUM("t7"."CASE") AS "30 days", SUM("t7"."CASE5") AS "31-60 days", SUM("t7"."CASE6") AS "61-90 days", SUM("t7"."CASE7") AS "91-120 days", SUM("t7"."CASE8") AS ">120 days"
FROM (SELECT "t4"."ws_ship_date_sk", "t4"."w_substr", "t4"."sm_type", "t5"."web_name", CASE WHEN "t4"."<=" THEN 1 ELSE 0 END AS "CASE", CASE WHEN "t4"."AND" THEN 1 ELSE 0 END AS "CASE5", CASE WHEN "t4"."AND6" THEN 1 ELSE 0 END AS "CASE6", CASE WHEN "t4"."AND7" THEN 1 ELSE 0 END AS "CASE7", CASE WHEN "t4".">" THEN 1 ELSE 0 END AS "CASE8"
FROM (SELECT "t2"."ws_ship_date_sk", "t2"."ws_web_site_sk", "t2"."w_substr", "t3"."sm_type", "t2"."<=", "t2"."AND", "t2"."AND6", "t2"."AND7", "t2".">"
FROM (SELECT "t"."ws_ship_date_sk", "t"."ws_web_site_sk", "t"."ws_ship_mode_sk", "t1"."w_substr", "t"."<=", "t"."AND", "t"."AND6", "t"."AND7", "t".">"
FROM (SELECT "ws_ship_date_sk", "ws_web_site_sk", "ws_ship_mode_sk", "ws_warehouse_sk", "ws_ship_date_sk" - "ws_sold_date_sk" <= 30 AS "<=", "ws_ship_date_sk" - "ws_sold_date_sk" > 30 AND "ws_ship_date_sk" - "ws_sold_date_sk" <= 60 AS "AND", "ws_ship_date_sk" - "ws_sold_date_sk" > 60 AND "ws_ship_date_sk" - "ws_sold_date_sk" <= 90 AS "AND6", "ws_ship_date_sk" - "ws_sold_date_sk" > 90 AND "ws_ship_date_sk" - "ws_sold_date_sk" <= 120 AS "AND7", "ws_ship_date_sk" - "ws_sold_date_sk" > 120 AS ">"
FROM web_sales) AS "t"
INNER JOIN (SELECT SUBSTRING("w_warehouse_name" FROM 1 FOR 20) AS "w_substr", "w_warehouse_sk"
FROM warehouse) AS "t1" ON "t"."ws_warehouse_sk" = "t1"."w_warehouse_sk") AS "t2"
INNER JOIN (SELECT "sm_ship_mode_sk", "sm_type"
FROM ship_mode) AS "t3" ON "t2"."ws_ship_mode_sk" = "t3"."sm_ship_mode_sk") AS "t4"
INNER JOIN (SELECT "web_site_sk", "web_name"
FROM web_site) AS "t5" ON "t4"."ws_web_site_sk" = "t5"."web_site_sk") AS "t7"
INNER JOIN "rs_table_62_0" ON "t7"."ws_ship_date_sk" = "rs_table_62_0"."d_date_sk"
GROUP BY "t7"."w_substr", "t7"."sm_type", "t7"."web_name"
ORDER BY "t7"."w_substr" NULLS FIRST, "t7"."sm_type" NULLS FIRST, "t7"."web_name" NULLS FIRST
LIMIT 100
;
