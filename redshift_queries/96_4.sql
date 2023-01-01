CREATE TABLE rs_table_96_0 AS SELECT *
FROM store_sales
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 7) AS "t" ON "store_sales"."ss_hdemo_sk" = "t"."hd_demo_sk"
;
SELECT COUNT(*)
FROM "rs_table_96_0"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" = 20 AND "t_minute" >= 30) AS "t" ON "rs_table_96_0"."ss_sold_time_sk" = "t"."t_time_sk"
INNER JOIN (SELECT *
FROM store
WHERE "s_store_name" = 'ese') AS "t0" ON "rs_table_96_0"."ss_store_sk" = "t0"."s_store_sk"
ORDER BY COUNT(*)
LIMIT 100
;
