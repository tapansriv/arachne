SELECT *
FROM (SELECT "t5"."w_warehouse_name", "t5"."i_item_id", SUM("t5"."inv_quantity_on_hand") FILTER (WHERE "t8"."<") AS "inv_before", SUM("t5"."inv_quantity_on_hand") FILTER (WHERE "t8".">=") AS "inv_after"
FROM (SELECT "t1"."inv_date_sk", "t1"."inv_quantity_on_hand", "t1"."w_warehouse_name", "t4"."i_item_id"
FROM (SELECT "t"."inv_date_sk", "t"."inv_item_sk", "t"."inv_quantity_on_hand", "t0"."w_warehouse_name"
FROM (SELECT *
FROM inventory) AS "t"
INNER JOIN (SELECT "w_warehouse_sk", "w_warehouse_name"
FROM warehouse) AS "t0" ON "t"."inv_warehouse_sk" = "t0"."w_warehouse_sk") AS "t1"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item
WHERE "i_current_price" >= 0.99 AND "i_current_price" <= 1.49) AS "t4" ON "t1"."inv_item_sk" = "t4"."i_item_sk") AS "t5"
INNER JOIN (SELECT "d_date_sk", "d_date" < DATE '2000-03-11' AS "<", "d_date" >= DATE '2000-03-11' AS ">="
FROM date_dim
WHERE "d_date" >= DATE '2000-02-10' AND "d_date" <= DATE '2000-04-10') AS "t8" ON "t5"."inv_date_sk" = "t8"."d_date_sk"
GROUP BY "t5"."w_warehouse_name", "t5"."i_item_id"
HAVING CASE WHEN "inv_before" > 0 THEN CAST("inv_after" * 1.000 / "inv_before" AS DECIMAL(19, 8)) ELSE NULL END >= 2.000 / 3.000 AND CASE WHEN "inv_before" > 0 THEN CAST("inv_after" * 1.000 / "inv_before" AS DECIMAL(19, 8)) ELSE NULL END <= 3.000 / 2.000) AS "t11"
ORDER BY "w_warehouse_name", "i_item_id"
LIMIT 100
;
