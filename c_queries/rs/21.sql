SELECT "t4"."w_warehouse_name", "t4"."i_item_id", SUM(CASE WHEN "t7"."<" THEN "t4"."inv_quantity_on_hand" ELSE NULL END) AS "inv_before", SUM(CASE WHEN "t7".">=" THEN "t4"."inv_quantity_on_hand" ELSE NULL END) AS "inv_after"
FROM (SELECT "t0"."inv_date_sk", "t0"."inv_quantity_on_hand", "t0"."w_warehouse_name", "t3"."i_item_id"
FROM (SELECT "inventory"."inv_date_sk", "inventory"."inv_item_sk", "inventory"."inv_quantity_on_hand", "t"."w_warehouse_name"
FROM inventory
INNER JOIN (SELECT "w_warehouse_sk", "w_warehouse_name"
FROM warehouse) AS "t" ON "inventory"."inv_warehouse_sk" = "t"."w_warehouse_sk") AS "t0"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item
WHERE "i_current_price" >= 0.99 AND "i_current_price" <= 1.49) AS "t3" ON "t0"."inv_item_sk" = "t3"."i_item_sk") AS "t4"
INNER JOIN (SELECT "d_date_sk", "d_date" < DATE '2000-03-11' AS "<", "d_date" >= DATE '2000-03-11' AS ">="
FROM date_dim
WHERE "d_date" >= DATE '2000-02-10' AND "d_date" <= DATE '2000-04-10') AS "t7" ON "t4"."inv_date_sk" = "t7"."d_date_sk"
GROUP BY "t4"."w_warehouse_name", "t4"."i_item_id"
HAVING CASE WHEN SUM(CASE WHEN "t7"."<" THEN "t4"."inv_quantity_on_hand" ELSE NULL END) > 0 THEN CAST(SUM(CASE WHEN "t7".">=" THEN "t4"."inv_quantity_on_hand" ELSE NULL END) * 1.000 / SUM(CASE WHEN "t7"."<" THEN "t4"."inv_quantity_on_hand" ELSE NULL END) AS DECIMAL(19, 8)) ELSE NULL END >= 2.000 / 3.000 AND CASE WHEN SUM(CASE WHEN "t7"."<" THEN "t4"."inv_quantity_on_hand" ELSE NULL END) > 0 THEN CAST(SUM(CASE WHEN "t7".">=" THEN "t4"."inv_quantity_on_hand" ELSE NULL END) * 1.000 / SUM(CASE WHEN "t7"."<" THEN "t4"."inv_quantity_on_hand" ELSE NULL END) AS DECIMAL(19, 8)) ELSE NULL END <= 3.000 / 2.000
ORDER BY "t4"."w_warehouse_name" NULLS FIRST, "t4"."i_item_id" NULLS FIRST
LIMIT 100

