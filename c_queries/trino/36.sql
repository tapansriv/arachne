SELECT "gross_margin", "i_category", "i_class", "lochierarchy", RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "t_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "gross_margin" IS NULL, "gross_margin") AS "rank_within_parent", CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END
FROM (SELECT *
FROM (SELECT SUM("t5"."ss_net_profit") * 1.0000 / SUM("t5"."ss_ext_sales_price") AS "gross_margin", "t5"."i_category", "t5"."i_class", 0 AS "t_category", 0 AS "t_class", 0 AS "lochierarchy"
FROM (SELECT "t3"."ss_store_sk", "t3"."ss_ext_sales_price", "t3"."ss_net_profit", "t4"."i_class", "t4"."i_category"
FROM (SELECT "t"."ss_item_sk", "t"."ss_store_sk", "t"."ss_ext_sales_price", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_ext_sales_price", "ss_net_profit"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 2001) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM tpcds.sf1000.item AS item) AS "t4" ON "t3"."ss_item_sk" = "t4"."i_item_sk") AS "t5"
INNER JOIN (SELECT "s_store_sk"
FROM tpcds.sf1000.store AS store
WHERE "s_state" = 'TN') AS "t8" ON "t5"."ss_store_sk" = "t8"."s_store_sk"
GROUP BY "t5"."i_category", "t5"."i_class"
UNION
SELECT SUM("t24"."ss_net_profit") * 1.0000 / SUM("t24"."ss_ext_sales_price") AS "gross_margin", "t24"."i_category", NULL AS "i_class", 0 AS "t_category", 1 AS "t_class", 1 AS "lochierarchy"
FROM (SELECT "t18"."i_category", SUM("t18"."ss_net_profit") AS "ss_net_profit", SUM("t18"."ss_ext_sales_price") AS "ss_ext_sales_price"
FROM (SELECT "t16"."ss_store_sk", "t16"."ss_ext_sales_price", "t16"."ss_net_profit", "t17"."i_class", "t17"."i_category"
FROM (SELECT "t12"."ss_item_sk", "t12"."ss_store_sk", "t12"."ss_ext_sales_price", "t12"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_ext_sales_price", "ss_net_profit"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t12"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 2001) AS "t15" ON "t12"."ss_sold_date_sk" = "t15"."d_date_sk") AS "t16"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM tpcds.sf1000.item AS item) AS "t17" ON "t16"."ss_item_sk" = "t17"."i_item_sk") AS "t18"
INNER JOIN (SELECT "s_store_sk"
FROM tpcds.sf1000.store AS store
WHERE "s_state" = 'TN') AS "t21" ON "t18"."ss_store_sk" = "t21"."s_store_sk"
GROUP BY "t18"."i_category", "t18"."i_class") AS "t24"
GROUP BY "t24"."i_category") AS "t"
UNION
SELECT SUM("t40"."ss_net_profit") * 1.0000 / SUM("t40"."ss_ext_sales_price") AS "gross_margin", NULL AS "i_category", NULL AS "i_class", 1 AS "t_category", 1 AS "t_class", 2 AS "lochierarchy"
FROM (SELECT SUM("t34"."ss_net_profit") AS "ss_net_profit", SUM("t34"."ss_ext_sales_price") AS "ss_ext_sales_price"
FROM (SELECT "t32"."ss_store_sk", "t32"."ss_ext_sales_price", "t32"."ss_net_profit", "t33"."i_class", "t33"."i_category"
FROM (SELECT "t28"."ss_item_sk", "t28"."ss_store_sk", "t28"."ss_ext_sales_price", "t28"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_store_sk", "ss_ext_sales_price", "ss_net_profit"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t28"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 2001) AS "t31" ON "t28"."ss_sold_date_sk" = "t31"."d_date_sk") AS "t32"
INNER JOIN (SELECT "i_item_sk", "i_class", "i_category"
FROM tpcds.sf1000.item AS item) AS "t33" ON "t32"."ss_item_sk" = "t33"."i_item_sk") AS "t34"
INNER JOIN (SELECT "s_store_sk"
FROM tpcds.sf1000.store AS store
WHERE "s_state" = 'TN') AS "t37" ON "t34"."ss_store_sk" = "t37"."s_store_sk"
GROUP BY "t34"."i_category", "t34"."i_class") AS "t40") AS "t43"
ORDER BY "lochierarchy" IS NULL DESC, "lochierarchy" DESC, CASE WHEN "lochierarchy" = 0 THEN "i_category" ELSE NULL END, RANK() OVER (PARTITION BY "lochierarchy", CASE WHEN "t_class" = 0 THEN "i_category" ELSE NULL END ORDER BY "gross_margin" IS NULL, "gross_margin")
LIMIT 100

