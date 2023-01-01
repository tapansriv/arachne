CREATE TABLE duck_table_40_0 AS SELECT "t1"."cs_sold_date_sk", "t1"."cs_item_sk", "t2"."w_state", "t1"."-"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_warehouse_sk", "t"."cs_item_sk", "t"."cs_sales_price" - CASE WHEN "t0"."cr_refunded_cash" IS NOT NULL THEN "t0"."CAST" ELSE 0 END AS "-"
FROM (SELECT "cs_sold_date_sk", "cs_warehouse_sk", "cs_item_sk", "cs_order_number", "cs_sales_price"
FROM '/mnt/disks/tpcds/parquet/catalog_sales.parquet' AS catalog_sales) AS "t"
LEFT JOIN (SELECT "cr_item_sk", "cr_order_number", "cr_refunded_cash", "cr_refunded_cash" AS "CAST"
FROM '/mnt/disks/tpcds/parquet/catalog_returns.parquet' AS catalog_returns) AS "t0" ON "t"."cs_order_number" = "t0"."cr_order_number" AND "t"."cs_item_sk" = "t0"."cr_item_sk") AS "t1"
INNER JOIN (SELECT "w_warehouse_sk", "w_state"
FROM '/mnt/disks/tpcds/parquet/warehouse.parquet' AS warehouse) AS "t2" ON "t1"."cs_warehouse_sk" = "t2"."w_warehouse_sk"
;
SELECT "t2"."w_state", "t2"."i_item_id", SUM(CASE WHEN "t5"."<" THEN "t2"."-" ELSE 0 END) AS "sales_before", SUM(CASE WHEN "t5".">=" THEN "t2"."-" ELSE 0 END) AS "sales_after"
FROM (SELECT "duck_table_40_0"."cs_sold_date_sk", "duck_table_40_0"."w_state", "t1"."i_item_id", "duck_table_40_0"."-"
FROM "duck_table_40_0"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item
WHERE "i_current_price" >= 0.99 AND "i_current_price" <= 1.49) AS "t1" ON "duck_table_40_0"."cs_item_sk" = "t1"."i_item_sk") AS "t2"
INNER JOIN (SELECT "d_date_sk", "d_date" < DATE '2000-03-11' AS "<", "d_date" >= DATE '2000-03-11' AS ">="
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_date" >= DATE '2000-02-10' AND "d_date" <= DATE '2000-04-10') AS "t5" ON "t2"."cs_sold_date_sk" = "t5"."d_date_sk"
GROUP BY "t2"."w_state", "t2"."i_item_id"
ORDER BY "t2"."w_state", "t2"."i_item_id"
FETCH NEXT 100 ROWS ONLY
;
