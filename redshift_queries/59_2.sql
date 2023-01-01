CREATE TABLE rs_table_59_0 AS SELECT "t4"."s_store_id" AS "s_store_id2", "t4"."sun_sales" AS "sun_sales2", "t4"."mon_sales" AS "mon_sales2", "t4"."tue_sales" AS "tue_sales2", "t4"."wed_sales" AS "wed_sales2", "t4"."thu_sales" AS "thu_sales2", "t4"."fri_sales" AS "fri_sales2", "t4"."sat_sales" AS "sat_sales2", "t4"."d_week_seq" - 52 AS "-"
FROM (SELECT "t2"."d_week_seq", "t2"."sun_sales", "t2"."mon_sales", "t2"."tue_sales", "t2"."wed_sales", "t2"."thu_sales", "t2"."fri_sales", "t2"."sat_sales", "t3"."s_store_id", "t3"."s_store_name"
FROM (SELECT "t0"."d_week_seq", "t"."ss_store_sk", SUM(CASE WHEN "t0"."=" THEN "t"."ss_sales_price" ELSE NULL END) AS "sun_sales", SUM(CASE WHEN "t0"."=3" THEN "t"."ss_sales_price" ELSE NULL END) AS "mon_sales", SUM(CASE WHEN "t0"."=4" THEN "t"."ss_sales_price" ELSE NULL END) AS "tue_sales", SUM(CASE WHEN "t0"."=5" THEN "t"."ss_sales_price" ELSE NULL END) AS "wed_sales", SUM(CASE WHEN "t0"."=6" THEN "t"."ss_sales_price" ELSE NULL END) AS "thu_sales", SUM(CASE WHEN "t0"."=7" THEN "t"."ss_sales_price" ELSE NULL END) AS "fri_sales", SUM(CASE WHEN "t0"."=8" THEN "t"."ss_sales_price" ELSE NULL END) AS "sat_sales"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM date_dim) AS "t0" ON "t"."ss_sold_date_sk" = "t0"."d_date_sk"
GROUP BY "t0"."d_week_seq", "t"."ss_store_sk") AS "t2"
INNER JOIN (SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM store) AS "t3" ON "t2"."ss_store_sk" = "t3"."s_store_sk") AS "t4"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_month_seq" >= 1212 + 12 AND "d_month_seq" <= 1212 + 23) AS "t7" ON "t4"."d_week_seq" = "t7"."d_week_seq"
;
SELECT "t8"."s_store_name1", "t8"."s_store_id1", "t8"."d_week_seq1", "t8"."sun_sales1" / "rs_table_59_0"."sun_sales2", "t8"."mon_sales1" / "rs_table_59_0"."mon_sales2", "t8"."tue_sales1" / "rs_table_59_0"."tue_sales2", "t8"."wed_sales1" / "rs_table_59_0"."wed_sales2", "t8"."thu_sales1" / "rs_table_59_0"."thu_sales2", "t8"."fri_sales1" / "rs_table_59_0"."fri_sales2", "t8"."sat_sales1" / "rs_table_59_0"."sat_sales2"
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
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_month_seq" >= 1212 AND "d_month_seq" <= 1212 + 11) AS "t7" ON "t4"."d_week_seq" = "t7"."d_week_seq") AS "t8"
INNER JOIN "rs_table_59_0" ON "t8"."s_store_id1" = "rs_table_59_0"."s_store_id2" AND "t8"."d_week_seq1" = "rs_table_59_0"."-"
ORDER BY "t8"."s_store_name1" NULLS FIRST, "t8"."s_store_id1" NULLS FIRST, "t8"."d_week_seq1" NULLS FIRST
LIMIT 100
;
