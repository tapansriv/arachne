SELECT "t9"."d_week_seq1", ROUND("t9"."sun_sales1" / "t20"."sun_sales2", 2) AS "r1", ROUND("t9"."mon_sales1" / "t20"."mon_sales2", 2) AS "r2", ROUND("t9"."tue_sales1" / "t20"."tue_sales2", 2) AS "r3", ROUND("t9"."wed_sales1" / "t20"."wed_sales2", 2) AS "r4", ROUND("t9"."thu_sales1" / "t20"."thu_sales2", 2) AS "r5", ROUND("t9"."fri_sales1" / "t20"."fri_sales2", 2) AS "r6", ROUND("t9"."sat_sales1" / "t20"."sat_sales2", 2)
FROM (SELECT "t4"."d_week_seq" AS "d_week_seq1", "t4"."sun_sales" AS "sun_sales1", "t4"."mon_sales" AS "mon_sales1", "t4"."tue_sales" AS "tue_sales1", "t4"."wed_sales" AS "wed_sales1", "t4"."thu_sales" AS "thu_sales1", "t4"."fri_sales" AS "fri_sales1", "t4"."sat_sales" AS "sat_sales1"
FROM (SELECT "t2"."d_week_seq", SUM("t1"."sales_price") FILTER (WHERE "t2"."=") AS "sun_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=3") AS "mon_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=4") AS "tue_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=5") AS "wed_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=6") AS "thu_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=7") AS "fri_sales", SUM("t1"."sales_price") FILTER (WHERE "t2"."=8") AS "sat_sales"
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
INNER JOIN (SELECT "t15"."sun_sales" AS "sun_sales2", "t15"."mon_sales" AS "mon_sales2", "t15"."tue_sales" AS "tue_sales2", "t15"."wed_sales" AS "wed_sales2", "t15"."thu_sales" AS "thu_sales2", "t15"."fri_sales" AS "fri_sales2", "t15"."sat_sales" AS "sat_sales2", "t15"."d_week_seq" - 53 AS "-"
FROM (SELECT "t13"."d_week_seq", SUM("t12"."sales_price") FILTER (WHERE "t13"."=") AS "sun_sales", SUM("t12"."sales_price") FILTER (WHERE "t13"."=3") AS "mon_sales", SUM("t12"."sales_price") FILTER (WHERE "t13"."=4") AS "tue_sales", SUM("t12"."sales_price") FILTER (WHERE "t13"."=5") AS "wed_sales", SUM("t12"."sales_price") FILTER (WHERE "t13"."=6") AS "thu_sales", SUM("t12"."sales_price") FILTER (WHERE "t13"."=7") AS "fri_sales", SUM("t12"."sales_price") FILTER (WHERE "t13"."=8") AS "sat_sales"
FROM (SELECT "ws_sold_date_sk" AS "sold_date_sk", "ws_ext_sales_price" AS "sales_price"
FROM web_sales
UNION ALL
SELECT "cs_sold_date_sk" AS "sold_date_sk", "cs_ext_sales_price" AS "sales_price"
FROM catalog_sales) AS "t12"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM date_dim) AS "t13" ON "t12"."sold_date_sk" = "t13"."d_date_sk"
GROUP BY "t13"."d_week_seq") AS "t15"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_year" = 2001 + 1) AS "t18" ON "t15"."d_week_seq" = "t18"."d_week_seq") AS "t20" ON "t9"."d_week_seq1" = "t20"."-"
ORDER BY "t9"."d_week_seq1" NULLS FIRST

