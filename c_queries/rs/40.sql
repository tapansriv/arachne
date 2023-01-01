SELECT "t7"."w_state", "t7"."i_item_id", SUM(CASE WHEN "t10"."<" THEN "t7"."-" ELSE 0 END) AS "sales_before", SUM(CASE WHEN "t10".">=" THEN "t7"."-" ELSE 0 END) AS "sales_after"
FROM (SELECT "t3"."cs_sold_date_sk", "t3"."w_state", "t6"."i_item_id", "t3"."-"
FROM (SELECT "t1"."cs_sold_date_sk", "t1"."cs_item_sk", "t2"."w_state", "t1"."-"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_warehouse_sk", "t"."cs_item_sk", "t"."cs_sales_price" - CASE WHEN "t0"."cr_refunded_cash" IS NOT NULL THEN "t0"."CAST" ELSE 0 END AS "-"
FROM (SELECT "cs_sold_date_sk", "cs_warehouse_sk", "cs_item_sk", "cs_order_number", "cs_sales_price"
FROM catalog_sales) AS "t"
LEFT JOIN (SELECT "cr_item_sk", "cr_order_number", "cr_refunded_cash", "cr_refunded_cash" AS "CAST"
FROM catalog_returns) AS "t0" ON "t"."cs_order_number" = "t0"."cr_order_number" AND "t"."cs_item_sk" = "t0"."cr_item_sk") AS "t1"
INNER JOIN (SELECT "w_warehouse_sk", "w_state"
FROM warehouse) AS "t2" ON "t1"."cs_warehouse_sk" = "t2"."w_warehouse_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item
WHERE "i_current_price" >= 0.99 AND "i_current_price" <= 1.49) AS "t6" ON "t3"."cs_item_sk" = "t6"."i_item_sk") AS "t7"
INNER JOIN (SELECT "d_date_sk", "d_date" < DATE '2000-03-11' AS "<", "d_date" >= DATE '2000-03-11' AS ">="
FROM date_dim
WHERE "d_date" >= DATE '2000-02-10' AND "d_date" <= DATE '2000-04-10') AS "t10" ON "t7"."cs_sold_date_sk" = "t10"."d_date_sk"
GROUP BY "t7"."w_state", "t7"."i_item_id"
ORDER BY "t7"."w_state", "t7"."i_item_id"
LIMIT 100

