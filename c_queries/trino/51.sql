SELECT *
FROM (SELECT CASE WHEN "t5"."item_sk" IS NOT NULL THEN "t5"."item_sk" ELSE "t12"."item_sk" END AS "item_sk", CASE WHEN "t5"."d_date" IS NOT NULL THEN "t5"."d_date" ELSE "t12"."d_date" END AS "d_date", "t5"."cume_sales" AS "web_sales", "t12"."cume_sales" AS "store_sales", MAX("t5"."cume_sales") OVER (PARTITION BY CASE WHEN "t5"."item_sk" IS NOT NULL THEN "t5"."item_sk" ELSE "t12"."item_sk" END ORDER BY CASE WHEN "t5"."d_date" IS NOT NULL THEN "t5"."d_date" ELSE "t12"."d_date" END IS NULL, CASE WHEN "t5"."d_date" IS NOT NULL THEN "t5"."d_date" ELSE "t12"."d_date" END ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "web_cumulative", MAX("t12"."cume_sales") OVER (PARTITION BY CASE WHEN "t5"."item_sk" IS NOT NULL THEN "t5"."item_sk" ELSE "t12"."item_sk" END ORDER BY CASE WHEN "t5"."d_date" IS NOT NULL THEN "t5"."d_date" ELSE "t12"."d_date" END IS NULL, CASE WHEN "t5"."d_date" IS NOT NULL THEN "t5"."d_date" ELSE "t12"."d_date" END ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "store_cumulative"
FROM (SELECT "t4"."item_sk", "t4"."d_date", SUM("t4"."$f2") OVER (PARTITION BY "t4"."item_sk" ORDER BY "t4"."d_date" IS NULL, "t4"."d_date" ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "cume_sales"
FROM (SELECT "t"."ws_item_sk" AS "item_sk", "t2"."d_date", SUM("t"."ws_sales_price") AS "$f2"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_sales_price"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk", "d_date"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ws_sold_date_sk" = "t2"."d_date_sk"
GROUP BY "t"."ws_item_sk", "t2"."d_date") AS "t4") AS "t5"
FULL JOIN (SELECT "t11"."item_sk", "t11"."d_date", SUM("t11"."$f2") OVER (PARTITION BY "t11"."item_sk" ORDER BY "t11"."d_date" IS NULL, "t11"."d_date" ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS "cume_sales"
FROM (SELECT "t6"."ss_item_sk" AS "item_sk", "t9"."d_date", SUM("t6"."ss_sales_price") AS "$f2"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_sales_price"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t6"
INNER JOIN (SELECT "d_date_sk", "d_date"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t9" ON "t6"."ss_sold_date_sk" = "t9"."d_date_sk"
GROUP BY "t6"."ss_item_sk", "t9"."d_date") AS "t11") AS "t12" ON "t5"."item_sk" = "t12"."item_sk" AND "t5"."d_date" = "t12"."d_date") AS "t13"
WHERE "t13"."web_cumulative" > "t13"."store_cumulative"
ORDER BY "item_sk", "d_date"
LIMIT 100

