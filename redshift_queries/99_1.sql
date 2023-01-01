CREATE TABLE rs_table_99_0 AS SELECT "t7"."w_substr", "t7"."sm_type", "t7"."cc_name", "t7"."CASE" AS "$f3", "t7"."CASE5" AS "$f4", "t7"."CASE6" AS "$f5", "t7"."CASE7" AS "$f6", "t7"."CASE8" AS "$f7"
FROM (SELECT "t4"."cs_ship_date_sk", "t4"."w_substr", "t4"."sm_type", "t5"."cc_name", CASE WHEN "t4"."<=" THEN 1 ELSE 0 END AS "CASE", CASE WHEN "t4"."AND" THEN 1 ELSE 0 END AS "CASE5", CASE WHEN "t4"."AND6" THEN 1 ELSE 0 END AS "CASE6", CASE WHEN "t4"."AND7" THEN 1 ELSE 0 END AS "CASE7", CASE WHEN "t4".">" THEN 1 ELSE 0 END AS "CASE8"
FROM (SELECT "t2"."cs_ship_date_sk", "t2"."cs_call_center_sk", "t2"."w_substr", "t3"."sm_type", "t2"."<=", "t2"."AND", "t2"."AND6", "t2"."AND7", "t2".">"
FROM (SELECT "t"."cs_ship_date_sk", "t"."cs_call_center_sk", "t"."cs_ship_mode_sk", "t1"."w_substr", "t"."<=", "t"."AND", "t"."AND6", "t"."AND7", "t".">"
FROM (SELECT "cs_ship_date_sk", "cs_call_center_sk", "cs_ship_mode_sk", "cs_warehouse_sk", "cs_ship_date_sk" - "cs_sold_date_sk" <= 30 AS "<=", "cs_ship_date_sk" - "cs_sold_date_sk" > 30 AND "cs_ship_date_sk" - "cs_sold_date_sk" <= 60 AS "AND", "cs_ship_date_sk" - "cs_sold_date_sk" > 60 AND "cs_ship_date_sk" - "cs_sold_date_sk" <= 90 AS "AND6", "cs_ship_date_sk" - "cs_sold_date_sk" > 90 AND "cs_ship_date_sk" - "cs_sold_date_sk" <= 120 AS "AND7", "cs_ship_date_sk" - "cs_sold_date_sk" > 120 AS ">"
FROM catalog_sales) AS "t"
INNER JOIN (SELECT SUBSTRING("w_warehouse_name" FROM 1 FOR 20) AS "w_substr", "w_warehouse_sk"
FROM warehouse) AS "t1" ON "t"."cs_warehouse_sk" = "t1"."w_warehouse_sk") AS "t2"
INNER JOIN (SELECT "sm_ship_mode_sk", "sm_type"
FROM ship_mode) AS "t3" ON "t2"."cs_ship_mode_sk" = "t3"."sm_ship_mode_sk") AS "t4"
INNER JOIN (SELECT "cc_call_center_sk", "cc_name"
FROM call_center) AS "t5" ON "t4"."cs_call_center_sk" = "t5"."cc_call_center_sk") AS "t7"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t10" ON "t7"."cs_ship_date_sk" = "t10"."d_date_sk"
;
SELECT "w_substr", "sm_type", LOWER("cc_name") AS "cc_name_lower", SUM("$f3") AS "30 days", SUM("$f4") AS "31-60 days", SUM("$f5") AS "61-90 days", SUM("$f6") AS "91-120 days", SUM("$f7") AS ">120 days"
FROM "rs_table_99_0"
GROUP BY "w_substr", "sm_type", "cc_name"
ORDER BY "w_substr" NULLS FIRST, "sm_type" NULLS FIRST, LOWER("cc_name") NULLS FIRST
LIMIT 100
;
