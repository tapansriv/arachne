CREATE TABLE rs_table_37_0 AS SELECT "t1"."i_item_sk", "t1"."i_item_id", "t1"."i_item_desc", "t1"."i_current_price", "t4"."inv_date_sk"
FROM (SELECT "i_item_sk", "i_item_id", "i_item_desc", "i_current_price"
FROM item
WHERE "i_current_price" >= 68 AND "i_current_price" <= 68 + 30 AND "i_manufact_id" IN (677, 694, 808, 940)) AS "t1"
INNER JOIN (SELECT "inv_date_sk", "inv_item_sk"
FROM inventory
WHERE "inv_quantity_on_hand" >= 100 AND "inv_quantity_on_hand" <= 500) AS "t4" ON "t1"."i_item_sk" = "t4"."inv_item_sk"
;
SELECT "t2"."i_item_id", "t2"."i_item_desc", "t2"."i_current_price"
FROM (SELECT "rs_table_37_0"."i_item_sk", "rs_table_37_0"."i_item_id", "rs_table_37_0"."i_item_desc", "rs_table_37_0"."i_current_price"
FROM "rs_table_37_0"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-02-01' AND "d_date" <= DATE '2000-04-01') AS "t1" ON "rs_table_37_0"."inv_date_sk" = "t1"."d_date_sk") AS "t2"
INNER JOIN (SELECT "cs_item_sk"
FROM catalog_sales) AS "t3" ON "t2"."i_item_sk" = "t3"."cs_item_sk"
GROUP BY "t2"."i_item_id", "t2"."i_item_desc", "t2"."i_current_price"
ORDER BY "t2"."i_item_id"
LIMIT 100
;
