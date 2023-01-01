CREATE TABLE rs_table_97_0 AS SELECT "t"."cs_bill_customer_sk" AS "customer_sk", "t"."cs_item_sk" AS "item_sk"
FROM (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_item_sk"
FROM catalog_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."cs_sold_date_sk" = "t2"."d_date_sk"
GROUP BY "t"."cs_bill_customer_sk", "t"."cs_item_sk"
;
SELECT CAST(COUNT(CASE WHEN "t4"."customer_sk" IS NOT NULL AND "rs_table_97_0"."customer_sk" IS NULL THEN 1 ELSE NULL END) AS INTEGER) AS "store_only", CAST(COUNT(CASE WHEN "t4"."customer_sk" IS NULL AND "rs_table_97_0"."customer_sk" IS NOT NULL THEN 1 ELSE NULL END) AS INTEGER) AS "catalog_only", CAST(COUNT(CASE WHEN "t4"."customer_sk" IS NOT NULL AND "rs_table_97_0"."customer_sk" IS NOT NULL THEN 1 ELSE NULL END) AS INTEGER) AS "store_and_catalog"
FROM (SELECT "t"."ss_customer_sk" AS "customer_sk", "t"."ss_item_sk" AS "item_sk"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_customer_sk"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk"
GROUP BY "t"."ss_customer_sk", "t"."ss_item_sk") AS "t4"
FULL JOIN "rs_table_97_0" ON "t4"."customer_sk" = "rs_table_97_0"."customer_sk" AND "t4"."item_sk" = "rs_table_97_0"."item_sk"
LIMIT 100
;
