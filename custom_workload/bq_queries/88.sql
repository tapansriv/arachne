SELECT *
FROM
  (SELECT count(*) h8_30_to_9
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.household_demographics` AS household_demographics,
        `arachne-multicloud.tpcds.time_dim` AS time_dim,
        `arachne-multicloud.tpcds.store` AS store
   WHERE ss_sold_time_sk = time_dim.t_time_sk
     AND ss_hdemo_sk = household_demographics.hd_demo_sk
     AND ss_store_sk = s_store_sk
     AND time_dim.t_hour = 8
     AND time_dim.t_minute >= 30
     AND ((household_demographics.hd_dep_count = 4
           AND household_demographics.hd_vehicle_count<=4+2)
          OR (household_demographics.hd_dep_count = 2
              AND household_demographics.hd_vehicle_count<=2+2)
          OR (household_demographics.hd_dep_count = 0
              AND household_demographics.hd_vehicle_count<=0+2))
     AND store.s_store_name = 'ese') s1,
  (SELECT count(*) h9_to_9_30
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.household_demographics` AS household_demographics,
        `arachne-multicloud.tpcds.time_dim` AS time_dim,
        `arachne-multicloud.tpcds.store` AS store
   WHERE ss_sold_time_sk = time_dim.t_time_sk
     AND ss_hdemo_sk = household_demographics.hd_demo_sk
     AND ss_store_sk = s_store_sk
     AND time_dim.t_hour = 9
     AND time_dim.t_minute < 30
     AND ((household_demographics.hd_dep_count = 4
           AND household_demographics.hd_vehicle_count<=4+2)
          OR (household_demographics.hd_dep_count = 2
              AND household_demographics.hd_vehicle_count<=2+2)
          OR (household_demographics.hd_dep_count = 0
              AND household_demographics.hd_vehicle_count<=0+2))
     AND store.s_store_name = 'ese') s2,
  (SELECT count(*) h9_30_to_10
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.household_demographics` AS household_demographics,
        `arachne-multicloud.tpcds.time_dim` AS time_dim,
        `arachne-multicloud.tpcds.store` AS store
   WHERE ss_sold_time_sk = time_dim.t_time_sk
     AND ss_hdemo_sk = household_demographics.hd_demo_sk
     AND ss_store_sk = s_store_sk
     AND time_dim.t_hour = 9
     AND time_dim.t_minute >= 30
     AND ((household_demographics.hd_dep_count = 4
           AND household_demographics.hd_vehicle_count<=4+2)
          OR (household_demographics.hd_dep_count = 2
              AND household_demographics.hd_vehicle_count<=2+2)
          OR (household_demographics.hd_dep_count = 0
              AND household_demographics.hd_vehicle_count<=0+2))
     AND store.s_store_name = 'ese') s3,
  (SELECT count(*) h10_to_10_30
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.household_demographics` AS household_demographics,
        `arachne-multicloud.tpcds.time_dim` AS time_dim,
        `arachne-multicloud.tpcds.store` AS store
   WHERE ss_sold_time_sk = time_dim.t_time_sk
     AND ss_hdemo_sk = household_demographics.hd_demo_sk
     AND ss_store_sk = s_store_sk
     AND time_dim.t_hour = 10
     AND time_dim.t_minute < 30
     AND ((household_demographics.hd_dep_count = 4
           AND household_demographics.hd_vehicle_count<=4+2)
          OR (household_demographics.hd_dep_count = 2
              AND household_demographics.hd_vehicle_count<=2+2)
          OR (household_demographics.hd_dep_count = 0
              AND household_demographics.hd_vehicle_count<=0+2))
     AND store.s_store_name = 'ese') s4,
  (SELECT count(*) h10_30_to_11
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.household_demographics` AS household_demographics,
        `arachne-multicloud.tpcds.time_dim` AS time_dim,
        `arachne-multicloud.tpcds.store` AS store
   WHERE ss_sold_time_sk = time_dim.t_time_sk
     AND ss_hdemo_sk = household_demographics.hd_demo_sk
     AND ss_store_sk = s_store_sk
     AND time_dim.t_hour = 10
     AND time_dim.t_minute >= 30
     AND ((household_demographics.hd_dep_count = 4
           AND household_demographics.hd_vehicle_count<=4+2)
          OR (household_demographics.hd_dep_count = 2
              AND household_demographics.hd_vehicle_count<=2+2)
          OR (household_demographics.hd_dep_count = 0
              AND household_demographics.hd_vehicle_count<=0+2))
     AND store.s_store_name = 'ese') s5,
  (SELECT count(*) h11_to_11_30
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.household_demographics` AS household_demographics,
        `arachne-multicloud.tpcds.time_dim` AS time_dim,
        `arachne-multicloud.tpcds.store` AS store
   WHERE ss_sold_time_sk = time_dim.t_time_sk
     AND ss_hdemo_sk = household_demographics.hd_demo_sk
     AND ss_store_sk = s_store_sk
     AND time_dim.t_hour = 11
     AND time_dim.t_minute < 30
     AND ((household_demographics.hd_dep_count = 4
           AND household_demographics.hd_vehicle_count<=4+2)
          OR (household_demographics.hd_dep_count = 2
              AND household_demographics.hd_vehicle_count<=2+2)
          OR (household_demographics.hd_dep_count = 0
              AND household_demographics.hd_vehicle_count<=0+2))
     AND store.s_store_name = 'ese') s6,
  (SELECT count(*) h11_30_to_12
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.household_demographics` AS household_demographics,
        `arachne-multicloud.tpcds.time_dim` AS time_dim,
        `arachne-multicloud.tpcds.store` AS store
   WHERE ss_sold_time_sk = time_dim.t_time_sk
     AND ss_hdemo_sk = household_demographics.hd_demo_sk
     AND ss_store_sk = s_store_sk
     AND time_dim.t_hour = 11
     AND time_dim.t_minute >= 30
     AND ((household_demographics.hd_dep_count = 4
           AND household_demographics.hd_vehicle_count<=4+2)
          OR (household_demographics.hd_dep_count = 2
              AND household_demographics.hd_vehicle_count<=2+2)
          OR (household_demographics.hd_dep_count = 0
              AND household_demographics.hd_vehicle_count<=0+2))
     AND store.s_store_name = 'ese') s7,
  (SELECT count(*) h12_to_12_30
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.household_demographics` AS household_demographics,
        `arachne-multicloud.tpcds.time_dim` AS time_dim,
        `arachne-multicloud.tpcds.store` AS store
   WHERE ss_sold_time_sk = time_dim.t_time_sk
     AND ss_hdemo_sk = household_demographics.hd_demo_sk
     AND ss_store_sk = s_store_sk
     AND time_dim.t_hour = 12
     AND time_dim.t_minute < 30
     AND ((household_demographics.hd_dep_count = 4
           AND household_demographics.hd_vehicle_count<=4+2)
          OR (household_demographics.hd_dep_count = 2
              AND household_demographics.hd_vehicle_count<=2+2)
          OR (household_demographics.hd_dep_count = 0
              AND household_demographics.hd_vehicle_count<=0+2))
     AND store.s_store_name = 'ese') s8 ;

