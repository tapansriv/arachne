SELECT "t10"."c_customer_id" AS "customer_id", "t10"."||" AS "customername"
FROM (SELECT "t7"."c_customer_id", "t7"."cd_demo_sk", "t7"."||"
FROM (SELECT "t5"."c_customer_id", "t5"."cd_demo_sk", "t6"."hd_income_band_sk", "t5"."||"
FROM (SELECT "t3"."c_customer_id", "t3"."c_current_hdemo_sk", "t4"."cd_demo_sk", "t3"."||"
FROM (SELECT "t"."c_customer_id", "t"."c_current_cdemo_sk", "t"."c_current_hdemo_sk", "t"."||"
FROM (SELECT "c_customer_id", "c_current_cdemo_sk", "c_current_hdemo_sk", "c_current_addr_sk", "c_last_name" || ', ' || "c_first_name" AS "||"
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
WHERE "ib_lower_bound" >= 38128 AND "ib_upper_bound" <= 38128 + 50000) AS "t9" ON "t7"."hd_income_band_sk" = "t9"."ib_income_band_sk") AS "t10"
INNER JOIN (SELECT "sr_cdemo_sk"
FROM store_returns) AS "t11" ON "t10"."cd_demo_sk" = "t11"."sr_cdemo_sk"
ORDER BY "t10"."c_customer_id"
LIMIT 100
;
