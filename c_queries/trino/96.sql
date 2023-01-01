SELECT COUNT(*)
FROM tpcds.sf1000.store_sales AS store_sales
INNER JOIN (SELECT *
FROM tpcds.sf1000.household_demographics AS household_demographics
WHERE "hd_dep_count" = 7) AS "t" ON "store_sales"."ss_hdemo_sk" = "t"."hd_demo_sk"
INNER JOIN (SELECT *
FROM tpcds.sf1000.time_dim AS time_dim
WHERE "t_hour" = 20 AND "t_minute" >= 30) AS "t0" ON "store_sales"."ss_sold_time_sk" = "t0"."t_time_sk"
INNER JOIN (SELECT *
FROM tpcds.sf1000.store AS store
WHERE "s_store_name" = 'ese') AS "t1" ON "store_sales"."ss_store_sk" = "t1"."s_store_sk"
ORDER BY COUNT(*) IS NULL, COUNT(*)
LIMIT 100

