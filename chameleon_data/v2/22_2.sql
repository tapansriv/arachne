CREATE TABLE duck_table_22_0 AS SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11
;
SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "t1"."i_product_name", "t1"."i_brand", "t1"."i_class", "t1"."i_category", AVG("t1"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t"."inv_warehouse_sk", "t"."inv_quantity_on_hand", "t0"."i_brand", "t0"."i_class", "t0"."i_category", "t0"."i_product_name"
FROM (SELECT "inventory"."inv_item_sk", "inventory"."inv_warehouse_sk", "inventory"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS inventory
INNER JOIN "duck_table_22_0" ON "inventory"."inv_date_sk" = "duck_table_22_0"."d_date_sk") AS "t"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t0" ON "t"."inv_item_sk" = "t0"."i_item_sk") AS "t1"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t2" ON "t1"."inv_warehouse_sk" = "t2"."w_warehouse_sk"
GROUP BY "t1"."i_product_name", "t1"."i_brand", "t1"."i_class", "t1"."i_category"
UNION ALL
SELECT "t7"."i_product_name", "t7"."i_brand", "t7"."i_class", NULL AS "i_category", AVG("t7"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t5"."inv_warehouse_sk", "t5"."inv_quantity_on_hand", "t6"."i_brand", "t6"."i_class", "t6"."i_product_name"
FROM (SELECT "inventory0"."inv_item_sk", "inventory0"."inv_warehouse_sk", "inventory0"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory0"
INNER JOIN "duck_table_22_0" AS "duck_table_22_00" ON "inventory0"."inv_date_sk" = "duck_table_22_00"."d_date_sk") AS "t5"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t6" ON "t5"."inv_item_sk" = "t6"."i_item_sk") AS "t7"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t8" ON "t7"."inv_warehouse_sk" = "t8"."w_warehouse_sk"
GROUP BY "t7"."i_product_name", "t7"."i_brand", "t7"."i_class") AS "t"
UNION ALL
SELECT "t15"."i_product_name", "t15"."i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t15"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t13"."inv_warehouse_sk", "t13"."inv_quantity_on_hand", "t14"."i_brand", "t14"."i_product_name"
FROM (SELECT "inventory1"."inv_item_sk", "inventory1"."inv_warehouse_sk", "inventory1"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory1"
INNER JOIN "duck_table_22_0" AS "duck_table_22_01" ON "inventory1"."inv_date_sk" = "duck_table_22_01"."d_date_sk") AS "t13"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t14" ON "t13"."inv_item_sk" = "t14"."i_item_sk") AS "t15"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t16" ON "t15"."inv_warehouse_sk" = "t16"."w_warehouse_sk"
GROUP BY "t15"."i_product_name", "t15"."i_brand") AS "t"
UNION ALL
SELECT "t23"."i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t23"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t21"."inv_warehouse_sk", "t21"."inv_quantity_on_hand", "t22"."i_product_name"
FROM (SELECT "inventory2"."inv_item_sk", "inventory2"."inv_warehouse_sk", "inventory2"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory2"
INNER JOIN "duck_table_22_0" AS "duck_table_22_02" ON "inventory2"."inv_date_sk" = "duck_table_22_02"."d_date_sk") AS "t21"
INNER JOIN (SELECT "i_item_sk", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t22" ON "t21"."inv_item_sk" = "t22"."i_item_sk") AS "t23"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t24" ON "t23"."inv_warehouse_sk" = "t24"."w_warehouse_sk"
GROUP BY "t23"."i_product_name") AS "t"
UNION ALL
SELECT NULL AS "i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t31"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t29"."inv_warehouse_sk", "t29"."inv_quantity_on_hand"
FROM (SELECT "inventory3"."inv_item_sk", "inventory3"."inv_warehouse_sk", "inventory3"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory3"
INNER JOIN "duck_table_22_0" AS "duck_table_22_03" ON "inventory3"."inv_date_sk" = "duck_table_22_03"."d_date_sk") AS "t29"
INNER JOIN (SELECT "i_item_sk"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t30" ON "t29"."inv_item_sk" = "t30"."i_item_sk") AS "t31"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t32" ON "t31"."inv_warehouse_sk" = "t32"."w_warehouse_sk") AS "t36"
ORDER BY "qoh" NULLS FIRST, "i_product_name" NULLS FIRST, "i_brand" NULLS FIRST, "i_class" NULLS FIRST, "i_category" NULLS FIRST
FETCH NEXT 100 ROWS ONLY
;
