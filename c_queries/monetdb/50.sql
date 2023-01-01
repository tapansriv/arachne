SELECT "t5"."s_store_name", "t5"."s_company_id", "t5"."s_street_number", "t5"."s_street_name", "t5"."s_street_type", "t5"."s_suite_number", "t5"."s_city", "t5"."s_county", "t5"."s_state", "t5"."s_zip", SUM("t5"."CASE") AS "days_30", SUM("t5"."CASE12") AS "days_31_60", SUM("t5"."CASE13") AS "days_61_90", SUM("t5"."CASE14") AS "days_90_120", SUM("t5"."CASE15") AS "days_over_120"
FROM (SELECT "t3"."sr_returned_date_sk", "t3"."s_store_name", "t3"."s_company_id", "t3"."s_street_number", "t3"."s_street_name", "t3"."s_street_type", "t3"."s_suite_number", "t3"."s_city", "t3"."s_county", "t3"."s_state", "t3"."s_zip", "t3"."CASE", "t3"."CASE13" AS "CASE12", "t3"."CASE14" AS "CASE13", "t3"."CASE15" AS "CASE14", "t3"."CASE16" AS "CASE15"
FROM (SELECT "t1"."ss_sold_date_sk", "t1"."sr_returned_date_sk", "t2"."s_store_name", "t2"."s_company_id", "t2"."s_street_number", "t2"."s_street_name", "t2"."s_street_type", "t2"."s_suite_number", "t2"."s_city", "t2"."s_county", "t2"."s_state", "t2"."s_zip", "t1"."CASE", "t1"."CASE4" AS "CASE13", "t1"."CASE5" AS "CASE14", "t1"."CASE6" AS "CASE15", "t1"."CASE7" AS "CASE16"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_store_sk", "t0"."sr_returned_date_sk", CASE WHEN "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" <= 30 THEN 1 ELSE 0 END AS "CASE", CASE WHEN "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" > 30 AND "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" <= 60 THEN 1 ELSE 0 END AS "CASE4", CASE WHEN "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" > 60 AND "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" <= 90 THEN 1 ELSE 0 END AS "CASE5", CASE WHEN "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" > 90 AND "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" <= 120 THEN 1 ELSE 0 END AS "CASE6", CASE WHEN "t0"."sr_returned_date_sk" - "t"."ss_sold_date_sk" > 120 THEN 1 ELSE 0 END AS "CASE7"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_customer_sk", "ss_store_sk", "ss_ticket_number"
FROM store_sales) AS "t"
INNER JOIN (SELECT "sr_returned_date_sk", "sr_item_sk", "sr_customer_sk", "sr_ticket_number"
FROM store_returns) AS "t0" ON "t"."ss_ticket_number" = "t0"."sr_ticket_number" AND "t"."ss_item_sk" = "t0"."sr_item_sk" AND "t"."ss_customer_sk" = "t0"."sr_customer_sk") AS "t1"
INNER JOIN (SELECT "s_store_sk", "s_store_name", "s_company_id", "s_street_number", "s_street_name", "s_street_type", "s_suite_number", "s_city", "s_county", "s_state", "s_zip"
FROM store) AS "t2" ON "t1"."ss_store_sk" = "t2"."s_store_sk") AS "t3"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim) AS "t4" ON "t3"."ss_sold_date_sk" = "t4"."d_date_sk") AS "t5"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2001 AND "d_moy" = 8) AS "t8" ON "t5"."sr_returned_date_sk" = "t8"."d_date_sk"
GROUP BY "t5"."s_store_name", "t5"."s_company_id", "t5"."s_street_number", "t5"."s_street_name", "t5"."s_street_type", "t5"."s_suite_number", "t5"."s_city", "t5"."s_county", "t5"."s_state", "t5"."s_zip"
ORDER BY "t5"."s_store_name" IS NULL, "t5"."s_store_name", "t5"."s_company_id" IS NULL, "t5"."s_company_id", "t5"."s_street_number" IS NULL, "t5"."s_street_number", "t5"."s_street_name" IS NULL, "t5"."s_street_name", "t5"."s_street_type" IS NULL, "t5"."s_street_type", "t5"."s_suite_number" IS NULL, "t5"."s_suite_number", "t5"."s_city" IS NULL, "t5"."s_city", "t5"."s_county" IS NULL, "t5"."s_county", "t5"."s_state" IS NULL, "t5"."s_state", "t5"."s_zip" IS NULL, "t5"."s_zip"
LIMIT 100
;
