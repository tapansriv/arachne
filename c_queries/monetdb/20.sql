SELECT "t7"."i_item_id", "t7"."i_item_desc", "t7"."i_category", "t7"."i_class", "t7"."i_current_price", "t7"."itemrevenue", "t7"."itemrevenue" * 100.0000 / (SUM("t7"."itemrevenue") OVER (PARTITION BY "t7"."i_class" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)) AS "revenueratio"
FROM (SELECT "t2"."i_item_id", "t2"."i_item_desc", "t2"."i_category", "t2"."i_class", "t2"."i_current_price", SUM("t2"."cs_ext_sales_price") AS "itemrevenue"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_ext_sales_price", "t1"."i_item_id", "t1"."i_item_desc", "t1"."i_current_price", "t1"."i_class", "t1"."i_category"
FROM (SELECT "cs_sold_date_sk", "cs_item_sk", "cs_ext_sales_price"
FROM catalog_sales) AS "t"
INNER JOIN (SELECT "i_item_sk", "i_item_id", "i_item_desc", "i_current_price", "i_class", "i_category"
FROM item
WHERE "i_category" IN ('Books', 'Home', 'Sports')) AS "t1" ON "t"."cs_item_sk" = "t1"."i_item_sk") AS "t2"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '1999-02-22' AND "d_date" <= DATE '1999-03-24') AS "t5" ON "t2"."cs_sold_date_sk" = "t5"."d_date_sk"
GROUP BY "t2"."i_item_id", "t2"."i_item_desc", "t2"."i_category", "t2"."i_class", "t2"."i_current_price") AS "t7"
ORDER BY "t7"."i_category", "t7"."i_class", "t7"."i_item_id", "t7"."i_item_desc", "t7"."itemrevenue" * 100.0000 / (SUM("t7"."itemrevenue") OVER (PARTITION BY "t7"."i_class" RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING))
LIMIT 100
;
