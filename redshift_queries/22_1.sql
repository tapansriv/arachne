CREATE TABLE rs_table_22_0 AS SELECT "t4"."inv_quantity_on_hand" AS "qoh"
FROM (SELECT "t2"."inv_warehouse_sk", "t2"."inv_quantity_on_hand"
FROM (SELECT "inventory"."inv_item_sk", "inventory"."inv_warehouse_sk", "inventory"."inv_quantity_on_hand"
FROM inventory
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t1" ON "inventory"."inv_date_sk" = "t1"."d_date_sk") AS "t2"
INNER JOIN (SELECT "i_item_sk"
FROM item) AS "t3" ON "t2"."inv_item_sk" = "t3"."i_item_sk") AS "t4"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t5" ON "t4"."inv_warehouse_sk" = "t5"."w_warehouse_sk"
;
SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "t4"."i_product_name", "t4"."i_brand", "t4"."i_class", "t4"."i_category", AVG("t4"."inv_quantity_on_hand") AS "qoh"
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
GROUP BY "t4"."i_product_name", "t4"."i_brand", "t4"."i_class", "t4"."i_category"
UNION ALL
SELECT "t13"."i_product_name", "t13"."i_brand", "t13"."i_class", NULL AS "i_category", AVG("t13"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t11"."inv_warehouse_sk", "t11"."inv_quantity_on_hand", "t12"."i_brand", "t12"."i_class", "t12"."i_product_name"
FROM (SELECT "inventory0"."inv_item_sk", "inventory0"."inv_warehouse_sk", "inventory0"."inv_quantity_on_hand"
FROM inventory AS "inventory0"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t10" ON "inventory0"."inv_date_sk" = "t10"."d_date_sk") AS "t11"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_product_name"
FROM item) AS "t12" ON "t11"."inv_item_sk" = "t12"."i_item_sk") AS "t13"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t14" ON "t13"."inv_warehouse_sk" = "t14"."w_warehouse_sk"
GROUP BY "t13"."i_product_name", "t13"."i_brand", "t13"."i_class")
UNION ALL
SELECT "t24"."i_product_name", "t24"."i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t24"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t22"."inv_warehouse_sk", "t22"."inv_quantity_on_hand", "t23"."i_brand", "t23"."i_product_name"
FROM (SELECT "inventory1"."inv_item_sk", "inventory1"."inv_warehouse_sk", "inventory1"."inv_quantity_on_hand"
FROM inventory AS "inventory1"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t21" ON "inventory1"."inv_date_sk" = "t21"."d_date_sk") AS "t22"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_product_name"
FROM item) AS "t23" ON "t22"."inv_item_sk" = "t23"."i_item_sk") AS "t24"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t25" ON "t24"."inv_warehouse_sk" = "t25"."w_warehouse_sk"
GROUP BY "t24"."i_product_name", "t24"."i_brand")
UNION ALL
SELECT "t35"."i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t35"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t33"."inv_warehouse_sk", "t33"."inv_quantity_on_hand", "t34"."i_product_name"
FROM (SELECT "inventory2"."inv_item_sk", "inventory2"."inv_warehouse_sk", "inventory2"."inv_quantity_on_hand"
FROM inventory AS "inventory2"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t32" ON "inventory2"."inv_date_sk" = "t32"."d_date_sk") AS "t33"
INNER JOIN (SELECT "i_item_sk", "i_product_name"
FROM item) AS "t34" ON "t33"."inv_item_sk" = "t34"."i_item_sk") AS "t35"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t36" ON "t35"."inv_warehouse_sk" = "t36"."w_warehouse_sk"
GROUP BY "t35"."i_product_name")
UNION ALL
SELECT NULL AS "i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("qoh") AS "qoh"
FROM "rs_table_22_0") AS "t43"
ORDER BY "qoh" NULLS FIRST, "i_product_name" NULLS FIRST, "i_brand" NULLS FIRST, "i_class" NULLS FIRST, "i_category" NULLS FIRST
LIMIT 100
;
