CREATE TABLE duck_table_37_0 AS SELECT "t9"."i_item_id", "t9"."i_item_desc", "t9"."i_current_price"
FROM (SELECT "t5"."i_item_sk", "t5"."i_item_id", "t5"."i_item_desc", "t5"."i_current_price"
FROM (SELECT "t1"."i_item_sk", "t1"."i_item_id", "t1"."i_item_desc", "t1"."i_current_price", "t4"."inv_date_sk"
FROM (SELECT "i_item_sk", "i_item_id", "i_item_desc", "i_current_price"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_current_price" >= 68 AND "i_current_price" <= 68 + 30 AND "i_manufact_id" IN (677, 694, 808, 940)) AS "t1"
INNER JOIN (SELECT "inv_date_sk", "inv_item_sk"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS inventory
WHERE "inv_quantity_on_hand" >= 100 AND "inv_quantity_on_hand" <= 500) AS "t4" ON "t1"."i_item_sk" = "t4"."inv_item_sk") AS "t5"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_date" >= DATE '2000-02-01' AND "d_date" <= DATE '2000-04-01') AS "t8" ON "t5"."inv_date_sk" = "t8"."d_date_sk") AS "t9"
INNER JOIN (SELECT "cs_item_sk"
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales) AS "t10" ON "t9"."i_item_sk" = "t10"."cs_item_sk"
