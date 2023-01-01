CREATE TABLE rs_table_43_0 AS SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM store
WHERE "s_gmt_offset" = -5
;
SELECT "rs_table_43_0"."s_store_name", "rs_table_43_0"."s_store_id", SUM("t3"."CASE") AS "sun_sales", SUM("t3"."CASE2") AS "mon_sales", SUM("t3"."CASE3") AS "tue_sales", SUM("t3"."CASE4") AS "wed_sales", SUM("t3"."CASE5") AS "thu_sales", SUM("t3"."CASE6") AS "fri_sales", SUM("t3"."CASE7") AS "sat_sales"
FROM (SELECT "t2"."ss_store_sk", CASE WHEN "t1"."=" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE", CASE WHEN "t1"."=2" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE2", CASE WHEN "t1"."=3" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE3", CASE WHEN "t1"."=4" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE4", CASE WHEN "t1"."=5" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE5", CASE WHEN "t1"."=6" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE6", CASE WHEN "t1"."=7" THEN "t2"."ss_sales_price" ELSE NULL END AS "CASE7"
FROM (SELECT "d_date_sk", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=2", "d_day_name" = 'Tuesday' AS "=3", "d_day_name" = 'Wednesday' AS "=4", "d_day_name" = 'Thursday' AS "=5", "d_day_name" = 'Friday' AS "=6", "d_day_name" = 'Saturday' AS "=7"
FROM date_dim
WHERE "d_year" = 2000) AS "t1"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t2" ON "t1"."d_date_sk" = "t2"."ss_sold_date_sk") AS "t3"
INNER JOIN "rs_table_43_0" ON "t3"."ss_store_sk" = "rs_table_43_0"."s_store_sk"
GROUP BY "rs_table_43_0"."s_store_name", "rs_table_43_0"."s_store_id"
ORDER BY "rs_table_43_0"."s_store_name", "rs_table_43_0"."s_store_id", SUM("t3"."CASE"), SUM("t3"."CASE2"), SUM("t3"."CASE3"), SUM("t3"."CASE4"), SUM("t3"."CASE5"), SUM("t3"."CASE6"), SUM("t3"."CASE7")
LIMIT 100
;
