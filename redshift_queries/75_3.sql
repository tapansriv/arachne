CREATE TABLE rs_table_75_0 AS SELECT *
FROM (SELECT "t5"."d_year", "t5"."i_brand_id", "t5"."i_class_id", "t5"."i_category_id", "t5"."i_manufact_id", "t5"."cs_quantity" - CASE WHEN "t6"."cr_return_quantity" IS NOT NULL THEN "t6"."CAST" ELSE 0 END AS "sales_cnt", "t5"."cs_ext_sales_price" - CASE WHEN "t6"."cr_return_amount" IS NOT NULL THEN "t6"."CAST5" ELSE 0.0 END AS "sales_amt"
FROM (SELECT "t3"."cs_item_sk", "t3"."cs_order_number", "t3"."cs_quantity", "t3"."cs_ext_sales_price", "t3"."i_brand_id", "t3"."i_class_id", "t3"."i_category_id", "t3"."i_manufact_id", "t4"."d_year"
FROM (SELECT "t"."cs_sold_date_sk", "t"."cs_item_sk", "t"."cs_order_number", "t"."cs_quantity", "t"."cs_ext_sales_price", "t2"."i_brand_id", "t2"."i_class_id", "t2"."i_category_id", "t2"."i_manufact_id"
FROM (SELECT "cs_sold_date_sk", "cs_item_sk", "cs_order_number", "cs_quantity", "cs_ext_sales_price"
FROM catalog_sales) AS "t"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id"
FROM item
WHERE "i_category" = 'Books') AS "t2" ON "t"."cs_item_sk" = "t2"."i_item_sk") AS "t3"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t4" ON "t3"."cs_sold_date_sk" = "t4"."d_date_sk") AS "t5"
LEFT JOIN (SELECT "cr_item_sk", "cr_order_number", "cr_return_quantity", "cr_return_amount", "cr_return_quantity" AS "CAST", "cr_return_amount" AS "CAST5"
FROM catalog_returns) AS "t6" ON "t5"."cs_order_number" = "t6"."cr_order_number" AND "t5"."cs_item_sk" = "t6"."cr_item_sk"
UNION
SELECT "t14"."d_year", "t14"."i_brand_id", "t14"."i_class_id", "t14"."i_category_id", "t14"."i_manufact_id", "t14"."ss_quantity" - CASE WHEN "t15"."sr_return_quantity" IS NOT NULL THEN "t15"."CAST" ELSE 0 END AS "sales_cnt", "t14"."ss_ext_sales_price" - CASE WHEN "t15"."sr_return_amt" IS NOT NULL THEN "t15"."CAST5" ELSE 0.0 END AS "sales_amt"
FROM (SELECT "t12"."ss_item_sk", "t12"."ss_ticket_number", "t12"."ss_quantity", "t12"."ss_ext_sales_price", "t12"."i_brand_id", "t12"."i_class_id", "t12"."i_category_id", "t12"."i_manufact_id", "t13"."d_year"
FROM (SELECT "t8"."ss_sold_date_sk", "t8"."ss_item_sk", "t8"."ss_ticket_number", "t8"."ss_quantity", "t8"."ss_ext_sales_price", "t11"."i_brand_id", "t11"."i_class_id", "t11"."i_category_id", "t11"."i_manufact_id"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ticket_number", "ss_quantity", "ss_ext_sales_price"
FROM store_sales) AS "t8"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id"
FROM item
WHERE "i_category" = 'Books') AS "t11" ON "t8"."ss_item_sk" = "t11"."i_item_sk") AS "t12"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t13" ON "t12"."ss_sold_date_sk" = "t13"."d_date_sk") AS "t14"
LEFT JOIN (SELECT "sr_item_sk", "sr_ticket_number", "sr_return_quantity", "sr_return_amt", "sr_return_quantity" AS "CAST", "sr_return_amt" AS "CAST5"
FROM store_returns) AS "t15" ON "t14"."ss_ticket_number" = "t15"."sr_ticket_number" AND "t14"."ss_item_sk" = "t15"."sr_item_sk")
UNION
SELECT "t24"."d_year", "t24"."i_brand_id", "t24"."i_class_id", "t24"."i_category_id", "t24"."i_manufact_id", "t24"."ws_quantity" - CASE WHEN "t25"."wr_return_quantity" IS NOT NULL THEN "t25"."CAST" ELSE 0 END AS "sales_cnt", "t24"."ws_ext_sales_price" - CASE WHEN "t25"."wr_return_amt" IS NOT NULL THEN "t25"."CAST5" ELSE 0.0 END AS "sales_amt"
FROM (SELECT "t22"."ws_item_sk", "t22"."ws_order_number", "t22"."ws_quantity", "t22"."ws_ext_sales_price", "t22"."i_brand_id", "t22"."i_class_id", "t22"."i_category_id", "t22"."i_manufact_id", "t23"."d_year"
FROM (SELECT "t18"."ws_sold_date_sk", "t18"."ws_item_sk", "t18"."ws_order_number", "t18"."ws_quantity", "t18"."ws_ext_sales_price", "t21"."i_brand_id", "t21"."i_class_id", "t21"."i_category_id", "t21"."i_manufact_id"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_order_number", "ws_quantity", "ws_ext_sales_price"
FROM web_sales) AS "t18"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id"
FROM item
WHERE "i_category" = 'Books') AS "t21" ON "t18"."ws_item_sk" = "t21"."i_item_sk") AS "t22"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t23" ON "t22"."ws_sold_date_sk" = "t23"."d_date_sk") AS "t24"
LEFT JOIN (SELECT "wr_item_sk", "wr_order_number", "wr_return_quantity", "wr_return_amt", "wr_return_quantity" AS "CAST", "wr_return_amt" AS "CAST5"
FROM web_returns) AS "t25" ON "t24"."ws_order_number" = "t25"."wr_order_number" AND "t24"."ws_item_sk" = "t25"."wr_item_sk"
;
SELECT "t4"."d_year" AS "prev_year", "t1"."d_year" AS "year_", "t1"."i_brand_id", "t1"."i_class_id", "t1"."i_category_id", "t1"."i_manufact_id", "t4"."sales_cnt" AS "prev_yr_cnt", "t1"."sales_cnt" AS "curr_yr_cnt", "t1"."sales_cnt" - "t4"."sales_cnt" AS "sales_cnt_diff", "t1"."sales_amt" - "t4"."sales_amt" AS "sales_amt_diff"
FROM (SELECT "d_year", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id", SUM("sales_cnt") AS "sales_cnt", SUM("sales_amt") AS "sales_amt", CAST(SUM("sales_cnt") AS DECIMAL(17, 2)) AS "CAST"
FROM "rs_table_75_0"
GROUP BY "d_year", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id"
HAVING "d_year" = 2002) AS "t1"
INNER JOIN (SELECT "d_year", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id", SUM("sales_cnt") AS "sales_cnt", SUM("sales_amt") AS "sales_amt", CAST(SUM("sales_cnt") AS DECIMAL(17, 2)) AS "CAST"
FROM "rs_table_75_0"
GROUP BY "d_year", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id"
HAVING "d_year" = 2002 - 1) AS "t4" ON "t1"."i_brand_id" = "t4"."i_brand_id" AND "t1"."i_class_id" = "t4"."i_class_id" AND "t1"."i_category_id" = "t4"."i_category_id" AND "t1"."i_manufact_id" = "t4"."i_manufact_id" AND "t1"."CAST" / "t4"."CAST" < 0.9
ORDER BY "t1"."sales_cnt" - "t4"."sales_cnt", "t1"."sales_amt" - "t4"."sales_amt"
LIMIT 100
;
