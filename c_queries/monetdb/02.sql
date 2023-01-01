SELECT "t12"."d_week_seq1", ROUND("t12"."sun_sales1" / "t26"."sun_sales2", 2) AS "r1", ROUND("t12"."mon_sales1" / "t26"."mon_sales2", 2) AS "r2", ROUND("t12"."tue_sales1" / "t26"."tue_sales2", 2) AS "r3", ROUND("t12"."wed_sales1" / "t26"."wed_sales2", 2) AS "r4", ROUND("t12"."thu_sales1" / "t26"."thu_sales2", 2) AS "r5", ROUND("t12"."fri_sales1" / "t26"."fri_sales2", 2) AS "r6", ROUND("t12"."sat_sales1" / "t26"."sat_sales2", 2)
FROM (SELECT "t7"."d_week_seq" AS "d_week_seq1", "t7"."sun_sales" AS "sun_sales1", "t7"."mon_sales" AS "mon_sales1", "t7"."tue_sales" AS "tue_sales1", "t7"."wed_sales" AS "wed_sales1", "t7"."thu_sales" AS "thu_sales1", "t7"."fri_sales" AS "fri_sales1", "t7"."sat_sales" AS "sat_sales1"
FROM (SELECT "t4"."d_week_seq", SUM("t3"."sales_price") FILTER (WHERE "t4"."=") AS "sun_sales", SUM("t3"."sales_price") FILTER (WHERE "t4"."=3") AS "mon_sales", SUM("t3"."sales_price") FILTER (WHERE "t4"."=4") AS "tue_sales", SUM("t3"."sales_price") FILTER (WHERE "t4"."=5") AS "wed_sales", SUM("t3"."sales_price") FILTER (WHERE "t4"."=6") AS "thu_sales", SUM("t3"."sales_price") FILTER (WHERE "t4"."=7") AS "fri_sales", SUM("t3"."sales_price") FILTER (WHERE "t4"."=8") AS "sat_sales"
FROM (SELECT *
FROM (SELECT "ws_sold_date_sk" AS "sold_date_sk", "ws_ext_sales_price" AS "sales_price"
FROM web_sales
UNION ALL
SELECT "cs_sold_date_sk" AS "sold_date_sk", "cs_ext_sales_price" AS "sales_price"
FROM catalog_sales) AS "t1") AS "t3"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM date_dim) AS "t4" ON "t3"."sold_date_sk" = "t4"."d_date_sk"
GROUP BY "t4"."d_week_seq") AS "t7"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_year" = 2001) AS "t10" ON "t7"."d_week_seq" = "t10"."d_week_seq") AS "t12"
INNER JOIN (SELECT "t21"."sun_sales" AS "sun_sales2", "t21"."mon_sales" AS "mon_sales2", "t21"."tue_sales" AS "tue_sales2", "t21"."wed_sales" AS "wed_sales2", "t21"."thu_sales" AS "thu_sales2", "t21"."fri_sales" AS "fri_sales2", "t21"."sat_sales" AS "sat_sales2", "t21"."d_week_seq" - 53 AS "-"
FROM (SELECT "t18"."d_week_seq", SUM("t17"."sales_price") FILTER (WHERE "t18"."=") AS "sun_sales", SUM("t17"."sales_price") FILTER (WHERE "t18"."=3") AS "mon_sales", SUM("t17"."sales_price") FILTER (WHERE "t18"."=4") AS "tue_sales", SUM("t17"."sales_price") FILTER (WHERE "t18"."=5") AS "wed_sales", SUM("t17"."sales_price") FILTER (WHERE "t18"."=6") AS "thu_sales", SUM("t17"."sales_price") FILTER (WHERE "t18"."=7") AS "fri_sales", SUM("t17"."sales_price") FILTER (WHERE "t18"."=8") AS "sat_sales"
FROM (SELECT *
FROM (SELECT "ws_sold_date_sk" AS "sold_date_sk", "ws_ext_sales_price" AS "sales_price"
FROM web_sales
UNION ALL
SELECT "cs_sold_date_sk" AS "sold_date_sk", "cs_ext_sales_price" AS "sales_price"
FROM catalog_sales) AS "t15") AS "t17"
INNER JOIN (SELECT "d_date_sk", "d_week_seq", "d_day_name" = 'Sunday' AS "=", "d_day_name" = 'Monday' AS "=3", "d_day_name" = 'Tuesday' AS "=4", "d_day_name" = 'Wednesday' AS "=5", "d_day_name" = 'Thursday' AS "=6", "d_day_name" = 'Friday' AS "=7", "d_day_name" = 'Saturday' AS "=8"
FROM date_dim) AS "t18" ON "t17"."sold_date_sk" = "t18"."d_date_sk"
GROUP BY "t18"."d_week_seq") AS "t21"
INNER JOIN (SELECT "d_week_seq"
FROM date_dim
WHERE "d_year" = 2001 + 1) AS "t24" ON "t21"."d_week_seq" = "t24"."d_week_seq") AS "t26" ON "t12"."d_week_seq1" = "t26"."-"
ORDER BY "t12"."d_week_seq1"
;
