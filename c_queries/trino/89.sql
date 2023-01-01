SELECT "i_category", "i_class", "i_brand", "s_store_name", "s_company_name", "d_moy", "sum_sales", "avg_monthly_sales", "sum_sales" - "avg_monthly_sales"
FROM (SELECT "t9"."i_category", "t9"."i_class", "t9"."i_brand", "t9"."s_store_name", "t9"."s_company_name", "t9"."d_moy", "t9"."sum_sales", (SUM("t9"."sum_sales") OVER (PARTITION BY "t9"."i_category", "t9"."i_brand", "t9"."s_store_name", "t9"."s_company_name" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) / (COUNT("t9"."sum_sales") OVER (PARTITION BY "t9"."i_category", "t9"."i_brand", "t9"."s_store_name", "t9"."s_company_name" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) AS "avg_monthly_sales"
FROM (SELECT "t6"."i_category", "t6"."i_class", "t6"."i_brand", "t7"."s_store_name", "t7"."s_company_name", "t6"."d_moy", SUM("t6"."ss_sales_price") AS "sum_sales"
FROM (SELECT "t2"."i_brand", "t2"."i_class", "t2"."i_category", "t2"."ss_store_sk", "t2"."ss_sales_price", "t5"."d_moy"
FROM (SELECT "t0"."i_brand", "t0"."i_class", "t0"."i_category", "t1"."ss_sold_date_sk", "t1"."ss_store_sk", "t1"."ss_sales_price"
FROM (SELECT "i_item_sk", "i_brand", "i_class", "i_category"
FROM tpcds.sf1000.item AS item
WHERE "i_category" IN ('Books', 'Electronics', 'Sports') AND "i_class" IN ('computers', 'football', 'stereo') OR "i_category" IN ('Jewelry', 'Men', 'Women') AND "i_class" IN ('birdal', 'dresses', 'shirts')) AS "t0"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t1" ON "t0"."i_item_sk" = "t1"."ss_item_sk") AS "t2"
INNER JOIN (SELECT "d_date_sk", "d_moy"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 1999) AS "t5" ON "t2"."ss_sold_date_sk" = "t5"."d_date_sk") AS "t6"
INNER JOIN (SELECT "s_store_sk", "s_store_name", "s_company_name"
FROM tpcds.sf1000.store AS store) AS "t7" ON "t6"."ss_store_sk" = "t7"."s_store_sk"
GROUP BY "t6"."i_category", "t6"."i_class", "t6"."i_brand", "t7"."s_store_name", "t7"."s_company_name", "t6"."d_moy") AS "t9") AS "t10"
WHERE CASE WHEN "avg_monthly_sales" <> 0 THEN CAST(ABS("sum_sales" - "avg_monthly_sales") / "avg_monthly_sales" AS DECIMAL(19, 0)) ELSE NULL END > 0.1
ORDER BY "sum_sales" - "avg_monthly_sales" IS NULL, "sum_sales" - "avg_monthly_sales", "s_store_name" IS NULL, "s_store_name", "i_category" IS NULL, "i_category", "i_class" IS NULL, "i_class", "i_brand" IS NULL, "i_brand", "s_company_name" IS NULL, "s_company_name", "d_moy" IS NULL, "d_moy", "sum_sales" IS NULL, "sum_sales", "avg_monthly_sales" IS NULL, "avg_monthly_sales"
LIMIT 100

