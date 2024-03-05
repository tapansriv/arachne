SELECT c_customer_id AS customer_id ,
       concat(concat(coalesce(c_last_name, '') , ', '), coalesce(c_first_name, '')) AS customername
FROM `arachne-multicloud.tpcds.customer` AS customer ,
     `arachne-multicloud.tpcds.customer_address` AS customer_address ,
     `arachne-multicloud.tpcds.customer_demographics` AS customer_demographics ,
     `arachne-multicloud.tpcds.household_demographics` AS household_demographics ,
     `arachne-multicloud.tpcds.income_band` AS income_band ,
     `arachne-multicloud.tpcds.store_returns` AS store_returns
WHERE ca_city = 'Edgewood'
  AND c_current_addr_sk = ca_address_sk
  AND ib_lower_bound >= 38128
  AND ib_upper_bound <= 38128 + 50000
  AND ib_income_band_sk = hd_income_band_sk
  AND cd_demo_sk = c_current_cdemo_sk
  AND hd_demo_sk = c_current_hdemo_sk
  AND sr_cdemo_sk = cd_demo_sk
ORDER BY c_customer_id NULLS FIRST
LIMIT 100;
