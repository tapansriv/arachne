SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT *
FROM (SELECT "t5"."i_product_name", "t5"."i_brand", "t5"."i_class", "t5"."i_category", AVG("t5"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t3"."inv_warehouse_sk", "t3"."inv_quantity_on_hand", "t4"."i_brand", "t4"."i_class", "t4"."i_category", "t4"."i_product_name"
FROM (SELECT "t"."inv_item_sk", "t"."inv_warehouse_sk", "t"."inv_quantity_on_hand"
FROM (SELECT *
FROM inventory) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t2" ON "t"."inv_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_category", "i_product_name"
FROM item) AS "t4" ON "t3"."inv_item_sk" = "t4"."i_item_sk") AS "t5"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t6" ON "t5"."inv_warehouse_sk" = "t6"."w_warehouse_sk"
GROUP BY "t5"."i_product_name", "t5"."i_brand", "t5"."i_class", "t5"."i_category"
UNION ALL
SELECT "t15"."i_product_name", "t15"."i_brand", "t15"."i_class", NULL AS "i_category", AVG("t15"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t13"."inv_warehouse_sk", "t13"."inv_quantity_on_hand", "t14"."i_brand", "t14"."i_class", "t14"."i_product_name"
FROM (SELECT "t9"."inv_item_sk", "t9"."inv_warehouse_sk", "t9"."inv_quantity_on_hand"
FROM (SELECT *
FROM inventory) AS "t9"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t12" ON "t9"."inv_date_sk" = "t12"."d_date_sk") AS "t13"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_class", "i_product_name"
FROM item) AS "t14" ON "t13"."inv_item_sk" = "t14"."i_item_sk") AS "t15"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t16" ON "t15"."inv_warehouse_sk" = "t16"."w_warehouse_sk"
GROUP BY "t15"."i_product_name", "t15"."i_brand", "t15"."i_class") AS "t"
UNION ALL
SELECT "t27"."i_product_name", "t27"."i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t27"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t25"."inv_warehouse_sk", "t25"."inv_quantity_on_hand", "t26"."i_brand", "t26"."i_product_name"
FROM (SELECT "t21"."inv_item_sk", "t21"."inv_warehouse_sk", "t21"."inv_quantity_on_hand"
FROM (SELECT *
FROM inventory) AS "t21"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t24" ON "t21"."inv_date_sk" = "t24"."d_date_sk") AS "t25"
INNER JOIN (SELECT "i_item_sk", "i_brand", "i_product_name"
FROM item) AS "t26" ON "t25"."inv_item_sk" = "t26"."i_item_sk") AS "t27"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t28" ON "t27"."inv_warehouse_sk" = "t28"."w_warehouse_sk"
GROUP BY "t27"."i_product_name", "t27"."i_brand") AS "t"
UNION ALL
SELECT "t39"."i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t39"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t37"."inv_warehouse_sk", "t37"."inv_quantity_on_hand", "t38"."i_product_name"
FROM (SELECT "t33"."inv_item_sk", "t33"."inv_warehouse_sk", "t33"."inv_quantity_on_hand"
FROM (SELECT *
FROM inventory) AS "t33"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t36" ON "t33"."inv_date_sk" = "t36"."d_date_sk") AS "t37"
INNER JOIN (SELECT "i_item_sk", "i_product_name"
FROM item) AS "t38" ON "t37"."inv_item_sk" = "t38"."i_item_sk") AS "t39"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t40" ON "t39"."inv_warehouse_sk" = "t40"."w_warehouse_sk"
GROUP BY "t39"."i_product_name") AS "t"
UNION ALL
SELECT NULL AS "i_product_name", NULL AS "i_brand", NULL AS "i_class", NULL AS "i_category", AVG("t51"."inv_quantity_on_hand") AS "qoh"
FROM (SELECT "t49"."inv_warehouse_sk", "t49"."inv_quantity_on_hand"
FROM (SELECT "t45"."inv_item_sk", "t45"."inv_warehouse_sk", "t45"."inv_quantity_on_hand"
FROM (SELECT *
FROM inventory) AS "t45"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_month_seq" >= 1200 AND "d_month_seq" <= 1200 + 11) AS "t48" ON "t45"."inv_date_sk" = "t48"."d_date_sk") AS "t49"
INNER JOIN (SELECT "i_item_sk"
FROM item) AS "t50" ON "t49"."inv_item_sk" = "t50"."i_item_sk") AS "t51"
INNER JOIN (SELECT "w_warehouse_sk"
FROM warehouse) AS "t52" ON "t51"."inv_warehouse_sk" = "t52"."w_warehouse_sk") AS "t56"
ORDER BY "qoh", "i_product_name", "i_brand", "i_class", "i_category"
LIMIT 100
;
