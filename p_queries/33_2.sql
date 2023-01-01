CREATE TABLE duck_table_33_0 AS SELECT "t13"."i_manufact_id", "t7"."ws_ext_sales_price"
FROM (SELECT "t3"."ws_item_sk", "t3"."ws_ext_sales_price"
FROM (SELECT "t"."ws_item_sk", "t"."ws_bill_addr_sk", "t"."ws_ext_sales_price"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_bill_addr_sk", "ws_ext_sales_price"
FROM '/mnt/disks/tpcds/parquet/web_sales.parquet' AS web_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 1998 AND "d_moy" = 5) AS "t2" ON "t"."ws_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "ca_address_sk"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address
WHERE "ca_gmt_offset" = -5) AS "t6" ON "t3"."ws_bill_addr_sk" = "t6"."ca_address_sk") AS "t7"
INNER JOIN (SELECT "item"."i_item_sk", "item"."i_manufact_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
INNER JOIN (SELECT "i_manufact_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_category" = 'Electronics'
GROUP BY "i_manufact_id") AS "t11" ON "item"."i_manufact_id" = "t11"."i_manufact_id") AS "t13" ON "t7"."ws_item_sk" = "t13"."i_item_sk";
SELECT "i_manufact_id", SUM("total_sales") AS "total_sales"
FROM (SELECT *
FROM (SELECT "t13"."i_manufact_id", SUM("t7"."ss_ext_sales_price") AS "total_sales"
FROM (SELECT "t3"."ss_item_sk", "t3"."ss_ext_sales_price"
FROM (SELECT "t"."ss_item_sk", "t"."ss_addr_sk", "t"."ss_ext_sales_price"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_addr_sk", "ss_ext_sales_price"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 1998 AND "d_moy" = 5) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "ca_address_sk"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address
WHERE "ca_gmt_offset" = -5) AS "t6" ON "t3"."ss_addr_sk" = "t6"."ca_address_sk") AS "t7"
INNER JOIN (SELECT "item"."i_item_sk", "item"."i_manufact_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
INNER JOIN (SELECT "i_manufact_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_category" = 'Electronics'
GROUP BY "i_manufact_id") AS "t11" ON "item"."i_manufact_id" = "t11"."i_manufact_id") AS "t13" ON "t7"."ss_item_sk" = "t13"."i_item_sk"
GROUP BY "t13"."i_manufact_id"
UNION ALL
SELECT "t31"."i_manufact_id", SUM("t25"."cs_ext_sales_price") AS "total_sales"
FROM (SELECT "t21"."cs_item_sk", "t21"."cs_ext_sales_price"
FROM (SELECT "t17"."cs_bill_addr_sk", "t17"."cs_item_sk", "t17"."cs_ext_sales_price"
FROM (SELECT "cs_sold_date_sk", "cs_bill_addr_sk", "cs_item_sk", "cs_ext_sales_price"
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales) AS "t17"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 1998 AND "d_moy" = 5) AS "t20" ON "t17"."cs_sold_date_sk" = "t20"."d_date_sk") AS "t21"
INNER JOIN (SELECT "ca_address_sk"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address
WHERE "ca_gmt_offset" = -5) AS "t24" ON "t21"."cs_bill_addr_sk" = "t24"."ca_address_sk") AS "t25"
INNER JOIN (SELECT "item1"."i_item_sk", "item1"."i_manufact_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS "item1"
INNER JOIN (SELECT "i_manufact_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_category" = 'Electronics'
GROUP BY "i_manufact_id") AS "t29" ON "item1"."i_manufact_id" = "t29"."i_manufact_id") AS "t31" ON "t25"."cs_item_sk" = "t31"."i_item_sk"
GROUP BY "t31"."i_manufact_id") AS "t"
UNION ALL
SELECT "i_manufact_id", SUM("ws_ext_sales_price") AS "total_sales"
FROM "duck_table_33_0"
GROUP BY "i_manufact_id") AS "t38"
GROUP BY "i_manufact_id"
ORDER BY SUM("total_sales")
FETCH NEXT 100 ROWS ONLY;
