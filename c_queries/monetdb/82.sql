SELECT "t9"."i_item_id", "t9"."i_item_desc", "t9"."i_current_price"
FROM (SELECT "t5"."i_item_sk", "t5"."i_item_id", "t5"."i_item_desc", "t5"."i_current_price"
FROM (SELECT "t1"."i_item_sk", "t1"."i_item_id", "t1"."i_item_desc", "t1"."i_current_price", "t4"."inv_date_sk"
FROM (SELECT "i_item_sk", "i_item_id", "i_item_desc", "i_current_price"
FROM item
WHERE "i_current_price" >= 62 AND "i_current_price" <= 62 + 30 AND "i_manufact_id" IN (129, 270, 423, 821)) AS "t1"
INNER JOIN (SELECT "inv_date_sk", "inv_item_sk"
FROM inventory
WHERE "inv_quantity_on_hand" >= 100 AND "inv_quantity_on_hand" <= 500) AS "t4" ON "t1"."i_item_sk" = "t4"."inv_item_sk") AS "t5"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-05-25' AND "d_date" <= DATE '2000-07-24') AS "t8" ON "t5"."inv_date_sk" = "t8"."d_date_sk") AS "t9"
INNER JOIN (SELECT "ss_item_sk"
FROM store_sales) AS "t10" ON "t9"."i_item_sk" = "t10"."ss_item_sk"
GROUP BY "t9"."i_item_id", "t9"."i_item_desc", "t9"."i_current_price"
ORDER BY "t9"."i_item_id" IS NULL, "t9"."i_item_id"
LIMIT 100
;
