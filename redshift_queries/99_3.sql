CREATE TABLE rs_table_99_0 AS SELECT "t2"."cs_ship_date_sk", "t2"."cs_call_center_sk", "t2"."w_substr", "t3"."sm_type", "t2"."<=", "t2"."AND", "t2"."AND6", "t2"."AND7", "t2".">"
FROM (SELECT "t"."cs_ship_date_sk", "t"."cs_call_center_sk", "t"."cs_ship_mode_sk", "t1"."w_substr", "t"."<=", "t"."AND", "t"."AND6", "t"."AND7", "t".">"
FROM (SELECT "cs_ship_date_sk", "cs_call_center_sk", "cs_ship_mode_sk", "cs_warehouse_sk", "cs_ship_date_sk" - "cs_sold_date_sk" <= 30 AS "<=", "cs_ship_date_sk" - "cs_sold_date_sk" > 30 AND "cs_ship_date_sk" - "cs_sold_date_sk" <= 60 AS "AND", "cs_ship_date_sk" - "cs_sold_date_sk" > 60 AND "cs_ship_date_sk" - "cs_sold_date_sk" <= 90 AS "AND6", "cs_ship_date_sk" - "cs_sold_date_sk" > 90 AND "cs_ship_date_sk" - "cs_sold_date_sk" <= 120 AS "AND7", "cs_ship_date_sk" - "cs_sold_date_sk" > 120 AS ">"
FROM catalog_sales) AS "t"
INNER JOIN (SELECT SUBSTRING("w_warehouse_name" FROM 1 FOR 20) AS "w_substr", "w_warehouse_sk"
FROM warehouse) AS "t1" ON "t"."cs_warehouse_sk" = "t1"."w_warehouse_sk") AS "t2"
INNER JOIN (SELECT "sm_ship_mode_sk", "sm_type"
FROM ship_mode) AS "t3" ON "t2"."cs_ship_mode_sk" = "t3"."sm_ship_mode_sk"
;
SELECT "t1"."w_substr", "t1"."sm_type", LOWER("t1"."cc_name") AS "cc_name_lower", SUM("t1"."CASE") AS "30 days", SUM("t1"."CASE5") AS "31-60 days", SUM("t1"."CASE6") AS "61-90 days", SUM("t1"."CASE7") AS "91-120 days", SUM("t1"."CASE8") AS ">120 days"
FROM (SELECT "rs_table_99_0"."cs_ship_date_sk", "rs_table_99_0"."w_substr", "rs_table_99_0"."sm_type", "t"."cc_name", CASE WHEN "rs_table_99_0"."<=" THEN 1 ELSE 0 END AS "CASE", CASE WHEN "rs_table_99_0"."AND" THEN 1 ELSE 0 END AS "CASE5", CASE WHEN "rs_table_99_0"."AND6" THEN 1 ELSE 0 END AS "CASE6", CASE WHEN "rs_table_99_0"."AND7" THEN 1 ELSE 0 END AS "CASE7", CASE WHEN "rs_table_99_0".">" THEN 1 ELSE 0 END AS "CASE8"
FROM "rs_table_99_0"
INNER JOIN (SELECT "cc_call_center_sk", "cc_name"
FROM call_center) AS "t" ON "rs_table_99_0"."cs_call_center_sk" = "t"."cc_call_center_sk") AS "t1"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t4" ON "t1"."cs_ship_date_sk" = "t4"."d_date_sk"
GROUP BY "t1"."w_substr", "t1"."sm_type", "t1"."cc_name"
ORDER BY "t1"."w_substr" NULLS FIRST, "t1"."sm_type" NULLS FIRST, LOWER("t1"."cc_name") NULLS FIRST
LIMIT 100
;
