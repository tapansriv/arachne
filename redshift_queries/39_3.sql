CREATE TABLE rs_table_39_0 AS SELECT "t2"."w_warehouse_name", "t2"."w_warehouse_sk", "t2"."i_item_sk", "t5"."d_moy", "t2"."inv_quantity_on_hand"
FROM (SELECT "t0"."inv_date_sk", "t0"."inv_quantity_on_hand", "t0"."i_item_sk", "t1"."w_warehouse_sk", "t1"."w_warehouse_name"
FROM (SELECT "inventory"."inv_date_sk", "inventory"."inv_warehouse_sk", "inventory"."inv_quantity_on_hand", "t"."i_item_sk"
FROM inventory
INNER JOIN (SELECT "i_item_sk"
FROM item) AS "t" ON "inventory"."inv_item_sk" = "t"."i_item_sk") AS "t0"
INNER JOIN (SELECT "w_warehouse_sk", "w_warehouse_name"
FROM warehouse) AS "t1" ON "t0"."inv_warehouse_sk" = "t1"."w_warehouse_sk") AS "t2"
INNER JOIN (SELECT "d_date_sk", "d_moy"
FROM date_dim
WHERE "d_year" = 2001) AS "t5" ON "t2"."inv_date_sk" = "t5"."d_date_sk"
;
SELECT *
FROM (SELECT "w_warehouse_sk", "i_item_sk", "d_moy", "mean", CASE WHEN "mean" = 0 THEN NULL ELSE "$f4" * 1.000 / "mean" END AS "cov"
FROM (SELECT "w_warehouse_name", "w_warehouse_sk", "i_item_sk", "d_moy", STDDEV_SAMP("inv_quantity_on_hand") AS "$f4", AVG("inv_quantity_on_hand") AS "mean"
FROM "rs_table_39_0"
GROUP BY "w_warehouse_name", "w_warehouse_sk", "i_item_sk", "d_moy"
HAVING CASE WHEN AVG("inv_quantity_on_hand") = 0 THEN 0 ELSE STDDEV_SAMP("inv_quantity_on_hand") * 1.000 / AVG("inv_quantity_on_hand") END > 1) AS "t0"
WHERE "d_moy" = 1) AS "t4"
INNER JOIN (SELECT "w_warehouse_sk", "i_item_sk", "d_moy", "mean", CASE WHEN "mean" = 0 THEN NULL ELSE "$f4" * 1.000 / "mean" END AS "cov"
FROM (SELECT "w_warehouse_name", "w_warehouse_sk", "i_item_sk", "d_moy", STDDEV_SAMP("inv_quantity_on_hand") AS "$f4", AVG("inv_quantity_on_hand") AS "mean"
FROM "rs_table_39_0"
GROUP BY "w_warehouse_name", "w_warehouse_sk", "i_item_sk", "d_moy"
HAVING CASE WHEN AVG("inv_quantity_on_hand") = 0 THEN 0 ELSE STDDEV_SAMP("inv_quantity_on_hand") * 1.000 / AVG("inv_quantity_on_hand") END > 1) AS "t6"
WHERE "d_moy" = 1 + 1) AS "t10" ON "t4"."i_item_sk" = "t10"."i_item_sk" AND "t4"."w_warehouse_sk" = "t10"."w_warehouse_sk"
ORDER BY "t4"."w_warehouse_sk" NULLS FIRST, "t4"."i_item_sk" NULLS FIRST, "t4"."d_moy" NULLS FIRST, "t4"."mean" NULLS FIRST, "t4"."cov" NULLS FIRST, "t10"."d_moy" NULLS FIRST, "t10"."mean" NULLS FIRST, "t10"."cov" NULLS FIRST
;
