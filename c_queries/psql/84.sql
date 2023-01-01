SELECT "t11"."c_customer_id" AS "customer_id", "t11"."||" AS "customername"
FROM (SELECT "t7"."c_customer_id", "t7"."cd_demo_sk", "t7"."c_last_name" || ', ' || "t7"."c_first_name" AS "||"
FROM (SELECT "t5"."c_customer_id", "t5"."c_first_name", "t5"."c_last_name", "t5"."cd_demo_sk", "t6"."hd_income_band_sk"
FROM (SELECT "t3"."c_customer_id", "t3"."c_current_hdemo_sk", "t3"."c_first_name", "t3"."c_last_name", "t4"."cd_demo_sk"
FROM (SELECT "t"."c_customer_id", "t"."c_current_cdemo_sk", "t"."c_current_hdemo_sk", "t"."c_first_name", "t"."c_last_name"
FROM (SELECT "c_customer_id", "c_current_cdemo_sk", "c_current_hdemo_sk", "c_current_addr_sk", "c_first_name", "c_last_name"
FROM customer) AS "t"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_city" = 'Edgewood') AS "t2" ON "t"."c_current_addr_sk" = "t2"."ca_address_sk") AS "t3"
INNER JOIN (SELECT "cd_demo_sk"
FROM customer_demographics) AS "t4" ON "t3"."c_current_cdemo_sk" = "t4"."cd_demo_sk") AS "t5"
INNER JOIN (SELECT "hd_demo_sk", "hd_income_band_sk"
FROM household_demographics) AS "t6" ON "t5"."c_current_hdemo_sk" = "t6"."hd_demo_sk") AS "t7"
INNER JOIN (SELECT "ib_income_band_sk"
FROM income_band
WHERE "ib_lower_bound" >= 38128 AND "ib_upper_bound" <= 38128 + 50000) AS "t9" ON "t7"."hd_income_band_sk" = "t9"."ib_income_band_sk") AS "t11"
INNER JOIN (SELECT "sr_cdemo_sk"
FROM store_returns) AS "t12" ON "t11"."cd_demo_sk" = "t12"."sr_cdemo_sk"
ORDER BY "t11"."c_customer_id" NULLS FIRST
FETCH NEXT 100 ROWS ONLY

