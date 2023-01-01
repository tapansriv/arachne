SELECT "t20"."i_category", "t20"."i_brand", "t20"."s_store_name", "t20"."s_company_name", "t20"."d_year", "t20"."d_moy", "t20"."avg_monthly_sales", "t20"."sum_sales", "t20"."sum_sales0" AS "psum", "t31"."sum_sales" AS "nsum", "t20"."sum_sales" - "t20"."avg_monthly_sales"
FROM (SELECT "t8"."i_category", "t8"."i_brand", "t8"."s_store_name", "t8"."s_company_name", "t8"."d_year", "t8"."d_moy", "t8"."sum_sales", "t8"."avg_monthly_sales", "t8"."rn", "t19"."sum_sales" AS "sum_sales0"
FROM (SELECT "t7"."i_category", "t7"."i_brand", "t7"."s_store_name", "t7"."s_company_name", "t7"."d_year", "t7"."d_moy", "t7"."sum_sales", (SUM("t7"."sum_sales") OVER (PARTITION BY "t7"."i_category", "t7"."i_brand", "t7"."s_store_name", "t7"."s_company_name", "t7"."d_year" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) / (COUNT("t7"."sum_sales") OVER (PARTITION BY "t7"."i_category", "t7"."i_brand", "t7"."s_store_name", "t7"."s_company_name", "t7"."d_year" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) AS "avg_monthly_sales", RANK() OVER (PARTITION BY "t7"."i_category", "t7"."i_brand", "t7"."s_store_name", "t7"."s_company_name" ORDER BY "t7"."d_year", "t7"."d_moy") AS "rn"
FROM (SELECT "t4"."i_category", "t4"."i_brand", "t5"."s_store_name", "t5"."s_company_name", "t4"."d_year", "t4"."d_moy", SUM("t4"."ss_sales_price") AS "sum_sales"
FROM (SELECT "t1"."i_brand", "t1"."i_category", "t1"."ss_store_sk", "t1"."ss_sales_price", "t3"."d_year", "t3"."d_moy"
FROM (SELECT "t"."i_brand", "t"."i_category", "t0"."ss_sold_date_sk", "t0"."ss_store_sk", "t0"."ss_sales_price"
FROM (SELECT "i_item_sk", "i_brand", "i_category"
FROM item) AS "t"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t0" ON "t"."i_item_sk" = "t0"."ss_item_sk") AS "t1"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy"
FROM date_dim
WHERE "d_year" = 1999 OR "d_year" = 1999 - 1 AND "d_moy" = 12 OR "d_year" = 1999 + 1 AND "d_moy" = 1) AS "t3" ON "t1"."ss_sold_date_sk" = "t3"."d_date_sk") AS "t4"
INNER JOIN (SELECT "s_store_sk", "s_store_name", "s_company_name"
FROM store) AS "t5" ON "t4"."ss_store_sk" = "t5"."s_store_sk"
GROUP BY "t4"."i_category", "t4"."i_brand", "t5"."s_store_name", "t5"."s_company_name", "t4"."d_year", "t4"."d_moy") AS "t7") AS "t8"
INNER JOIN (SELECT "t17"."i_category", "t17"."i_brand", "t17"."s_store_name", "t17"."s_company_name", "t17"."sum_sales", (RANK() OVER (PARTITION BY "t17"."i_category", "t17"."i_brand", "t17"."s_store_name", "t17"."s_company_name" ORDER BY "t17"."d_year", "t17"."d_moy")) + 1 AS "+"
FROM (SELECT "t14"."i_category", "t14"."i_brand", "t15"."s_store_name", "t15"."s_company_name", "t14"."d_year", "t14"."d_moy", SUM("t14"."ss_sales_price") AS "sum_sales"
FROM (SELECT "t11"."i_brand", "t11"."i_category", "t11"."ss_store_sk", "t11"."ss_sales_price", "t13"."d_year", "t13"."d_moy"
FROM (SELECT "t9"."i_brand", "t9"."i_category", "t10"."ss_sold_date_sk", "t10"."ss_store_sk", "t10"."ss_sales_price"
FROM (SELECT "i_item_sk", "i_brand", "i_category"
FROM item) AS "t9"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t10" ON "t9"."i_item_sk" = "t10"."ss_item_sk") AS "t11"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy"
FROM date_dim
WHERE "d_year" = 1999 OR "d_year" = 1999 - 1 AND "d_moy" = 12 OR "d_year" = 1999 + 1 AND "d_moy" = 1) AS "t13" ON "t11"."ss_sold_date_sk" = "t13"."d_date_sk") AS "t14"
INNER JOIN (SELECT "s_store_sk", "s_store_name", "s_company_name"
FROM store) AS "t15" ON "t14"."ss_store_sk" = "t15"."s_store_sk"
GROUP BY "t14"."i_category", "t14"."i_brand", "t15"."s_store_name", "t15"."s_company_name", "t14"."d_year", "t14"."d_moy") AS "t17") AS "t19" ON "t8"."i_category" = "t19"."i_category" AND "t8"."i_brand" = "t19"."i_brand" AND "t8"."s_store_name" = "t19"."s_store_name" AND "t8"."s_company_name" = "t19"."s_company_name" AND "t8"."rn" = "t19"."+") AS "t20"
INNER JOIN (SELECT "t29"."i_category", "t29"."i_brand", "t29"."s_store_name", "t29"."s_company_name", "t29"."sum_sales", (RANK() OVER (PARTITION BY "t29"."i_category", "t29"."i_brand", "t29"."s_store_name", "t29"."s_company_name" ORDER BY "t29"."d_year", "t29"."d_moy")) - 1 AS "-"
FROM (SELECT "t26"."i_category", "t26"."i_brand", "t27"."s_store_name", "t27"."s_company_name", "t26"."d_year", "t26"."d_moy", SUM("t26"."ss_sales_price") AS "sum_sales"
FROM (SELECT "t23"."i_brand", "t23"."i_category", "t23"."ss_store_sk", "t23"."ss_sales_price", "t25"."d_year", "t25"."d_moy"
FROM (SELECT "t21"."i_brand", "t21"."i_category", "t22"."ss_sold_date_sk", "t22"."ss_store_sk", "t22"."ss_sales_price"
FROM (SELECT "i_item_sk", "i_brand", "i_category"
FROM item) AS "t21"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price"
FROM store_sales) AS "t22" ON "t21"."i_item_sk" = "t22"."ss_item_sk") AS "t23"
INNER JOIN (SELECT "d_date_sk", "d_year", "d_moy"
FROM date_dim
WHERE "d_year" = 1999 OR "d_year" = 1999 - 1 AND "d_moy" = 12 OR "d_year" = 1999 + 1 AND "d_moy" = 1) AS "t25" ON "t23"."ss_sold_date_sk" = "t25"."d_date_sk") AS "t26"
INNER JOIN (SELECT "s_store_sk", "s_store_name", "s_company_name"
FROM store) AS "t27" ON "t26"."ss_store_sk" = "t27"."s_store_sk"
GROUP BY "t26"."i_category", "t26"."i_brand", "t27"."s_store_name", "t27"."s_company_name", "t26"."d_year", "t26"."d_moy") AS "t29") AS "t31" ON "t20"."i_category" = "t31"."i_category" AND "t20"."i_brand" = "t31"."i_brand" AND "t20"."s_store_name" = "t31"."s_store_name" AND "t20"."s_company_name" = "t31"."s_company_name" AND "t20"."rn" = "t31"."-"
WHERE "t20"."d_year" = 1999 AND "t20"."avg_monthly_sales" > 0 AND CASE WHEN "t20"."avg_monthly_sales" > 0 THEN CAST(ABS("t20"."sum_sales" - "t20"."avg_monthly_sales") / "t20"."avg_monthly_sales" AS DECIMAL(19, 0)) ELSE NULL END > 0.1
ORDER BY "t20"."sum_sales" - "t20"."avg_monthly_sales", "t20"."i_category", "t20"."i_brand", "t20"."s_store_name", "t20"."s_company_name", "t20"."d_year", "t20"."d_moy", "t20"."avg_monthly_sales", "t20"."sum_sales", "t20"."sum_sales0", "t31"."sum_sales"
LIMIT 100

