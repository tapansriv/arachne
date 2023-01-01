CREATE TABLE rs_table_43_0 AS SELECT "d_date_sk", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=2", "d_day_name" = 'Tuesday' AS "=3", "d_day_name" = 'Wednesday' AS "=4", "d_day_name" = 'Thursday' AS "=5", "d_day_name" = 'Friday' AS "=6", "d_day_name" = 'Saturday' AS "=7"
FROM date_dim
WHERE "d_year" = 2000
;
SELECT "t3"."s_store_name", "t3"."s_store_id", SUM("t0"."CASE") AS "sun_sales", SUM("t0"."CASE2") AS "mon_sales", SUM("t0"."CASE3") AS "tue_sales", SUM("t0"."CASE4") AS "wed_sales", SUM("t0"."CASE5") AS "thu_sales", SUM("t0"."CASE6") AS "fri_sales", SUM("t0"."CASE7") AS "sat_sales"
FROM (SELECT "t"."ss_store_sk", CASE WHEN "rs_table_43_0"."=" THEN "t"."ss_sales_price" ELSE NULL END AS "CASE", CASE WHEN "rs_table_43_0"."=2" THEN "t"."ss_sales_price" ELSE NULL END AS "CASE2", CASE WHEN "rs_table_43_0"."=3" THEN "t"."ss_sales_price" ELSE NULL END AS "CASE3", CASE WHEN "rs_table_43_0"."=4" THEN "t"."ss_sales_price" ELSE NULL END AS "CASE4", CASE WHEN "rs_table_43_0"."=5" THEN "t"."ss_sales_price" ELSE NULL END AS "CASE5", CASE WHEN "rs_table_43_0"."=6" THEN "t"."ss_sales_price" ELSE NULL END AS "CASE6", CASE WHEN "rs_table_43_0"."=7" THEN "t"."ss_sales_price" ELSE NULL END AS "CASE7"
FROM "rs_table_43_0"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t" ON "rs_table_43_0"."d_date_sk" = "t"."ss_sold_date_sk") AS "t0"
INNER JOIN (SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM store
WHERE "s_gmt_offset" = -5) AS "t3" ON "t0"."ss_store_sk" = "t3"."s_store_sk"
GROUP BY "t3"."s_store_name", "t3"."s_store_id"
ORDER BY "t3"."s_store_name", "t3"."s_store_id", SUM("t0"."CASE"), SUM("t0"."CASE2"), SUM("t0"."CASE3"), SUM("t0"."CASE4"), SUM("t0"."CASE5"), SUM("t0"."CASE6"), SUM("t0"."CASE7")
LIMIT 100
;
