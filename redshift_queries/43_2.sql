CREATE TABLE rs_table_43_0 AS SELECT "t2"."ss_store_sk", CASE WHEN "t1"."=" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE", CASE WHEN "t1"."=2" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE2", CASE WHEN "t1"."=3" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE3", CASE WHEN "t1"."=4" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE4", CASE WHEN "t1"."=5" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE5", CASE WHEN "t1"."=6" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE6", CASE WHEN "t1"."=7" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE7"
FROM (SELECT "d_date_sk", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=2", "d_day_name" = 'Tuesday' AS "=3", "d_day_name" = 'Wednesday' AS "=4", "d_day_name" = 'Thursday' AS "=5", "d_day_name" = 'Friday' AS "=6", "d_day_name" = 'Saturday' AS "=7"
FROM date_dim
WHERE "d_year" = 2000) AS "t1"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t2" ON "t1"."d_date_sk" = "t2"."ss_sold_date_sk"
;
SELECT "t1"."s_store_name", "t1"."s_store_id", SUM("rs_table_43_0"."CASE") AS "sun_sales", SUM("rs_table_43_0"."CASE2") AS "mon_sales", SUM("rs_table_43_0"."CASE3") AS "tue_sales", SUM("rs_table_43_0"."CASE4") AS "wed_sales", SUM("rs_table_43_0"."CASE5") AS "thu_sales", SUM("rs_table_43_0"."CASE6") AS "fri_sales", SUM("rs_table_43_0"."CASE7") AS "sat_sales"
FROM "rs_table_43_0"
INNER JOIN (SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM store
WHERE "s_gmt_offset" = -5) AS "t1" ON "rs_table_43_0"."ss_store_sk" = "t1"."s_store_sk"
GROUP BY "t1"."s_store_name", "t1"."s_store_id"
ORDER BY "t1"."s_store_name", "t1"."s_store_id", SUM("rs_table_43_0"."CASE"), SUM("rs_table_43_0"."CASE2"), SUM("rs_table_43_0"."CASE3"), SUM("rs_table_43_0"."CASE4"), SUM("rs_table_43_0"."CASE5"), SUM("rs_table_43_0"."CASE6"), SUM("rs_table_43_0"."CASE7")
LIMIT 100
;
