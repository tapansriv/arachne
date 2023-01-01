CREATE TABLE duck_table_22_0 AS SELECT "d_date_sk", "d_month_seq"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11
;
SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "t2"."i_product_name", "t2"."i_brand", "t2"."i_class", "t2"."i_category", AVG("t2"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t0"."inv_warehouse_sk", "t0"."inv_quantity_on_hand", "t1"."i_brand", "t1"."i_class", "t1"."i_category", "t1"."i_product_name"
FROM (SELECT "inventory"."inv_item_sk", "inventory"."inv_warehouse_sk", "inventory"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS inventory
INNER JOIN (SELECT "d_date_sk"
FROM "duck_table_22_0") AS "t" ON "inventory"."inv_date_sk" = "t"."d_date_sk") AS "t0"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t1" ON "t0"."inv_item_sk" = "t1"."i_item_sk") AS "t2"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t3" ON "t2"."inv_warehouse_sk" = "t3"."w_warehouse_sk"
GROUP BY "t2"."i_product_name", "t2"."i_brand", "t2"."i_class", "t2"."i_category"
UNION ALL
SELECT "t9"."i_product_name", "t9"."i_brand", "t9"."i_class", NULL AS "i_category", AVG("t9"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t7"."inv_warehouse_sk", "t7"."inv_quantity_on_hand", "t8"."i_brand", "t8"."i_class", "t8"."i_product_name"
FROM (SELECT "inventory0"."inv_item_sk", "inventory0"."inv_warehouse_sk", "inventory0"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory0"
INNER JOIN (SELECT "d_date_sk"
FROM "duck_table_22_0") AS "t6" ON "inventory0"."inv_date_sk" = "t6"."d_date_sk") AS "t7"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t8" ON "t7"."inv_item_sk" = "t8"."i_item_sk") AS "t9"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t10" ON "t9"."inv_warehouse_sk" = "t10"."w_warehouse_sk"
GROUP BY "t9"."i_product_name", "t9"."i_brand", "t9"."i_class") AS "t"
UNION ALL
SELECT "t18"."i_product_name", "t18"."i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t18"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t16"."inv_warehouse_sk", "t16"."inv_quantity_on_hand", "t17"."i_brand", "t17"."i_product_name"
FROM (SELECT "inventory1"."inv_item_sk", "inventory1"."inv_warehouse_sk", "inventory1"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory1"
INNER JOIN (SELECT "d_date_sk"
FROM "duck_table_22_0") AS "t15" ON "inventory1"."inv_date_sk" = "t15"."d_date_sk") AS "t16"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t17" ON "t16"."inv_item_sk" = "t17"."i_item_sk") AS "t18"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t19" ON "t18"."inv_warehouse_sk" = "t19"."w_warehouse_sk"
GROUP BY "t18"."i_product_name", "t18"."i_brand") AS "t"
UNION ALL
SELECT "t27"."i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t27"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t25"."inv_warehouse_sk", "t25"."inv_quantity_on_hand", "t26"."i_product_name"
FROM (SELECT "inventory2"."inv_item_sk", "inventory2"."inv_warehouse_sk", "inventory2"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory2"
INNER JOIN (SELECT "d_date_sk"
FROM "duck_table_22_0") AS "t24" ON "inventory2"."inv_date_sk" = "t24"."d_date_sk") AS "t25"
INNER JOIN (SELECT "i_item_sk", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t26" ON "t25"."inv_item_sk" = "t26"."i_item_sk") AS "t27"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t28" ON "t27"."inv_warehouse_sk" = "t28"."w_warehouse_sk"
GROUP BY "t27"."i_product_name") AS "t"
UNION ALL
SELECT NULL AS "i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t36"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t34"."inv_warehouse_sk", "t34"."inv_quantity_on_hand"
FROM (SELECT "inventory3"."inv_item_sk", "inventory3"."inv_warehouse_sk", "inventory3"."inv_quantity_on_hand"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory3"
INNER JOIN (SELECT "d_date_sk"
FROM "duck_table_22_0") AS "t33" ON "inventory3"."inv_date_sk" = "t33"."d_date_sk") AS "t34"
INNER JOIN (SELECT "i_item_sk"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t35" ON "t34"."inv_item_sk" = "t35"."i_item_sk") AS "t36"
INNER JOIN (SELECT "w_warehouse_sk"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t37" ON "t36"."inv_warehouse_sk" = "t37"."w_warehouse_sk") AS "t41"
ORDER BY "qoh" NULLS FIRST, "i_product_name" NULLS FIRST, "i_brand" NULLS FIRST, "i_class" NULLS FIRST, "i_category" NULLS FIRST
FETCH NEXT 100 ROWS ONLY
;
