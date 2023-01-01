SELECT CASE WHEN "t8"."=" THEN NULL ELSE "t3"."CAST" / "t8"."CAST" END AS "am_pm_ratio"
FROM (SELECT CAST(COUNT(*) AS DECIMAL(15, 4)) AS "CAST"
FROM web_sales
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 6) AS "t" ON "web_sales"."ws_ship_hdemo_sk" = "t"."hd_demo_sk"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" >= 8 AND "t_hour" <= 8 + 1) AS "t0" ON "web_sales"."ws_sold_time_sk" = "t0"."t_time_sk"
INNER JOIN (SELECT *
FROM web_page
WHERE "wp_char_count" >= 5000 AND "wp_char_count" <= 5200) AS "t1" ON "web_sales"."ws_web_page_sk" = "t1"."wp_web_page_sk") AS "t3",
(SELECT COUNT(*) = 0 AS "=", CAST(COUNT(*) AS DECIMAL(15, 4)) AS "CAST"
FROM web_sales AS "web_sales0"
INNER JOIN (SELECT *
FROM household_demographics
WHERE "hd_dep_count" = 6) AS "t4" ON "web_sales0"."ws_ship_hdemo_sk" = "t4"."hd_demo_sk"
INNER JOIN (SELECT *
FROM time_dim
WHERE "t_hour" >= 19 AND "t_hour" <= 19 + 1) AS "t5" ON "web_sales0"."ws_sold_time_sk" = "t5"."t_time_sk"
INNER JOIN (SELECT *
FROM web_page
WHERE "wp_char_count" >= 5000 AND "wp_char_count" <= 5200) AS "t6" ON "web_sales0"."ws_web_page_sk" = "t6"."wp_web_page_sk") AS "t8"
ORDER BY CASE WHEN "t8"."=" THEN NULL ELSE "t3"."CAST" / "t8"."CAST" END
FETCH NEXT 100 ROWS ONLY

