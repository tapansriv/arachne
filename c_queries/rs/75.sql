SELECT "t62"."d_year" AS "prev_year", "t30"."d_year" AS "year_", "t30"."i_brand_id", "t30"."i_class_id", "t30"."i_category_id", "t30"."i_manufact_id", "t62"."sales_cnt" AS "prev_yr_cnt", "t30"."sales_cnt" AS "curr_yr_cnt", "t30"."sales_cnt" - "t62"."sales_cnt" AS "sales_cnt_diff", "t30"."sales_amt" - "t62"."sales_amt" AS "sales_amt_diff"
FROM (SELECT "d_year", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id", SUM("sales_cnt") AS "sales_cnt", SUM("sales_amt") AS "sales_amt", CAST(SUM("sales_cnt") AS DECIMAL(17, 2)) AS "CAST"
FROM (SELECT *
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
FROM web_returns) AS "t25" ON "t24"."ws_order_number" = "t25"."wr_order_number" AND "t24"."ws_item_sk" = "t25"."wr_item_sk") AS "t27"
GROUP BY "d_year", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id"
HAVING "d_year" = 2002) AS "t30"
INNER JOIN (SELECT "d_year", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id", SUM("sales_cnt") AS "sales_cnt", SUM("sales_amt") AS "sales_amt", CAST(SUM("sales_cnt") AS DECIMAL(17, 2)) AS "CAST"
FROM (SELECT *
FROM (SELECT "t37"."d_year", "t37"."i_brand_id", "t37"."i_class_id", "t37"."i_category_id", "t37"."i_manufact_id", "t37"."cs_quantity" - CASE WHEN "t38"."cr_return_quantity" IS NOT NULL THEN "t38"."CAST" ELSE 0 END AS "sales_cnt", "t37"."cs_ext_sales_price" - CASE WHEN "t38"."cr_return_amount" IS NOT NULL THEN "t38"."CAST5" ELSE 0.0 END AS "sales_amt"
FROM (SELECT "t35"."cs_item_sk", "t35"."cs_order_number", "t35"."cs_quantity", "t35"."cs_ext_sales_price", "t35"."i_brand_id", "t35"."i_class_id", "t35"."i_category_id", "t35"."i_manufact_id", "t36"."d_year"
FROM (SELECT "t31"."cs_sold_date_sk", "t31"."cs_item_sk", "t31"."cs_order_number", "t31"."cs_quantity", "t31"."cs_ext_sales_price", "t34"."i_brand_id", "t34"."i_class_id", "t34"."i_category_id", "t34"."i_manufact_id"
FROM (SELECT "cs_sold_date_sk", "cs_item_sk", "cs_order_number", "cs_quantity", "cs_ext_sales_price"
FROM catalog_sales) AS "t31"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id"
FROM item
WHERE "i_category" = 'Books') AS "t34" ON "t31"."cs_item_sk" = "t34"."i_item_sk") AS "t35"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t36" ON "t35"."cs_sold_date_sk" = "t36"."d_date_sk") AS "t37"
LEFT JOIN (SELECT "cr_item_sk", "cr_order_number", "cr_return_quantity", "cr_return_amount", "cr_return_quantity" AS "CAST", "cr_return_amount" AS "CAST5"
FROM catalog_returns) AS "t38" ON "t37"."cs_order_number" = "t38"."cr_order_number" AND "t37"."cs_item_sk" = "t38"."cr_item_sk"
UNION
SELECT "t46"."d_year", "t46"."i_brand_id", "t46"."i_class_id", "t46"."i_category_id", "t46"."i_manufact_id", "t46"."ss_quantity" - CASE WHEN "t47"."sr_return_quantity" IS NOT NULL THEN "t47"."CAST" ELSE 0 END AS "sales_cnt", "t46"."ss_ext_sales_price" - CASE WHEN "t47"."sr_return_amt" IS NOT NULL THEN "t47"."CAST5" ELSE 0.0 END AS "sales_amt"
FROM (SELECT "t44"."ss_item_sk", "t44"."ss_ticket_number", "t44"."ss_quantity", "t44"."ss_ext_sales_price", "t44"."i_brand_id", "t44"."i_class_id", "t44"."i_category_id", "t44"."i_manufact_id", "t45"."d_year"
FROM (SELECT "t40"."ss_sold_date_sk", "t40"."ss_item_sk", "t40"."ss_ticket_number", "t40"."ss_quantity", "t40"."ss_ext_sales_price", "t43"."i_brand_id", "t43"."i_class_id", "t43"."i_category_id", "t43"."i_manufact_id"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ticket_number", "ss_quantity", "ss_ext_sales_price"
FROM store_sales) AS "t40"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id"
FROM item
WHERE "i_category" = 'Books') AS "t43" ON "t40"."ss_item_sk" = "t43"."i_item_sk") AS "t44"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t45" ON "t44"."ss_sold_date_sk" = "t45"."d_date_sk") AS "t46"
LEFT JOIN (SELECT "sr_item_sk", "sr_ticket_number", "sr_return_quantity", "sr_return_amt", "sr_return_quantity" AS "CAST", "sr_return_amt" AS "CAST5"
FROM store_returns) AS "t47" ON "t46"."ss_ticket_number" = "t47"."sr_ticket_number" AND "t46"."ss_item_sk" = "t47"."sr_item_sk")
UNION
SELECT "t56"."d_year", "t56"."i_brand_id", "t56"."i_class_id", "t56"."i_category_id", "t56"."i_manufact_id", "t56"."ws_quantity" - CASE WHEN "t57"."wr_return_quantity" IS NOT NULL THEN "t57"."CAST" ELSE 0 END AS "sales_cnt", "t56"."ws_ext_sales_price" - CASE WHEN "t57"."wr_return_amt" IS NOT NULL THEN "t57"."CAST5" ELSE 0.0 END AS "sales_amt"
FROM (SELECT "t54"."ws_item_sk", "t54"."ws_order_number", "t54"."ws_quantity", "t54"."ws_ext_sales_price", "t54"."i_brand_id", "t54"."i_class_id", "t54"."i_category_id", "t54"."i_manufact_id", "t55"."d_year"
FROM (SELECT "t50"."ws_sold_date_sk", "t50"."ws_item_sk", "t50"."ws_order_number", "t50"."ws_quantity", "t50"."ws_ext_sales_price", "t53"."i_brand_id", "t53"."i_class_id", "t53"."i_category_id", "t53"."i_manufact_id"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_order_number", "ws_quantity", "ws_ext_sales_price"
FROM web_sales) AS "t50"
INNER JOIN (SELECT "i_item_sk", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id"
FROM item
WHERE "i_category" = 'Books') AS "t53" ON "t50"."ws_item_sk" = "t53"."i_item_sk") AS "t54"
INNER JOIN (SELECT "d_date_sk", "d_year"
FROM date_dim) AS "t55" ON "t54"."ws_sold_date_sk" = "t55"."d_date_sk") AS "t56"
LEFT JOIN (SELECT "wr_item_sk", "wr_order_number", "wr_return_quantity", "wr_return_amt", "wr_return_quantity" AS "CAST", "wr_return_amt" AS "CAST5"
FROM web_returns) AS "t57" ON "t56"."ws_order_number" = "t57"."wr_order_number" AND "t56"."ws_item_sk" = "t57"."wr_item_sk") AS "t59"
GROUP BY "d_year", "i_brand_id", "i_class_id", "i_category_id", "i_manufact_id"
HAVING "d_year" = 2002 - 1) AS "t62" ON "t30"."i_brand_id" = "t62"."i_brand_id" AND "t30"."i_class_id" = "t62"."i_class_id" AND "t30"."i_category_id" = "t62"."i_category_id" AND "t30"."i_manufact_id" = "t62"."i_manufact_id" AND "t30"."CAST" / "t62"."CAST" < 0.9
ORDER BY "t30"."sales_cnt" - "t62"."sales_cnt", "t30"."sales_amt" - "t62"."sales_amt"
LIMIT 100

