CREATE TABLE duck_table_79_0 AS SELECT "t7"."ss_ticket_number", "t7"."ss_customer_sk", SUM("t7"."ss_coupon_amt") AS "amt", SUM("t7"."ss_net_profit") AS "profit", SUBSTRING("t7"."s_city" FROM 1 FOR 30) AS "SUBSTRING"
FROM (SELECT "t3"."ss_customer_sk", "t3"."ss_hdemo_sk", "t3"."ss_addr_sk", "t3"."ss_ticket_number", "t3"."ss_coupon_amt", "t3"."ss_net_profit", "t6"."s_city"
FROM (SELECT "t"."ss_customer_sk", "t"."ss_hdemo_sk", "t"."ss_addr_sk", "t"."ss_store_sk", "t"."ss_ticket_number", "t"."ss_coupon_amt", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_hdemo_sk", "ss_addr_sk", "ss_store_sk", "ss_ticket_number", "ss_coupon_amt", "ss_net_profit"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM '/mnt/disks/tpcds/parquet/date_dim.parquet' AS date_dim
WHERE "d_dow" = 1 AND ("d_year" = 1999 OR "d_year" = 1999 + 1 OR "d_year" = 1999 + 2)) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "s_store_sk", "s_city"
FROM '/mnt/disks/tpcds/parquet/store.parquet' AS store
WHERE "s_number_employees" >= 200 AND "s_number_employees" <= 295) AS "t6" ON "t3"."ss_store_sk" = "t6"."s_store_sk") AS "t7"
INNER JOIN (SELECT "hd_demo_sk"
FROM '/mnt/disks/tpcds/parquet/household_demographics.parquet' AS household_demographics
WHERE "hd_dep_count" = 6 OR "hd_vehicle_count" > 2) AS "t10" ON "t7"."ss_hdemo_sk" = "t10"."hd_demo_sk"
GROUP BY "t7"."ss_ticket_number", "t7"."ss_customer_sk", "t7"."ss_addr_sk", "t7"."s_city";
SELECT "t"."c_last_name", "t"."c_first_name", "duck_table_79_0"."SUBSTRING", "duck_table_79_0"."ss_ticket_number", "duck_table_79_0"."amt", "duck_table_79_0"."profit"
FROM "duck_table_79_0"
INNER JOIN (SELECT "c_customer_sk", "c_first_name", "c_last_name"
FROM '/mnt/disks/tpcds/parquet/customer.parquet' AS customer) AS "t" ON "duck_table_79_0"."ss_customer_sk" = "t"."c_customer_sk"
ORDER BY "t"."c_last_name" NULLS FIRST, "t"."c_first_name" NULLS FIRST, "duck_table_79_0"."SUBSTRING" NULLS FIRST, "duck_table_79_0"."profit" NULLS FIRST
FETCH NEXT 100 ROWS ONLY;
