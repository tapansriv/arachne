CREATE TABLE rs_table_22_0 AS SELECT "t4"."i_product_name", "t4"."i_brand", "t4"."i_class", "t4"."i_category", "t4"."inv_quantity_on_hand" AS "qoh"
FROM (SELECT "t2"."inv_warehouse_sk", "t2"."inv_quantity_on_hand", "t3"."i_brand", "t3"."i_class", "t3"."i_category", "t3"."i_product_name"
FROM (SELECT "inventory"."inv_item_sk", "inventory"."inv_warehouse_sk", "inventory"."inv_quantity_on_hand"
FROM inventory
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t1" ON "inventory"."inv_date_sk" = "t1"."d_date_sk") AS "t2"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM item) AS "t3" ON "t2"."inv_item_sk" = "t3"."i_item_sk") AS "t4"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t5" ON "t4"."inv_warehouse_sk" = "t5"."w_warehouse_sk"
;
SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "i_product_name", "i_brand", "i_class", "i_category", AVG("qoh") AS "qoh"
FROM "rs_table_22_0"
GROUP BY "i_product_name", "i_brand", "i_class", "i_category"
UNION ALL
SELECT "t5"."i_product_name", "t5"."i_brand", "t5"."i_class", NULL AS "i_category", AVG("t5"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t3"."inv_warehouse_sk", "t3"."inv_quantity_on_hand", "t4"."i_brand", "t4"."i_class", "t4"."i_product_name"
FROM (SELECT "inventory"."inv_item_sk", "inventory"."inv_warehouse_sk", "inventory"."inv_quantity_on_hand"
FROM inventory
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "inventory"."inv_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_product_name"
FROM item) AS "t4" ON "t3"."inv_item_sk" = "t4"."i_item_sk") AS "t5"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t6" ON "t5"."inv_warehouse_sk" = "t6"."w_warehouse_sk"
GROUP BY "t5"."i_product_name", "t5"."i_brand", "t5"."i_class")
UNION ALL
SELECT "t16"."i_product_name", "t16"."i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t16"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t14"."inv_warehouse_sk", "t14"."inv_quantity_on_hand", "t15"."i_brand", "t15"."i_product_name"
FROM (SELECT "inventory0"."inv_item_sk", "inventory0"."inv_warehouse_sk", "inventory0"."inv_quantity_on_hand"
FROM inventory AS "inventory0"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t13" ON "inventory0"."inv_date_sk" = "t13"."d_date_sk") AS "t14"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_product_name"
FROM item) AS "t15" ON "t14"."inv_item_sk" = "t15"."i_item_sk") AS "t16"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t17" ON "t16"."inv_warehouse_sk" = "t17"."w_warehouse_sk"
GROUP BY "t16"."i_product_name", "t16"."i_brand")
UNION ALL
SELECT "t27"."i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t27"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t25"."inv_warehouse_sk", "t25"."inv_quantity_on_hand", "t26"."i_product_name"
FROM (SELECT "inventory1"."inv_item_sk", "inventory1"."inv_warehouse_sk", "inventory1"."inv_quantity_on_hand"
FROM inventory AS "inventory1"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t24" ON "inventory1"."inv_date_sk" = "t24"."d_date_sk") AS "t25"
INNER JOIN (SELECT "i_item_sk", "i_product_name"
FROM item) AS "t26" ON "t25"."inv_item_sk" = "t26"."i_item_sk") AS "t27"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t28" ON "t27"."inv_warehouse_sk" = "t28"."w_warehouse_sk"
GROUP BY "t27"."i_product_name")
UNION ALL
SELECT NULL AS "i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t38"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t36"."inv_warehouse_sk", "t36"."inv_quantity_on_hand"
FROM (SELECT "inventory2"."inv_item_sk", "inventory2"."inv_warehouse_sk", "inventory2"."inv_quantity_on_hand"
FROM inventory AS "inventory2"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t35" ON "inventory2"."inv_date_sk" = "t35"."d_date_sk") AS "t36"
INNER JOIN (SELECT "i_item_sk"
FROM item) AS "t37" ON "t36"."inv_item_sk" = "t37"."i_item_sk") AS "t38"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t39" ON "t38"."inv_warehouse_sk" = "t39"."w_warehouse_sk") AS "t43"
ORDER BY "qoh" NULLS FIRST, "i_product_name" NULLS FIRST, "i_brand" NULLS FIRST, "i_class" NULLS FIRST, "i_category" NULLS FIRST
LIMIT 100
;
