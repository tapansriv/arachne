CREATE TABLE rs_table_36_0 AS SELECT "t5"."i_category", "t5"."i_class", SUM("t5"."ss_net_profit") AS "ss_net_profit", SUM("t5"."ss_ext_sales_price") AS "ss_ext_sales_price"
FROM (SELECT "t3"."ss_store_sk", "t3"."ss_ext_sales_price", "t3"."ss_net_profit", "t4"."i_class", "t4"."i_category"
FROM (SELECT "t"."ss_item_sk", "t"."ss_store_sk", "t"."ss_ext_sales_price", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_ext_sales_price", "ss_net_profit"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2001) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM item) AS "t4" ON "t3"."ss_item_sk" = "t4"."i_item_sk") AS "t5"
INNER JOIN (SELECT "s_store_sk"
FROM store
WHERE "s_state" = 'TN') AS "t8" ON "t5"."ss_store_sk" = "t8"."s_store_sk"
GROUP BY "t5"."i_category", "t5"."i_class"
;
CREATE TABLE rs_table_36_1 AS SELECT *
FROM (SELECT "ss_net_profit" * 1.0000 / "ss_ext_sales_price" AS "gross_margin", "i_category", "i_class", 0 AS "t_category", 0 AS "t_class", 0 AS "lochierarchy"
FROM "rs_table_36_0"
UNION
SELECT SUM("ss_net_profit") * 1.0000 / SUM("ss_ext_sales_price") AS "gross_margin", "i_category", NULL AS "i_class", 0 AS "t_category", 1 AS "t_class", 1 AS "lochierarchy"
FROM "rs_table_36_0"
GROUP BY "i_category")
UNION
SELECT SUM("ss_net_profit") * 1.0000 / SUM("ss_ext_sales_price") AS "gross_margin", NULL AS "i_category", NULL AS "i_class", 1 AS "t_category", 1 AS "t_class", 2 AS "lochierarchy"
FROM "rs_table_36_0"
;
SELECT "gross_margin", "i_category", "i_class", "lochierarchy", RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "t_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "gross_margin") AS "rank_within_parent", CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END
FROM "rs_table_36_1"
ORDER BY "lochierarchy" DESC, CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END NULLS FIRST, RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "t_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "gross_margin") NULLS FIRST
LIMIT 100
;
