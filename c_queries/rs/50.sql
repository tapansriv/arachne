SELECT "t6"."s_store_name", "t6"."s_company_id", "t6"."s_street_number", "t6"."s_street_name", "t6"."s_street_type", "t6"."s_suite_number", "t6"."s_city", "t6"."s_county", "t6"."s_state", "t6"."s_zip", SUM("t6"."CASE") AS "days_30", SUM("t6"."CASE12") AS "days_31_60", SUM("t6"."CASE13") AS "days_61_90", SUM("t6"."CASE14") AS "days_90_120", SUM("t6"."CASE15") AS "days_over_120"
FROM (SELECT "t3"."sr_returned_date_sk", "t3"."s_store_name", "t3"."s_company_id", "t3"."s_street_number", "t3"."s_street_name", "t3"."s_street_type", "t3"."s_suite_number", "t3"."s_city", "t3"."s_county", "t3"."s_state", "t3"."s_zip", CASE WHEN "t3"."<=" THEN 1 ELSE 0 END AS "CASE", CASE WHEN "t3"."AND" THEN 1 ELSE 0 END AS "CASE12", CASE WHEN "t3"."AND14" THEN 1 ELSE 0 END AS "CASE13", CASE WHEN "t3"."AND15" THEN 1 ELSE 0 END AS "CASE14", CASE WHEN "t3".">" THEN 1 ELSE 0 END AS "CASE15"
FROM (SELECT "t1"."ss_sold_date_sk", "t1"."sr_returned_date_sk", "t2"."s_store_name", "t2"."s_company_id", "t2"."s_street_number", "t2"."s_street_name", "t2"."s_street_type", "t2"."s_suite_number", "t2"."s_city", "t2"."s_county", "t2"."s_state", "t2"."s_zip", "t1"."<=", "t1"."AND", "t1"."AND5" AS "AND14", "t1"."AND6" AS "AND15", "t1".">"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_store_sk", "t0"."sr_returned_date_sk", "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" <= 30 AS "<=", "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" > 30 AND "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" <= 60 AS "AND", "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" > 60 AND "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" <= 90 AS "AND5", "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" > 90 AND "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" <= 120 AS "AND6", "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" > 120 AS ">"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_customer_sk", "ss_store_sk", "ss_ticket_number"
FROM store_sales) AS "t"
INNER JOIN (SELECT "sr_returned_date_sk", "sr_item_sk", "sr_customer_sk", "sr_ticket_number"
FROM store_returns) AS "t0" ON "t"."ss_ticket_number" = "t0"."sr_ticket_number" AND "t"."ss_item_sk" = "t0"."sr_item_sk" AND "t"."ss_customer_sk" = "t0"."sr_customer_sk") AS "t1"
INNER JOIN (SELECT "s_store_sk", "s_store_name", "s_company_id", "s_street_number", "s_street_name", "s_street_type", "s_suite_number", "s_city", "s_county", "s_state", "s_zip"
FROM store) AS "t2" ON "t1"."ss_store_sk" = "t2"."s_store_sk") AS "t3"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim) AS "t4" ON "t3"."ss_sold_date_sk" = "t4"."d_date_sk") AS "t6"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2001 AND "d_moy" = 8) AS "t9" ON "t6"."sr_returned_date_sk" = "t9"."d_date_sk"
GROUP BY "t6"."s_store_name", "t6"."s_company_id", "t6"."s_street_number", "t6"."s_street_name", "t6"."s_street_type", "t6"."s_suite_number", "t6"."s_city", "t6"."s_county", "t6"."s_state", "t6"."s_zip"
ORDER BY "t6"."s_store_name", "t6"."s_company_id", "t6"."s_street_number", "t6"."s_street_name", "t6"."s_street_type", "t6"."s_suite_number", "t6"."s_city", "t6"."s_county", "t6"."s_state", "t6"."s_zip"
LIMIT 100

