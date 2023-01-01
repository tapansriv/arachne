CREATE TABLE duck_table_22_0 AS SELECT *
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11
;
SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "t3"."i_product_name", "t3"."i_brand", "t3"."i_class", "t3"."i_category", AVG("t3"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t1"."inv_warehouse_sk", "t1"."inv_quantity_on_hand", "t2"."i_brand", "t2"."i_class", "t2"."i_category", "t2"."i_product_name"
FROM (SELECT "inventory"."inv_item_sk", "inventory"."inv_warehouse_sk", "inventory"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS inventory
INNER JOIN (SELECT "d_date_sk"
FROM "duck_table_22_0") AS "t0" ON "inventory"."inv_date_sk" = "t0"."d_date_sk") AS "t1"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t2" ON "t1"."inv_item_sk" = "t2"."i_item_sk") AS "t3"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t4" ON "t3"."inv_warehouse_sk" = "t4"."w_warehouse_sk"
GROUP BY "t3"."i_product_name", "t3"."i_brand", "t3"."i_class", "t3"."i_category"
UNION ALL
SELECT "t11"."i_product_name", "t11"."i_brand", "t11"."i_class", NULL AS "i_category", AVG("t11"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t9"."inv_warehouse_sk", "t9"."inv_quantity_on_hand", "t10"."i_brand", "t10"."i_class", "t10"."i_product_name"
FROM (SELECT "inventory0"."inv_item_sk", "inventory0"."inv_warehouse_sk", "inventory0"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory0"
INNER JOIN (SELECT "d_date_sk"
FROM "duck_table_22_0") AS "t8" ON "inventory0"."inv_date_sk" = "t8"."d_date_sk") AS "t9"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t10" ON "t9"."inv_item_sk" = "t10"."i_item_sk") AS "t11"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t12" ON "t11"."inv_warehouse_sk" = "t12"."w_warehouse_sk"
GROUP BY "t11"."i_product_name", "t11"."i_brand", "t11"."i_class") AS "t"
UNION ALL
SELECT "t21"."i_product_name", "t21"."i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t21"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t19"."inv_warehouse_sk", "t19"."inv_quantity_on_hand", "t20"."i_brand", "t20"."i_product_name"
FROM (SELECT "inventory1"."inv_item_sk", "inventory1"."inv_warehouse_sk", "inventory1"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory1"
INNER JOIN (SELECT "d_date_sk"
FROM "duck_table_22_0") AS "t18" ON "inventory1"."inv_date_sk" = "t18"."d_date_sk") AS "t19"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t20" ON "t19"."inv_item_sk" = "t20"."i_item_sk") AS "t21"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t22" ON "t21"."inv_warehouse_sk" = "t22"."w_warehouse_sk"
GROUP BY "t21"."i_product_name", "t21"."i_brand") AS "t"
UNION ALL
SELECT "t31"."i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t31"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t29"."inv_warehouse_sk", "t29"."inv_quantity_on_hand", "t30"."i_product_name"
FROM (SELECT "inventory2"."inv_item_sk", "inventory2"."inv_warehouse_sk", "inventory2"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory2"
INNER JOIN (SELECT "d_date_sk"
FROM "duck_table_22_0") AS "t28" ON "inventory2"."inv_date_sk" = "t28"."d_date_sk") AS "t29"
INNER JOIN (SELECT "i_item_sk", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t30" ON "t29"."inv_item_sk" = "t30"."i_item_sk") AS "t31"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t32" ON "t31"."inv_warehouse_sk" = "t32"."w_warehouse_sk"
GROUP BY "t31"."i_product_name") AS "t"
UNION ALL
SELECT NULL AS "i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t41"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t39"."inv_warehouse_sk", "t39"."inv_quantity_on_hand"
FROM (SELECT "inventory3"."inv_item_sk", "inventory3"."inv_warehouse_sk", "inventory3"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory3"
INNER JOIN (SELECT "d_date_sk"
FROM "duck_table_22_0") AS "t38" ON "inventory3"."inv_date_sk" = "t38"."d_date_sk") AS "t39"
INNER JOIN (SELECT "i_item_sk"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t40" ON "t39"."inv_item_sk" = "t40"."i_item_sk") AS "t41"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t42" ON "t41"."inv_warehouse_sk" = "t42"."w_warehouse_sk") AS "t46"
ORDER BY "qoh" NULLS FIRST, "i_product_name" NULLS FIRST, "i_brand" NULLS FIRST, "i_class" NULLS FIRST, "i_category" NULLS FIRST
FETCH NEXT 100 ROWS ONLY
;
