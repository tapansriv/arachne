SELECT "t14"."cc_call_center_id" AS "Call_Center", "t14"."cc_name" AS "Call_Center_Name", "t14"."cc_manager" AS "Manager", SUM("t14"."cr_net_loss") AS "Returns_Loss"
FROM (SELECT "t11"."cc_call_center_id", "t11"."cc_name", "t11"."cc_manager", "t11"."cr_net_loss", "t11"."c_current_hdemo_sk", "t13"."cd_marital_status", "t13"."cd_education_status"
FROM (SELECT "t7"."cc_call_center_id", "t7"."cc_name", "t7"."cc_manager", "t7"."cr_net_loss", "t7"."c_current_cdemo_sk", "t7"."c_current_hdemo_sk"
FROM (SELECT "t5"."cc_call_center_id", "t5"."cc_name", "t5"."cc_manager", "t5"."cr_net_loss", "t6"."c_current_cdemo_sk", "t6"."c_current_hdemo_sk", "t6"."c_current_addr_sk"
FROM (SELECT "t1"."cc_call_center_id", "t1"."cc_name", "t1"."cc_manager", "t1"."cr_returning_customer_sk", "t1"."cr_net_loss"
FROM (SELECT "t"."cc_call_center_id", "t"."cc_name", "t"."cc_manager", "t0"."cr_returned_date_sk", "t0"."cr_returning_customer_sk", "t0"."cr_net_loss"
FROM (SELECT "cc_call_center_sk", "cc_call_center_id", "cc_name", "cc_manager"
FROM call_center) AS "t"
INNER JOIN (SELECT "cr_returned_date_sk", "cr_returning_customer_sk", "cr_call_center_sk", "cr_net_loss"
FROM catalog_returns) AS "t0" ON "t"."cc_call_center_sk" = "t0"."cr_call_center_sk") AS "t1"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 1998 AND "d_moy" = 11) AS "t4" ON "t1"."cr_returned_date_sk" = "t4"."d_date_sk") AS "t5"
INNER JOIN (SELECT "c_customer_sk", "c_current_cdemo_sk", "c_current_hdemo_sk", "c_current_addr_sk"
FROM customer) AS "t6" ON "t5"."cr_returning_customer_sk" = "t6"."c_customer_sk") AS "t7"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_gmt_offset" = -7) AS "t10" ON "t7"."c_current_addr_sk" = "t10"."ca_address_sk") AS "t11"
INNER JOIN (SELECT "cd_demo_sk", "cd_marital_status", "cd_education_status"
FROM customer_demographics
WHERE "cd_marital_status" = 'M' AND "cd_education_status" = 'Unknown' OR "cd_marital_status" = 'W' AND "cd_education_status" = 'Advanced Degree') AS "t13" ON "t11"."c_current_cdemo_sk" = "t13"."cd_demo_sk") AS "t14"
INNER JOIN (SELECT "hd_demo_sk"
FROM household_demographics
WHERE "hd_buy_potential" LIKE 'Unknown%') AS "t17" ON "t14"."c_current_hdemo_sk" = "t17"."hd_demo_sk"
GROUP BY "t14"."cc_call_center_id", "t14"."cc_name", "t14"."cc_manager", "t14"."cd_marital_status", "t14"."cd_education_status"
ORDER BY SUM("t14"."cr_net_loss") DESC
;
