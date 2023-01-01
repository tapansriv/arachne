CREATE TABLE rs_table_96_0 AS SELECT *
FROM store_sales
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 7) AS "t" ON "store_sales"."ss_hdemo_sk" = "t"."hd_demo_sk"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" = 20 AND "t_minute" >= 30) AS "t0" ON "store_sales"."ss_sold_time_sk" = "t0"."t_time_sk"
INNER JOIN (SELECT *
FROM store
WHERE "s_store_name" = 'ese') AS "t1" ON "store_sales"."ss_store_sk" = "t1"."s_store_sk"
;
SELECT COUNT(*)
FROM "rs_table_96_0"
ORDER BY COUNT(*)
LIMIT 100
;
