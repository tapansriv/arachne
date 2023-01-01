SELECT "i_item_id", SUM("total_sales") AS "total_sales1"
FROM (SELECT *
FROM (SELECT "t13"."i_item_id", SUM("t7"."ss_ext_sales_price") AS "total_sales"
FROM (SELECT "t3"."ss_item_sk", "t3"."ss_ext_sales_price"
FROM (SELECT "t"."ss_item_sk", "t"."ss_addr_sk", "t"."ss_ext_sales_price"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_addr_sk", "ss_ext_sales_price"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 1998 AND "d_moy" = 9) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "ca_address_sk"
FROM tpcds.sf1000.customer_address AS customer_address
WHERE "ca_gmt_offset" = -5) AS "t6" ON "t3"."ss_addr_sk" = "t6"."ca_address_sk") AS "t7"
INNER JOIN (SELECT "item"."i_item_sk", "item"."i_item_id"
FROM tpcds.sf1000.item AS item
INNER JOIN (SELECT "i_item_id"
FROM tpcds.sf1000.item AS item
WHERE "i_category" = 'Music'
GROUP BY "i_item_id") AS "t11" ON "item"."i_item_id" = "t11"."i_item_id") AS "t13" ON "t7"."ss_item_sk" = "t13"."i_item_sk"
GROUP BY "t13"."i_item_id"
UNION ALL
SELECT "t31"."i_item_id", SUM("t25"."cs_ext_sales_price") AS "total_sales"
FROM (SELECT "t21"."cs_item_sk", "t21"."cs_ext_sales_price"
FROM (SELECT "t17"."cs_bill_addr_sk", "t17"."cs_item_sk", "t17"."cs_ext_sales_price"
FROM (SELECT "cs_sold_date_sk", "cs_bill_addr_sk", "cs_item_sk", "cs_ext_sales_price"
FROM tpcds.sf1000.catalog_sales AS catalog_sales) AS "t17"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 1998 AND "d_moy" = 9) AS "t20" ON "t17"."cs_sold_date_sk" = "t20"."d_date_sk") AS "t21"
INNER JOIN (SELECT "ca_address_sk"
FROM tpcds.sf1000.customer_address AS customer_address
WHERE "ca_gmt_offset" = -5) AS "t24" ON "t21"."cs_bill_addr_sk" = "t24"."ca_address_sk") AS "t25"
INNER JOIN (SELECT "item1"."i_item_sk", "item1"."i_item_id"
FROM tpcds.sf1000.item AS "item1"
INNER JOIN (SELECT "i_item_id"
FROM tpcds.sf1000.item AS item
WHERE "i_category" = 'Music'
GROUP BY "i_item_id") AS "t29" ON "item1"."i_item_id" = "t29"."i_item_id") AS "t31" ON "t25"."cs_item_sk" = "t31"."i_item_sk"
GROUP BY "t31"."i_item_id") AS "t"
UNION ALL
SELECT "t50"."i_item_id", SUM("t44"."ws_ext_sales_price") AS "total_sales"
FROM (SELECT "t40"."ws_item_sk", "t40"."ws_ext_sales_price"
FROM (SELECT "t36"."ws_item_sk", "t36"."ws_bill_addr_sk", "t36"."ws_ext_sales_price"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_bill_addr_sk", "ws_ext_sales_price"
FROM tpcds.sf1000.web_sales AS web_sales) AS "t36"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_year" = 1998 AND "d_moy" = 9) AS "t39" ON "t36"."ws_sold_date_sk" = "t39"."d_date_sk") AS "t40"
INNER JOIN (SELECT "ca_address_sk"
FROM tpcds.sf1000.customer_address AS customer_address
WHERE "ca_gmt_offset" = -5) AS "t43" ON "t40"."ws_bill_addr_sk" = "t43"."ca_address_sk") AS "t44"
INNER JOIN (SELECT "item3"."i_item_sk", "item3"."i_item_id"
FROM tpcds.sf1000.item AS "item3"
INNER JOIN (SELECT "i_item_id"
FROM tpcds.sf1000.item AS item
WHERE "i_category" = 'Music'
GROUP BY "i_item_id") AS "t48" ON "item3"."i_item_id" = "t48"."i_item_id") AS "t50" ON "t44"."ws_item_sk" = "t50"."i_item_sk"
GROUP BY "t50"."i_item_id") AS "t54"
GROUP BY "i_item_id"
ORDER BY "i_item_id" IS NULL, "i_item_id", SUM("total_sales") IS NULL, SUM("total_sales")
LIMIT 100

