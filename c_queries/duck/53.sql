SELECT *
FROM (SELECT "t10"."i_manufact_id", "t10"."sum_sales", (SUM("t10"."sum_sales") OVER (PARTITION BY "t10"."i_manufact_id" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) / (COUNT("t10"."sum_sales") OVER (PARTITION BY "t10"."i_manufact_id" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) AS "avg_quarterly_sales"
FROM (SELECT "t7"."i_manufact_id", "t7"."d_qoy", SUM("t7"."ss_sales_price") AS "sum_sales"
FROM (SELECT "t3"."i_manufact_id", "t3"."ss_store_sk", "t3"."ss_sales_price", "t6"."d_qoy"
FROM (SELECT "t1"."i_manufact_id", "t2"."ss_sold_date_sk", "t2"."ss_store_sk", "t2"."ss_sales_price"
FROM (SELECT "i_item_sk", "i_manufact_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_category" IN ('Books', 'Children', 'Electronics') AND "i_class" IN ('personal', 'portable', 'reference', 'self-help') AND "i_brand" IN ('exportiunivamalg #9', 'scholaramalgamalg #14', 'scholaramalgamalg #7', 'scholaramalgamalg #9') OR "i_category" IN ('Men', 'Music', 'Women') AND "i_class" IN ('accessories', 'classical', 'fragrances', 'pants') AND "i_brand" IN ('amalgimporto #1', 'edu packscholar #1', 'exportiimporto #1', 'importoamalg #1')) AS "t1"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_sales_price"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t2" ON "t1"."i_item_sk" = "t2"."ss_item_sk") AS "t3"
INNER JOIN (SELECT "d_date_sk", "d_qoy"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" = 1200 OR ("d_month_seq" = 1200 + 1 OR "d_month_seq" = 1200 + 2) OR ("d_month_seq" = 1200 + 3 OR ("d_month_seq" = 1200 + 4 OR "d_month_seq" = 1200 + 5)) OR ("d_month_seq" = 1200 + 6 OR ("d_month_seq" = 1200 + 7 OR "d_month_seq" = 1200 + 8) OR ("d_month_seq" = 1200 + 9 OR ("d_month_seq" = 1200 + 10 OR "d_month_seq" = 1200 + 11)))) AS "t6" ON "t3"."ss_sold_date_sk" = "t6"."d_date_sk") AS "t7"
INNER JOIN (SELECT "s_store_sk"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store) AS "t8" ON "t7"."ss_store_sk" = "t8"."s_store_sk"
GROUP BY "t7"."i_manufact_id", "t7"."d_qoy") AS "t10") AS "t11"
WHERE CASE WHEN "avg_quarterly_sales" > 0 THEN CAST(ABS("sum_sales" - "avg_quarterly_sales") / "avg_quarterly_sales" AS DECIMAL(19, 0)) ELSE NULL END > 0.1
ORDER BY "avg_quarterly_sales", "sum_sales", "i_manufact_id"
FETCH NEXT 100 ROWS ONLY

