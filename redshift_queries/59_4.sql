CREATE TABLE rs_table_59_0 AS SELECT "d_week_seq"
FROM date_dim
WHERE "d_month_seq" >= 1212 AND "d_month_seq" <= 1212 + 11
;
SELECT "t5"."s_store_name1", "t5"."s_store_id1", "t5"."d_week_seq1", "t5"."sun_sales1" / "t16"."sun_sales2", "t5"."mon_sales1" / "t16"."mon_sales2", "t5"."tue_sales1" / "t16"."tue_sales2", "t5"."wed_sales1" / "t16"."wed_sales2", "t5"."thu_sales1" / "t16"."thu_sales2", "t5"."fri_sales1" / "t16"."fri_sales2", "t5"."sat_sales1" / "t16"."sat_sales2"
FROM (SELECT "t4"."s_store_name" AS "s_store_name1", "t4"."d_week_seq" AS "d_week_seq1", "t4"."s_store_id" AS "s_store_id1", "t4"."sun_sales" AS "sun_sales1", "t4"."mon_sales" AS "mon_sales1", "t4"."tue_sales" AS "tue_sales1", "t4"."wed_sales" AS "wed_sales1", "t4"."thu_sales" AS "thu_sales1", "t4"."fri_sales" AS "fri_sales1", "t4"."sat_sales" AS "sat_sales1"
FROM (SELECT "t2"."d_week_seq", "t2"."sun_sales", "t2"."mon_sales", "t2"."tue_sales", "t2"."wed_sales", "t2"."thu_sales", "t2"."fri_sales", "t2"."sat_sales", "t3"."s_store_id", "t3"."s_store_name"
FROM (SELECT "t0"."d_week_seq", "t"."ss_store_sk", SUM(CASE WHEN "t0"."=" THEN "t"."ss_sales_price" ELSE NULL END) AS "sun_sales", SUM(CASE WHEN "t0"."=3" THEN "t"."ss_sales_price" ELSE NULL END) AS "mon_sales", SUM(CASE WHEN "t0"."=4" THEN "t"."ss_sales_price" ELSE NULL END) AS "tue_sales", SUM(CASE WHEN "t0"."=5" THEN "t"."ss_sales_price" ELSE NULL END) AS "wed_sales", SUM(CASE WHEN "t0"."=6" THEN "t"."ss_sales_price" ELSE NULL END) AS "thu_sales", SUM(CASE WHEN "t0"."=7" THEN "t"."ss_sales_price" ELSE NULL END) AS "fri_sales", SUM(CASE WHEN "t0"."=8" THEN "t"."ss_sales_price" ELSE NULL END) AS "sat_sales"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM date_dim) AS "t0" ON "t"."ss_sold_date_sk" = "t0"."d_date_sk"
GROUP BY "t0"."d_week_seq", "t"."ss_store_sk") AS "t2"
INNER JOIN (SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM store) AS "t3" ON "t2"."ss_store_sk" = "t3"."s_store_sk") AS "t4"
INNER JOIN "rs_table_59_0" ON "t4"."d_week_seq" = "rs_table_59_0"."d_week_seq") AS "t5"
INNER JOIN (SELECT "t11"."s_store_id" AS "s_store_id2", "t11"."sun_sales" AS "sun_sales2", "t11"."mon_sales" AS "mon_sales2", "t11"."tue_sales" AS "tue_sales2", "t11"."wed_sales" AS "wed_sales2", "t11"."thu_sales" AS "thu_sales2", "t11"."fri_sales" AS "fri_sales2", "t11"."sat_sales" AS "sat_sales2", "t11"."d_week_seq" - 52 AS "-"
FROM (SELECT "t9"."d_week_seq", "t9"."sun_sales", "t9"."mon_sales", "t9"."tue_sales", "t9"."wed_sales", "t9"."thu_sales", "t9"."fri_sales", "t9"."sat_sales", "t10"."s_store_id", "t10"."s_store_name"
FROM (SELECT "t7"."d_week_seq", "t6"."ss_store_sk", SUM(CASE WHEN "t7"."=" THEN "t6"."ss_sales_price" ELSE NULL END) AS "sun_sales", SUM(CASE WHEN "t7"."=3" THEN "t6"."ss_sales_price" ELSE NULL END) AS "mon_sales", SUM(CASE WHEN "t7"."=4" THEN "t6"."ss_sales_price" ELSE NULL END) AS "tue_sales", SUM(CASE WHEN "t7"."=5" THEN "t6"."ss_sales_price" ELSE NULL END) AS "wed_sales", SUM(CASE WHEN "t7"."=6" THEN "t6"."ss_sales_price" ELSE NULL END) AS "thu_sales", SUM(CASE WHEN "t7"."=7" THEN "t6"."ss_sales_price" ELSE NULL END) AS "fri_sales", SUM(CASE WHEN "t7"."=8" THEN "t6"."ss_sales_price" ELSE NULL END) AS "sat_sales"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t6"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM date_dim) AS "t7" ON "t6"."ss_sold_date_sk" = "t7"."d_date_sk"
GROUP BY "t7"."d_week_seq", "t6"."ss_store_sk") AS "t9"
INNER JOIN (SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM store) AS "t10" ON "t9"."ss_store_sk" = "t10"."s_store_sk") AS "t11"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_month_seq" >= 1212 + 12 AND "d_month_seq" <= 1212 + 23) AS "t14" ON "t11"."d_week_seq" = "t14"."d_week_seq") AS "t16" ON "t5"."s_store_id1" = "t16"."s_store_id2" AND "t5"."d_week_seq1" = "t16"."-"
ORDER BY "t5"."s_store_name1" NULLS FIRST, "t5"."s_store_id1" NULLS FIRST, "t5"."d_week_seq1" NULLS FIRST
LIMIT 100
;
