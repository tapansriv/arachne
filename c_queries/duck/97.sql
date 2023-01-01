SELECT CAST(COUNT(*) FILTER (WHERE "t4"."customer_sk" IS NOT NULL AND "t10"."customer_sk" IS NULL) AS INTEGER) AS "store_only", CAST(COUNT(*) FILTER (WHERE "t4"."customer_sk" IS NULL AND "t10"."customer_sk" IS NOT NULL) AS INTEGER) AS "catalog_only", CAST(COUNT(*) FILTER (WHERE "t4"."customer_sk" IS NOT NULL AND "t10"."customer_sk" IS NOT NULL) AS INTEGER) AS "store_and_catalog"
FROM (SELECT "t"."ss_customer_sk" AS "customer_sk", "t"."ss_item_sk" AS "item_sk"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_customer_sk"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk"
GROUP BY "t"."ss_customer_sk", "t"."ss_item_sk") AS "t4"
FULL JOIN (SELECT "t5"."cs_bill_customer_sk" AS "customer_sk", "t5"."cs_item_sk" AS "item_sk"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_item_sk"
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales) AS "t5"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t8" ON "t5"."cs_sold_date_sk" = "t8"."d_date_sk"
GROUP BY "t5"."cs_bill_customer_sk", "t5"."cs_item_sk") AS "t10" ON "t4"."customer_sk" = "t10"."customer_sk" AND "t4"."item_sk" = "t10"."item_sk"
FETCH NEXT 100 ROWS ONLY

