SELECT "t17"."c_last_name", "t17"."c_first_name", "t18"."ca_city", "t17"."bought_city", "t17"."ss_ticket_number", "t17"."extended_price", "t17"."extended_tax", "t17"."list_price"
FROM (SELECT "t15"."ss_ticket_number", "t15"."bought_city", "t15"."extended_price", "t15"."list_price", "t15"."extended_tax", "t16"."c_current_addr_sk", "t16"."c_first_name", "t16"."c_last_name"
FROM (SELECT "t11"."ss_ticket_number", "t11"."ss_customer_sk", "t12"."ca_city" AS "bought_city", SUM("t11"."ss_ext_sales_price") AS "extended_price", SUM("t11"."ss_ext_list_price") AS "list_price", SUM("t11"."ss_ext_tax") AS "extended_tax"
FROM (SELECT "t7"."ss_customer_sk", "t7"."ss_addr_sk", "t7"."ss_ticket_number", "t7"."ss_ext_sales_price", "t7"."ss_ext_list_price", "t7"."ss_ext_tax"
FROM (SELECT "t3"."ss_customer_sk", "t3"."ss_hdemo_sk", "t3"."ss_addr_sk", "t3"."ss_ticket_number", "t3"."ss_ext_sales_price", "t3"."ss_ext_list_price", "t3"."ss_ext_tax"
FROM (SELECT "t"."ss_customer_sk", "t"."ss_hdemo_sk", "t"."ss_addr_sk", "t"."ss_store_sk", "t"."ss_ticket_number", "t"."ss_ext_sales_price", "t"."ss_ext_list_price", "t"."ss_ext_tax"
FROM (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_hdemo_sk", "ss_addr_sk", "ss_store_sk", "ss_ticket_number", "ss_ext_sales_price", "ss_ext_list_price", "ss_ext_tax"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_dom" >= 1 AND "d_dom" <= 2 AND ("d_year" = 1999 OR "d_year" = 1999 + 1 OR "d_year" = 1999 + 2)) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "s_store_sk"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store
WHERE "s_city" IN ('Fairview', 'Midway')) AS "t6" ON "t3"."ss_store_sk" = "t6"."s_store_sk") AS "t7"
INNER JOIN (SELECT "hd_demo_sk"
FROM '/mnt/disks/tpcds/parquet/household_demographics.parquet' AS household_demographics
WHERE "hd_dep_count" = 4 OR "hd_vehicle_count" = 3) AS "t10" ON "t7"."ss_hdemo_sk" = "t10"."hd_demo_sk") AS "t11"
INNER JOIN (SELECT "ca_address_sk", "ca_city"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address) AS "t12" ON "t11"."ss_addr_sk" = "t12"."ca_address_sk"
GROUP BY "t11"."ss_ticket_number", "t11"."ss_customer_sk", "t11"."ss_addr_sk", "t12"."ca_city") AS "t15"
INNER JOIN (SELECT "c_customer_sk", "c_current_addr_sk", "c_first_name", "c_last_name"
FROM '/mnt/disks/tpcds/parquet/customer.parquet' AS customer) AS "t16" ON "t15"."ss_customer_sk" = "t16"."c_customer_sk") AS "t17"
INNER JOIN (SELECT "ca_address_sk", "ca_city"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address) AS "t18" ON "t17"."c_current_addr_sk" = "t18"."ca_address_sk" AND "t18"."ca_city" <> "t17"."bought_city"
ORDER BY "t17"."c_last_name" NULLS FIRST, "t17"."ss_ticket_number" NULLS FIRST
FETCH NEXT 100 ROWS ONLY

