SELECT *
FROM (SELECT COUNT(*) AS "h8_30_to_9"
FROM store_sales
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 4 AND "hd_vehicle_count" <= 4 + 2 OR "hd_dep_count" = 2 AND "hd_vehicle_count" <= 2 + 2 OR "hd_dep_count" = 0 AND "hd_vehicle_count" <= 0 + 2) AS "t" ON "store_sales"."ss_hdemo_sk" = "t"."hd_demo_sk"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" = 8 AND "t_minute" >= 30) AS "t0" ON "store_sales"."ss_sold_time_sk" = "t0"."t_time_sk"
INNER JOIN (SELECT *
FROM store
WHERE "s_store_name" = 'ese') AS "t1" ON "store_sales"."ss_store_sk" = "t1"."s_store_sk") AS "t2",
(SELECT COUNT(*) AS "h9_to_9_30"
FROM store_sales AS "store_sales0"
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 4 AND "hd_vehicle_count" <= 4 + 2 OR "hd_dep_count" = 2 AND "hd_vehicle_count" <= 2 + 2 OR "hd_dep_count" = 0 AND "hd_vehicle_count" <= 0 + 2) AS "t3" ON "store_sales0"."ss_hdemo_sk" = "t3"."hd_demo_sk"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" = 9 AND "t_minute" < 30) AS "t4" ON "store_sales0"."ss_sold_time_sk" = "t4"."t_time_sk"
INNER JOIN (SELECT *
FROM store
WHERE "s_store_name" = 'ese') AS "t5" ON "store_sales0"."ss_store_sk" = "t5"."s_store_sk") AS "t6",
(SELECT COUNT(*) AS "h9_30_to_10"
FROM store_sales AS "store_sales1"
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 4 AND "hd_vehicle_count" <= 4 + 2 OR "hd_dep_count" = 2 AND "hd_vehicle_count" <= 2 + 2 OR "hd_dep_count" = 0 AND "hd_vehicle_count" <= 0 + 2) AS "t7" ON "store_sales1"."ss_hdemo_sk" = "t7"."hd_demo_sk"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" = 9 AND "t_minute" >= 30) AS "t8" ON "store_sales1"."ss_sold_time_sk" = "t8"."t_time_sk"
INNER JOIN (SELECT *
FROM store
WHERE "s_store_name" = 'ese') AS "t9" ON "store_sales1"."ss_store_sk" = "t9"."s_store_sk") AS "t10",
(SELECT COUNT(*) AS "h10_to_10_30"
FROM store_sales AS "store_sales2"
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 4 AND "hd_vehicle_count" <= 4 + 2 OR "hd_dep_count" = 2 AND "hd_vehicle_count" <= 2 + 2 OR "hd_dep_count" = 0 AND "hd_vehicle_count" <= 0 + 2) AS "t11" ON "store_sales2"."ss_hdemo_sk" = "t11"."hd_demo_sk"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" = 10 AND "t_minute" < 30) AS "t12" ON "store_sales2"."ss_sold_time_sk" = "t12"."t_time_sk"
INNER JOIN (SELECT *
FROM store
WHERE "s_store_name" = 'ese') AS "t13" ON "store_sales2"."ss_store_sk" = "t13"."s_store_sk") AS "t14",
(SELECT COUNT(*) AS "h10_30_to_11"
FROM store_sales AS "store_sales3"
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 4 AND "hd_vehicle_count" <= 4 + 2 OR "hd_dep_count" = 2 AND "hd_vehicle_count" <= 2 + 2 OR "hd_dep_count" = 0 AND "hd_vehicle_count" <= 0 + 2) AS "t15" ON "store_sales3"."ss_hdemo_sk" = "t15"."hd_demo_sk"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" = 10 AND "t_minute" >= 30) AS "t16" ON "store_sales3"."ss_sold_time_sk" = "t16"."t_time_sk"
INNER JOIN (SELECT *
FROM store
WHERE "s_store_name" = 'ese') AS "t17" ON "store_sales3"."ss_store_sk" = "t17"."s_store_sk") AS "t18",
(SELECT COUNT(*) AS "h11_to_11_30"
FROM store_sales AS "store_sales4"
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 4 AND "hd_vehicle_count" <= 4 + 2 OR "hd_dep_count" = 2 AND "hd_vehicle_count" <= 2 + 2 OR "hd_dep_count" = 0 AND "hd_vehicle_count" <= 0 + 2) AS "t19" ON "store_sales4"."ss_hdemo_sk" = "t19"."hd_demo_sk"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" = 11 AND "t_minute" < 30) AS "t20" ON "store_sales4"."ss_sold_time_sk" = "t20"."t_time_sk"
INNER JOIN (SELECT *
FROM store
WHERE "s_store_name" = 'ese') AS "t21" ON "store_sales4"."ss_store_sk" = "t21"."s_store_sk") AS "t22",
(SELECT COUNT(*) AS "h11_30_to_12"
FROM store_sales AS "store_sales5"
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 4 AND "hd_vehicle_count" <= 4 + 2 OR "hd_dep_count" = 2 AND "hd_vehicle_count" <= 2 + 2 OR "hd_dep_count" = 0 AND "hd_vehicle_count" <= 0 + 2) AS "t23" ON "store_sales5"."ss_hdemo_sk" = "t23"."hd_demo_sk"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" = 11 AND "t_minute" >= 30) AS "t24" ON "store_sales5"."ss_sold_time_sk" = "t24"."t_time_sk"
INNER JOIN (SELECT *
FROM store
WHERE "s_store_name" = 'ese') AS "t25" ON "store_sales5"."ss_store_sk" = "t25"."s_store_sk") AS "t26",
(SELECT COUNT(*) AS "h12_to_12_30"
FROM store_sales AS "store_sales6"
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 4 AND "hd_vehicle_count" <= 4 + 2 OR "hd_dep_count" = 2 AND "hd_vehicle_count" <= 2 + 2 OR "hd_dep_count" = 0 AND "hd_vehicle_count" <= 0 + 2) AS "t27" ON "store_sales6"."ss_hdemo_sk" = "t27"."hd_demo_sk"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" = 12 AND "t_minute" < 30) AS "t28" ON "store_sales6"."ss_sold_time_sk" = "t28"."t_time_sk"
INNER JOIN (SELECT *
FROM store
WHERE "s_store_name" = 'ese') AS "t29" ON "store_sales6"."ss_store_sk" = "t29"."s_store_sk") AS "t30"

