CREATE TABLE duck_table_22_0 AS SELECT "inventory"."inv_item_sk", "inventory"."inv_warehouse_sk", "inventory"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS inventory
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t1" ON "inventory"."inv_date_sk" = "t1"."d_date_sk"
;
SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "t4"."i_product_name", "t4"."i_brand", "t4"."i_class", "t4"."i_category", AVG("t4"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t2"."inv_warehouse_sk", "t2"."inv_quantity_on_hand", "t3"."i_brand", "t3"."i_class", "t3"."i_category", "t3"."i_product_name"
FROM (SELECT "inventory"."inv_item_sk", "inventory"."inv_warehouse_sk", "inventory"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS inventory
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t1" ON "inventory"."inv_date_sk" = "t1"."d_date_sk") AS "t2"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t3" ON "t2"."inv_item_sk" = "t3"."i_item_sk") AS "t4"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t5" ON "t4"."inv_warehouse_sk" = "t5"."w_warehouse_sk"
GROUP BY "t4"."i_product_name", "t4"."i_brand", "t4"."i_class", "t4"."i_category"
UNION ALL
SELECT "t13"."i_product_name", "t13"."i_brand", "t13"."i_class", NULL AS "i_category", AVG("t13"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t11"."inv_warehouse_sk", "t11"."inv_quantity_on_hand", "t12"."i_brand", "t12"."i_class", "t12"."i_product_name"
FROM (SELECT "inventory0"."inv_item_sk", "inventory0"."inv_warehouse_sk", "inventory0"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory0"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t10" ON "inventory0"."inv_date_sk" = "t10"."d_date_sk") AS "t11"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t12" ON "t11"."inv_item_sk" = "t12"."i_item_sk") AS "t13"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t14" ON "t13"."inv_warehouse_sk" = "t14"."w_warehouse_sk"
GROUP BY "t13"."i_product_name", "t13"."i_brand", "t13"."i_class") AS "t"
UNION ALL
SELECT "t20"."i_product_name", "t20"."i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t20"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "duck_table_22_0"."inv_warehouse_sk", "duck_table_22_0"."inv_quantity_on_hand", "t19"."i_brand", "t19"."i_product_name"
FROM "duck_table_22_0"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t19" ON "duck_table_22_0"."inv_item_sk" = "t19"."i_item_sk") AS "t20"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t21" ON "t20"."inv_warehouse_sk" = "t21"."w_warehouse_sk"
GROUP BY "t20"."i_product_name", "t20"."i_brand") AS "t"
UNION ALL
SELECT "t31"."i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t31"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t29"."inv_warehouse_sk", "t29"."inv_quantity_on_hand", "t30"."i_product_name"
FROM (SELECT "inventory1"."inv_item_sk", "inventory1"."inv_warehouse_sk", "inventory1"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory1"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t28" ON "inventory1"."inv_date_sk" = "t28"."d_date_sk") AS "t29"
INNER JOIN (SELECT "i_item_sk", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t30" ON "t29"."inv_item_sk" = "t30"."i_item_sk") AS "t31"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t32" ON "t31"."inv_warehouse_sk" = "t32"."w_warehouse_sk"
GROUP BY "t31"."i_product_name") AS "t"
UNION ALL
SELECT NULL AS "i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t42"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t40"."inv_warehouse_sk", "t40"."inv_quantity_on_hand"
FROM (SELECT "inventory2"."inv_item_sk", "inventory2"."inv_warehouse_sk", "inventory2"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory2"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t39" ON "inventory2"."inv_date_sk" = "t39"."d_date_sk") AS "t40"
INNER JOIN (SELECT "i_item_sk"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t41" ON "t40"."inv_item_sk" = "t41"."i_item_sk") AS "t42"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t43" ON "t42"."inv_warehouse_sk" = "t43"."w_warehouse_sk") AS "t47"
ORDER BY "qoh" NULLS FIRST, "i_product_name" NULLS FIRST, "i_brand" NULLS FIRST, "i_class" NULLS FIRST, "i_category" NULLS FIRST
FETCH NEXT 100 ROWS ONLY
;
