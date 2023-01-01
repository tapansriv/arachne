SELECT *
FROM (SELECT "w_warehouse_sk", "i_item_sk", "d_moy", "mean", CASE WHEN "mean" = 0 THEN NULL ELSE "$f4" * 1.000 / "mean" END AS "cov"
FROM (SELECT "t2"."w_warehouse_name", "t2"."w_warehouse_sk", "t2"."i_item_sk", "t5"."d_moy", STDDEV_SAMP("t2"."inv_quantity_on_hand") AS "$f4", AVG("t2"."inv_quantity_on_hand") AS "mean"
FROM (SELECT "t0"."inv_date_sk", "t0"."inv_quantity_on_hand", "t0"."i_item_sk", "t1"."w_warehouse_sk", "t1"."w_warehouse_name"
FROM (SELECT "inventory"."inv_date_sk", "inventory"."inv_warehouse_sk", "inventory"."inv_quantity_on_hand", "t"."i_item_sk"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS inventory
INNER JOIN (SELECT "i_item_sk"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t" ON "inventory"."inv_item_sk" = "t"."i_item_sk") AS "t0"
INNER JOIN (SELECT "w_warehouse_sk", "w_warehouse_name"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t1" ON "t0"."inv_warehouse_sk" = "t1"."w_warehouse_sk") AS "t2"
INNER JOIN (SELECT "d_date_sk", "d_moy"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 2001) AS "t5" ON "t2"."inv_date_sk" = "t5"."d_date_sk"
GROUP BY "t2"."w_warehouse_name", "t2"."w_warehouse_sk", "t2"."i_item_sk", "t5"."d_moy"
HAVING CASE WHEN AVG("t2"."inv_quantity_on_hand") = 0 THEN 0 ELSE STDDEV_SAMP("t2"."inv_quantity_on_hand") * 1.000 / AVG("t2"."inv_quantity_on_hand") END > 1) AS "t8"
WHERE "t8"."d_moy" = 1) AS "t12"
INNER JOIN (SELECT "w_warehouse_sk", "i_item_sk", "d_moy", "mean", CASE WHEN "mean" = 0 THEN NULL ELSE "$f4" * 1.000 / "mean" END AS "cov"
FROM (SELECT "t16"."w_warehouse_name", "t16"."w_warehouse_sk", "t16"."i_item_sk", "t19"."d_moy", STDDEV_SAMP("t16"."inv_quantity_on_hand") AS "$f4", AVG("t16"."inv_quantity_on_hand") AS "mean"
FROM (SELECT "t14"."inv_date_sk", "t14"."inv_quantity_on_hand", "t14"."i_item_sk", "t15"."w_warehouse_sk", "t15"."w_warehouse_name"
FROM (SELECT "inventory0"."inv_date_sk", "inventory0"."inv_warehouse_sk", "inventory0"."inv_quantity_on_hand", "t13"."i_item_sk"
FROM '/mnt/disks/tpcds/parquet/inventory.parquet' AS "inventory0"
INNER JOIN (SELECT "i_item_sk"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t13" ON "inventory0"."inv_item_sk" = "t13"."i_item_sk") AS "t14"
INNER JOIN (SELECT "w_warehouse_sk", "w_warehouse_name"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t15" ON "t14"."inv_warehouse_sk" = "t15"."w_warehouse_sk") AS "t16"
INNER JOIN (SELECT "d_date_sk", "d_moy"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_year" = 2001) AS "t19" ON "t16"."inv_date_sk" = "t19"."d_date_sk"
GROUP BY "t16"."w_warehouse_name", "t16"."w_warehouse_sk", "t16"."i_item_sk", "t19"."d_moy"
HAVING CASE WHEN AVG("t16"."inv_quantity_on_hand") = 0 THEN 0 ELSE STDDEV_SAMP("t16"."inv_quantity_on_hand") * 1.000 / AVG("t16"."inv_quantity_on_hand") END > 1) AS "t22"
WHERE "t22"."d_moy" = 1 + 1) AS "t26" ON "t12"."i_item_sk" = "t26"."i_item_sk" AND "t12"."w_warehouse_sk" = "t26"."w_warehouse_sk"
ORDER BY "t12"."w_warehouse_sk" NULLS FIRST, "t12"."i_item_sk" NULLS FIRST, "t12"."d_moy" NULLS FIRST, "t12"."mean" NULLS FIRST, "t12"."cov" NULLS FIRST, "t26"."d_moy" NULLS FIRST, "t26"."mean" NULLS FIRST, "t26"."cov" NULLS FIRST

