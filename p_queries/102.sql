CREATE TABLE duck_table_37_1 AS SELECT "i_item_id", "i_item_desc", "i_current_price"
FROM "duck_table_37_0"
GROUP BY "i_item_id", "i_item_desc", "i_current_price"
ORDER BY "i_item_id"
FETCH NEXT 100 ROWS ONLY
