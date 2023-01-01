SELECT "t23"."c_customer_id", "t23"."c_salutation", "t23"."c_first_name", "t23"."c_last_name", "t23"."c_preferred_cust_flag", "t23"."c_birth_day", "t23"."c_birth_month", "t23"."c_birth_year", "t23"."c_birth_country", "t23"."c_login", "t23"."c_email_address", "t23"."c_last_review_date_sk", "t19"."ctr_total_return"
FROM (SELECT "$cor0"."ctr_customer_sk", "$cor0"."ctr_total_return"
FROM (SELECT "t3"."wr_returning_customer_sk" AS "ctr_customer_sk", "t4"."ca_state" AS "ctr_state", SUM("t3"."wr_return_amt") AS "ctr_total_return"
FROM (SELECT "t"."wr_returning_customer_sk", "t"."wr_returning_addr_sk", "t"."wr_return_amt"
FROM (SELECT "wr_returned_date_sk", "wr_returning_customer_sk", "wr_returning_addr_sk", "wr_return_amt"
FROM '/mnt/disks/tpcds/parquet/web_returns.parquet' AS web_returns) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 2002) AS "t2" ON "t"."wr_returned_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "ca_address_sk", "ca_state"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address) AS "t4" ON "t3"."wr_returning_addr_sk" = "t4"."ca_address_sk"
GROUP BY "t3"."wr_returning_customer_sk", "t4"."ca_state") AS "$cor0",
LATERAL (SELECT SINGLE_VALUE("EXPR$0") AS "$f0"
FROM (SELECT AVG("ctr_total_return") * 1.2 AS "EXPR$0"
FROM (SELECT "customer_address0"."ca_state" AS "ctr_state", SUM("web_returns0"."wr_return_amt") AS "ctr_total_return"
FROM '/mnt/disks/tpcds/parquet/web_returns.parquet' AS "web_returns0",
'/mnt/disks/tpcds/parquet/date_dim.parquet' AS "date_dim0",
'/mnt/disks/tpcds/parquet/customer_address.parquet' AS "customer_address0"
WHERE "web_returns0"."wr_returned_date_sk" = "date_dim0"."d_date_sk" AND "date_dim0"."d_year" = 2002 AND "web_returns0"."wr_returning_addr_sk" = "customer_address0"."ca_address_sk"
GROUP BY "web_returns0"."wr_returning_customer_sk", "customer_address0"."ca_state") AS "t11"
WHERE "$cor0"."ctr_state" = "t11"."ctr_state") AS "t15") AS "t16"
WHERE "$cor0"."ctr_total_return" > "$cor0"."$f0") AS "t19",
(SELECT "ca_address_sk"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address
WHERE "ca_state" = 'GA') AS "t22"
INNER JOIN (SELECT "c_customer_sk", "c_customer_id", "c_current_addr_sk", "c_salutation", "c_first_name", "c_last_name", "c_preferred_cust_flag", "c_birth_day", "c_birth_month", "c_birth_year", "c_birth_country", "c_login", "c_email_address", "c_last_review_date_sk"
FROM '/mnt/disks/tpcds/parquet/customer.parquet' AS customer) AS "t23" ON "t22"."ca_address_sk" = "t23"."c_current_addr_sk" AND "t19"."ctr_customer_sk" = "t23"."c_customer_sk"
ORDER BY "t23"."c_customer_id" NULLS FIRST, "t23"."c_salutation" NULLS FIRST, "t23"."c_first_name" NULLS FIRST, "t23"."c_last_name" NULLS FIRST, "t23"."c_preferred_cust_flag" NULLS FIRST, "t23"."c_birth_day" NULLS FIRST, "t23"."c_birth_month" NULLS FIRST, "t23"."c_birth_year" NULLS FIRST, "t23"."c_birth_country" NULLS FIRST, "t23"."c_login" NULLS FIRST, "t23"."c_email_address" NULLS FIRST, "t23"."c_last_review_date_sk" NULLS FIRST, "t19"."ctr_total_return" NULLS FIRST
FETCH NEXT 100 ROWS ONLY

