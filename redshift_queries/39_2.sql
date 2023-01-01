CREATE TABLE rs_table_39_0 AS SELECT "w_warehouse_sk", "i_item_sk", "d_moy", "mean", CASE WHEN "mean" = 0 THEN NULL ELSE "$f4" * 1.000 / "mean" END AS "cov"
FROM (SELECT "t2"."w_warehouse_name", "t2"."w_warehouse_sk", "t2"."i_item_sk", "t5"."d_moy", STDDEV_SAMP("t2"."inv_quantity_on_hand") AS "$f4", AVG("t2"."inv_quantity_on_hand") AS "mean"
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
GROUP BY "t2"."w_warehouse_name", "t2"."w_warehouse_sk", "t2"."i_item_sk", "t5"."d_moy"
HAVING CASE WHEN AVG("t2"."inv_quantity_on_hand") = 0 THEN 0 ELSE STDDEV_SAMP("t2"."inv_quantity_on_hand") * 1.000 / AVG("t2"."inv_quantity_on_hand") END > 1) AS "t8"
WHERE "t8"."d_moy" = 1 + 1
;
SELECT *
FROM (SELECT "w_warehouse_sk", "i_item_sk", "d_moy", "mean", CASE WHEN "mean" = 0 THEN NULL ELSE "$f4" * 1.000 / "mean" END AS "cov"
FROM (SELECT "t2"."w_warehouse_name", "t2"."w_warehouse_sk", "t2"."i_item_sk", "t5"."d_moy", STDDEV_SAMP("t2"."inv_quantity_on_hand") AS "$f4", AVG("t2"."inv_quantity_on_hand") AS "mean"
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
GROUP BY "t2"."w_warehouse_name", "t2"."w_warehouse_sk", "t2"."i_item_sk", "t5"."d_moy"
HAVING CASE WHEN AVG("t2"."inv_quantity_on_hand") = 0 THEN 0 ELSE STDDEV_SAMP("t2"."inv_quantity_on_hand") * 1.000 / AVG("t2"."inv_quantity_on_hand") END > 1) AS "t8"
WHERE "t8"."d_moy" = 1) AS "t12"
INNER JOIN "rs_table_39_0" ON "t12"."i_item_sk" = "rs_table_39_0"."i_item_sk" AND "t12"."w_warehouse_sk" = "rs_table_39_0"."w_warehouse_sk"
ORDER BY "t12"."w_warehouse_sk" NULLS FIRST, "t12"."i_item_sk" NULLS FIRST, "t12"."d_moy" NULLS FIRST, "t12"."mean" NULLS FIRST, "t12"."cov" NULLS FIRST, "rs_table_39_0"."d_moy" NULLS FIRST, "rs_table_39_0"."mean" NULLS FIRST, "rs_table_39_0"."cov" NULLS FIRST
;
