CREATE TABLE rs_table_59_0 AS SELECT "t2"."d_week_seq", "t2"."sun_sales", "t2"."mon_sales", "t2"."tue_sales", "t2"."wed_sales", "t2"."thu_sales", "t2"."fri_sales", "t2"."sat_sales", "t3"."s_store_id", "t3"."s_store_name"
FROM (SELECT "t0"."d_week_seq", "t"."ss_store_sk", SUM(CASE WHEN "t0"."=" THEN "t"."ss_sales_price" ELSE NULL END) AS "sun_sales", SUM(CASE WHEN "t0"."=3" THEN "t"."ss_sales_price" ELSE NULL END) AS "mon_sales", SUM(CASE WHEN "t0"."=4" THEN "t"."ss_sales_price" ELSE NULL END) AS "tue_sales", SUM(CASE WHEN "t0"."=5" THEN "t"."ss_sales_price" ELSE NULL END) AS "wed_sales", SUM(CASE WHEN "t0"."=6" THEN "t"."ss_sales_price" ELSE NULL END) AS "thu_sales", SUM(CASE WHEN "t0"."=7" THEN "t"."ss_sales_price" ELSE NULL END) AS "fri_sales", SUM(CASE WHEN "t0"."=8" THEN "t"."ss_sales_price" ELSE NULL END) AS "sat_sales"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM date_dim) AS "t0" ON "t"."ss_sold_date_sk" = "t0"."d_date_sk"
GROUP BY "t0"."d_week_seq", "t"."ss_store_sk") AS "t2"
INNER JOIN (SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM store) AS "t3" ON "t2"."ss_store_sk" = "t3"."s_store_sk"
;
SELECT "t2"."s_store_name1", "t2"."s_store_id1", "t2"."d_week_seq1", "t2"."sun_sales1" / "t13"."sun_sales2", "t2"."mon_sales1" / "t13"."mon_sales2", "t2"."tue_sales1" / "t13"."tue_sales2", "t2"."wed_sales1" / "t13"."wed_sales2", "t2"."thu_sales1" / "t13"."thu_sales2", "t2"."fri_sales1" / "t13"."fri_sales2", "t2"."sat_sales1" / "t13"."sat_sales2"
FROM (SELECT "rs_table_59_0"."s_store_name" AS "s_store_name1", "rs_table_59_0"."d_week_seq" AS "d_week_seq1", "rs_table_59_0"."s_store_id" AS "s_store_id1", "rs_table_59_0"."sun_sales" AS "sun_sales1", "rs_table_59_0"."mon_sales" AS "mon_sales1", "rs_table_59_0"."tue_sales" AS "tue_sales1", "rs_table_59_0"."wed_sales" AS "wed_sales1", "rs_table_59_0"."thu_sales" AS "thu_sales1", "rs_table_59_0"."fri_sales" AS "fri_sales1", "rs_table_59_0"."sat_sales" AS "sat_sales1"
FROM "rs_table_59_0"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_month_seq" >= 1212 AND "d_month_seq" <= 1212 + 11) AS "t1" ON "rs_table_59_0"."d_week_seq" = "t1"."d_week_seq") AS "t2"
INNER JOIN (SELECT "t8"."s_store_id" AS "s_store_id2", "t8"."sun_sales" AS "sun_sales2", "t8"."mon_sales" AS "mon_sales2", "t8"."tue_sales" AS "tue_sales2", "t8"."wed_sales" AS "wed_sales2", "t8"."thu_sales" AS "thu_sales2", "t8"."fri_sales" AS "fri_sales2", "t8"."sat_sales" AS "sat_sales2", "t8"."d_week_seq" - 52 AS "-"
FROM (SELECT "t6"."d_week_seq", "t6"."sun_sales", "t6"."mon_sales", "t6"."tue_sales", "t6"."wed_sales", "t6"."thu_sales", "t6"."fri_sales", "t6"."sat_sales", "t7"."s_store_id", "t7"."s_store_name"
FROM (SELECT "t4"."d_week_seq", "t3"."ss_store_sk", SUM(CASE WHEN "t4"."=" THEN "t3"."ss_sales_price" ELSE NULL END) AS "sun_sales", SUM(CASE WHEN "t4"."=3" THEN "t3"."ss_sales_price" ELSE NULL END) AS "mon_sales", SUM(CASE WHEN "t4"."=4" THEN "t3"."ss_sales_price" ELSE NULL END) AS "tue_sales", SUM(CASE WHEN "t4"."=5" THEN "t3"."ss_sales_price" ELSE NULL END) AS "wed_sales", SUM(CASE WHEN "t4"."=6" THEN "t3"."ss_sales_price" ELSE NULL END) AS "thu_sales", SUM(CASE WHEN "t4"."=7" THEN "t3"."ss_sales_price" ELSE NULL END) AS "fri_sales", SUM(CASE WHEN "t4"."=8" THEN "t3"."ss_sales_price" ELSE NULL END) AS "sat_sales"
FROM (SELECT "ss_sold_date_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t3"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM date_dim) AS "t4" ON "t3"."ss_sold_date_sk" = "t4"."d_date_sk"
GROUP BY "t4"."d_week_seq", "t3"."ss_store_sk") AS "t6"
INNER JOIN (SELECT "s_store_sk", "s_store_id", "s_store_name"
FROM store) AS "t7" ON "t6"."ss_store_sk" = "t7"."s_store_sk") AS "t8"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_month_seq" >= 1212 + 12 AND "d_month_seq" <= 1212 + 23) AS "t11" ON "t8"."d_week_seq" = "t11"."d_week_seq") AS "t13" ON "t2"."s_store_id1" = "t13"."s_store_id2" AND "t2"."d_week_seq1" = "t13"."-"
ORDER BY "t2"."s_store_name1" NULLS FIRST, "t2"."s_store_id1" NULLS FIRST, "t2"."d_week_seq1" NULLS FIRST
LIMIT 100
;
