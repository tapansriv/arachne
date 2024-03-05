SELECT count(*)
FROM `arachne-multicloud.tpcds.store_sales` AS store_sales ,
     `arachne-multicloud.tpcds.household_demographics` AS household_demographics,
     `arachne-multicloud.tpcds.time_dim` AS time_dim,
     `arachne-multicloud.tpcds.store` AS store
WHERE ss_sold_time_sk = time_dim.t_time_sk
  AND ss_hdemo_sk = household_demographics.hd_demo_sk
  AND ss_store_sk = s_store_sk
  AND time_dim.t_hour = 20
  AND time_dim.t_minute >= 30
  AND household_demographics.hd_dep_count = 7
  AND store.s_store_name = 'ese'
ORDER BY count(*)
LIMIT 100;

