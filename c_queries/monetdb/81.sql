SELECT "t22"."c_customer_id", "t22"."c_salutation", "t22"."c_first_name", "t22"."c_last_name", "t21"."ca_street_number", "t21"."ca_street_name", "t21"."ca_street_type", "t21"."ca_suite_number", "t21"."ca_city", "t21"."ca_county", "t21"."ca_state", "t21"."ca_zip", "t21"."ca_country", "t21"."ca_gmt_offset", "t21"."ca_location_type", "t19"."ctr_total_return"
FROM (SELECT "$cor0"."ctr_customer_sk", "$cor0"."ctr_total_return"
FROM (SELECT "t3"."cr_returning_customer_sk" AS "ctr_customer_sk", "t4"."ca_state" AS "ctr_state", SUM("t3"."cr_return_amt_inc_tax") AS "ctr_total_return"
FROM (SELECT "t"."cr_returning_customer_sk", "t"."cr_returning_addr_sk", "t"."cr_return_amt_inc_tax"
FROM (SELECT "cr_returned_date_sk", "cr_returning_customer_sk", "cr_returning_addr_sk", "cr_return_amt_inc_tax"
FROM catalog_returns) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2000) AS "t2" ON "t"."cr_returned_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "ca_address_sk", "ca_state"
FROM customer_address) AS "t4" ON "t3"."cr_returning_addr_sk" = "t4"."ca_address_sk"
GROUP BY "t3"."cr_returning_customer_sk", "t4"."ca_state") AS "$cor0",
LATERAL (SELECT CASE COUNT("EXPR$0") WHEN 0 THEN NULL WHEN 1 THEN "EXPR$0" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("ctr_total_return") * 1.2 AS "EXPR$0"
FROM (SELECT "customer_address0"."ca_state" AS "ctr_state", SUM("catalog_returns0"."cr_return_amt_inc_tax") AS "ctr_total_return"
FROM catalog_returns AS "catalog_returns0",
date_dim AS "date_dim0",
customer_address AS "customer_address0"
WHERE "catalog_returns0"."cr_returned_date_sk" = "date_dim0"."d_date_sk" AND "date_dim0"."d_year" = 2000 AND "catalog_returns0"."cr_returning_addr_sk" = "customer_address0"."ca_address_sk"
GROUP BY "catalog_returns0"."cr_returning_customer_sk", "customer_address0"."ca_state") AS "t11"
WHERE "$cor0"."ctr_state" = "t11"."ctr_state") AS "t15") AS "t16"
WHERE "$cor0"."ctr_total_return" > "$cor0"."$f0") AS "t19",
(SELECT "ca_address_sk", "ca_street_number", "ca_street_name", "ca_street_type", "ca_suite_number", "ca_city", "ca_county", "ca_state", "ca_zip", "ca_country", "ca_gmt_offset", "ca_location_type"
FROM customer_address
WHERE "ca_state" = 'GA') AS "t21"
INNER JOIN (SELECT "c_customer_sk", "c_customer_id", "c_current_addr_sk", "c_salutation", "c_first_name", "c_last_name"
FROM customer) AS "t22" ON "t21"."ca_address_sk" = "t22"."c_current_addr_sk" AND "t19"."ctr_customer_sk" = "t22"."c_customer_sk"
ORDER BY "t22"."c_customer_id" IS NULL, "t22"."c_customer_id", "t22"."c_salutation" IS NULL, "t22"."c_salutation", "t22"."c_first_name" IS NULL, "t22"."c_first_name", "t22"."c_last_name" IS NULL, "t22"."c_last_name", "t21"."ca_street_number" IS NULL, "t21"."ca_street_number", "t21"."ca_street_name" IS NULL, "t21"."ca_street_name", "t21"."ca_street_type" IS NULL, "t21"."ca_street_type", "t21"."ca_suite_number" IS NULL, "t21"."ca_suite_number", "t21"."ca_city" IS NULL, "t21"."ca_city", "t21"."ca_county" IS NULL, "t21"."ca_county", "t21"."ca_state" IS NULL, "t21"."ca_state", "t21"."ca_zip" IS NULL, "t21"."ca_zip", "t21"."ca_country" IS NULL, "t21"."ca_country", "t21"."ca_gmt_offset" IS NULL, "t21"."ca_gmt_offset", "t21"."ca_location_type" IS NULL, "t21"."ca_location_type", "t19"."ctr_total_return" IS NULL, "t19"."ctr_total_return"
LIMIT 100
;
