CREATE TABLE rs_table_02_0 AS SELECT "t4"."sun_sales" AS "sun_sales2", "t4"."mon_sales" AS "mon_sales2", "t4"."tue_sales" AS "tue_sales2", "t4"."wed_sales" AS "wed_sales2", "t4"."thu_sales" AS "thu_sales2", "t4"."fri_sales" AS "fri_sales2", "t4"."sat_sales" AS "sat_sales2", "t4"."d_week_seq" - 53 AS "-"
FROM (SELECT "t2"."d_week_seq", SUM(CASE WHEN "t2"."=" THEN "t1"."sales_price" ELSE NULL END) AS "sun_sales", SUM(CASE WHEN "t2"."=3" THEN "t1"."sales_price" ELSE NULL END) AS "mon_sales", SUM(CASE WHEN "t2"."=4" THEN "t1"."sales_price" ELSE NULL END) AS "tue_sales", SUM(CASE WHEN "t2"."=5" THEN "t1"."sales_price" ELSE NULL END) AS "wed_sales", SUM(CASE WHEN "t2"."=6" THEN "t1"."sales_price" ELSE NULL END) AS "thu_sales", SUM(CASE WHEN "t2"."=7" THEN "t1"."sales_price" ELSE NULL END) AS "fri_sales", SUM(CASE WHEN "t2"."=8" THEN "t1"."sales_price" ELSE NULL END) AS "sat_sales"
FROM (SELECT "ws_sold_date_sk" AS "sold_date_sk", "ws_ext_sales_price" AS "sales_price"
FROM web_sales
UNION ALL
SELECT "cs_sold_date_sk" AS "sold_date_sk", "cs_ext_sales_price" AS "sales_price"
FROM catalog_sales) AS "t1"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM date_dim) AS "t2" ON "t1"."sold_date_sk" = "t2"."d_date_sk"
GROUP BY "t2"."d_week_seq") AS "t4"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_year" = 2001 + 1) AS "t7" ON "t4"."d_week_seq" = "t7"."d_week_seq"
;
SELECT "t9"."d_week_seq1", ROUND("t9"."sun_sales1" / "rs_table_02_0"."sun_sales2", 2) AS "r1", ROUND("t9"."mon_sales1" / "rs_table_02_0"."mon_sales2", 2) AS "r2", ROUND("t9"."tue_sales1" / "rs_table_02_0"."tue_sales2", 2) AS "r3", ROUND("t9"."wed_sales1" / "rs_table_02_0"."wed_sales2", 2) AS "r4", ROUND("t9"."thu_sales1" / "rs_table_02_0"."thu_sales2", 2) AS "r5", ROUND("t9"."fri_sales1" / "rs_table_02_0"."fri_sales2", 2) AS "r6", ROUND("t9"."sat_sales1" / "rs_table_02_0"."sat_sales2", 2)
FROM (SELECT "t4"."d_week_seq" AS "d_week_seq1", "t4"."sun_sales" AS "sun_sales1", "t4"."mon_sales" AS "mon_sales1", "t4"."tue_sales" AS "tue_sales1", "t4"."wed_sales" AS "wed_sales1", "t4"."thu_sales" AS "thu_sales1", "t4"."fri_sales" AS "fri_sales1", "t4"."sat_sales" AS "sat_sales1"
FROM (SELECT "t2"."d_week_seq", SUM(CASE WHEN "t2"."=" THEN "t1"."sales_price" ELSE NULL END) AS "sun_sales", SUM(CASE WHEN "t2"."=3" THEN "t1"."sales_price" ELSE NULL END) AS "mon_sales", SUM(CASE WHEN "t2"."=4" THEN "t1"."sales_price" ELSE NULL END) AS "tue_sales", SUM(CASE WHEN "t2"."=5" THEN "t1"."sales_price" ELSE NULL END) AS "wed_sales", SUM(CASE WHEN "t2"."=6" THEN "t1"."sales_price" ELSE NULL END) AS "thu_sales", SUM(CASE WHEN "t2"."=7" THEN "t1"."sales_price" ELSE NULL END) AS "fri_sales", SUM(CASE WHEN "t2"."=8" THEN "t1"."sales_price" ELSE NULL END) AS "sat_sales"
FROM (SELECT "ws_sold_date_sk" AS "sold_date_sk", "ws_ext_sales_price" AS "sales_price"
FROM web_sales
UNION ALL
SELECT "cs_sold_date_sk" AS "sold_date_sk", "cs_ext_sales_price" AS "sales_price"
FROM catalog_sales) AS "t1"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM date_dim) AS "t2" ON "t1"."sold_date_sk" = "t2"."d_date_sk"
GROUP BY "t2"."d_week_seq") AS "t4"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_year" = 2001) AS "t7" ON "t4"."d_week_seq" = "t7"."d_week_seq") AS "t9"
INNER JOIN "rs_table_02_0" ON "t9"."d_week_seq1" = "rs_table_02_0"."-"
ORDER BY "t9"."d_week_seq1" NULLS FIRST
;
