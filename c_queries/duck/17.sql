SELECT "t18"."i_item_id", "t18"."i_item_desc", "t17"."s_state", COUNT(*) AS "store_sales_quantitycount", AVG("t17"."ss_quantity") AS "store_sales_quantityave", STDDEV_SAMP("t17"."ss_quantity") AS "store_sales_quantitystdev", STDDEV_SAMP("t17"."ss_quantity") / AVG("t17"."ss_quantity") AS "store_sales_quantitycov", COUNT(*) AS "store_returns_quantitycount", AVG("t17"."sr_return_quantity") AS "store_returns_quantityave", STDDEV_SAMP("t17"."sr_return_quantity") AS "store_returns_quantitystdev", STDDEV_SAMP("t17"."sr_return_quantity") / AVG("t17"."sr_return_quantity") AS "store_returns_quantitycov", COUNT(*) AS "catalog_sales_quantitycount", AVG("t17"."cs_quantity") AS "catalog_sales_quantityave", STDDEV_SAMP("t17"."cs_quantity") AS "catalog_sales_quantitystdev", STDDEV_SAMP("t17"."cs_quantity") / AVG("t17"."cs_quantity") AS "catalog_sales_quantitycov"
FROM (SELECT "t15"."ss_item_sk", "t15"."ss_quantity", "t15"."sr_return_quantity", "t15"."cs_quantity", "t16"."s_state"
FROM (SELECT "t11"."ss_item_sk", "t11"."ss_store_sk", "t11"."ss_quantity", "t11"."sr_return_quantity", "t11"."cs_quantity"
FROM (SELECT "t7"."ss_item_sk", "t7"."ss_store_sk", "t7"."ss_quantity", "t7"."sr_return_quantity", "t7"."cs_sold_date_sk", "t7"."cs_quantity"
FROM (SELECT "t3"."ss_item_sk", "t3"."ss_store_sk", "t3"."ss_quantity", "t3"."sr_returned_date_sk", "t3"."sr_return_quantity", "t3"."cs_sold_date_sk", "t3"."cs_quantity"
FROM (SELECT "t1"."ss_sold_date_sk", "t1"."ss_item_sk", "t1"."ss_store_sk", "t1"."ss_quantity", "t1"."sr_returned_date_sk", "t1"."sr_return_quantity", "t2"."cs_sold_date_sk", "t2"."cs_quantity"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_item_sk", "t"."ss_store_sk", "t"."ss_quantity", "t0"."sr_returned_date_sk", "t0"."sr_item_sk", "t0"."sr_customer_sk", "t0"."sr_return_quantity"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_customer_sk", "ss_store_sk", "ss_ticket_number", "ss_quantity"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "sr_returned_date_sk", "sr_item_sk", "sr_customer_sk", "sr_ticket_number", "sr_return_quantity"
FROM '/mnt/disks/tpcds/parquet/store_returns.parquet' AS store_returns) AS "t0" ON "t"."ss_customer_sk" = "t0"."sr_customer_sk" AND "t"."ss_item_sk" = "t0"."sr_item_sk" AND "t"."ss_ticket_number" = "t0"."sr_ticket_number") AS "t1"
INNER JOIN (SELECT "cs_sold_date_sk", "cs_bill_customer_sk", "cs_item_sk", "cs_quantity"
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales) AS "t2" ON "t1"."sr_customer_sk" = "t2"."cs_bill_customer_sk" AND "t1"."sr_item_sk" = "t2"."cs_item_sk") AS "t3"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_quarter_name" = '2001Q1') AS "t6" ON "t3"."ss_sold_date_sk" = "t6"."d_date_sk") AS "t7"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_quarter_name" IN ('2001Q1', '2001Q2', '2001Q3')) AS "t10" ON "t7"."sr_returned_date_sk" = "t10"."d_date_sk") AS "t11"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_quarter_name" IN ('2001Q1', '2001Q2', '2001Q3')) AS "t14" ON "t11"."cs_sold_date_sk" = "t14"."d_date_sk") AS "t15"
INNER JOIN (SELECT "s_store_sk", "s_state"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store) AS "t16" ON "t15"."ss_store_sk" = "t16"."s_store_sk") AS "t17"
INNER JOIN (SELECT "i_item_sk", "i_item_id", "i_item_desc"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t18" ON "t17"."ss_item_sk" = "t18"."i_item_sk"
GROUP BY "t18"."i_item_id", "t18"."i_item_desc", "t17"."s_state"
ORDER BY "t18"."i_item_id" NULLS FIRST, "t18"."i_item_desc" NULLS FIRST, "t17"."s_state" NULLS FIRST
FETCH NEXT 100 ROWS ONLY

