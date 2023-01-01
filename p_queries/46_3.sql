CREATE TABLE duck_table_46_0 AS SELECT "t11"."ss_ticket_number", "t11"."ss_customer_sk", "t12"."ca_city" AS "bought_city", SUM("t11"."ss_coupon_amt") AS "amt", SUM("t11"."ss_net_profit") AS "profit"
FROM (SELECT "t7"."ss_customer_sk", "t7"."ss_addr_sk", "t7"."ss_ticket_number", "t7"."ss_coupon_amt", "t7"."ss_net_profit"
FROM (SELECT "t3"."ss_customer_sk", "t3"."ss_hdemo_sk", "t3"."ss_addr_sk", "t3"."ss_ticket_number", "t3"."ss_coupon_amt", "t3"."ss_net_profit"
FROM (SELECT "t"."ss_customer_sk", "t"."ss_hdemo_sk", "t"."ss_addr_sk", "t"."ss_store_sk", "t"."ss_ticket_number", "t"."ss_coupon_amt", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_hdemo_sk", "ss_addr_sk", "ss_store_sk", "ss_ticket_number", "ss_coupon_amt", "ss_net_profit"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_dow" IN (0, 6) AND ("d_year" = 1999 OR "d_year" = 1999 + 1 OR "d_year" = 1999 + 2)) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "s_store_sk"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store
WHERE "s_city" IN ('Fairview', 'Midway')) AS "t6" ON "t3"."ss_store_sk" = "t6"."s_store_sk") AS "t7"
INNER JOIN (SELECT "hd_demo_sk"
FROM '/mnt/disks/tpcds/parquet/household_demographics.parquet' AS household_demographics
WHERE "hd_dep_count" = 4 OR "hd_vehicle_count" = 3) AS "t10" ON "t7"."ss_hdemo_sk" = "t10"."hd_demo_sk") AS "t11"
INNER JOIN (SELECT "ca_address_sk", "ca_city"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address) AS "t12" ON "t11"."ss_addr_sk" = "t12"."ca_address_sk"
GROUP BY "t11"."ss_ticket_number", "t11"."ss_customer_sk", "t11"."ss_addr_sk", "t12"."ca_city";
SELECT "t0"."c_last_name", "t0"."c_first_name", "t1"."ca_city", "t0"."bought_city", "t0"."ss_ticket_number", "t0"."amt", "t0"."profit"
FROM (SELECT "duck_table_46_0"."ss_ticket_number", "duck_table_46_0"."bought_city", "duck_table_46_0"."amt", "duck_table_46_0"."profit", "t"."c_current_addr_sk", "t"."c_first_name", "t"."c_last_name"
FROM "duck_table_46_0"
INNER JOIN (SELECT "c_customer_sk", "c_current_addr_sk", "c_first_name", "c_last_name"
FROM '/mnt/disks/tpcds/parquet/customer.parquet' AS customer) AS "t" ON "duck_table_46_0"."ss_customer_sk" = "t"."c_customer_sk") AS "t0"
INNER JOIN (SELECT "ca_address_sk", "ca_city"
FROM '/mnt/disks/tpcds/parquet/customer_address.parquet' AS customer_address) AS "t1" ON "t0"."c_current_addr_sk" = "t1"."ca_address_sk" AND "t1"."ca_city" <> "t0"."bought_city"
ORDER BY "t0"."c_last_name" NULLS FIRST, "t0"."c_first_name" NULLS FIRST, "t1"."ca_city" NULLS FIRST, "t0"."bought_city" NULLS FIRST, "t0"."ss_ticket_number" NULLS FIRST
FETCH NEXT 100 ROWS ONLY;
