CREATE TABLE rs_table_79_0 AS SELECT "t3"."ss_customer_sk", "t3"."ss_hdemo_sk", "t3"."ss_addr_sk", "t3"."ss_ticket_number", "t3"."ss_coupon_amt", "t3"."ss_net_profit", "t6"."s_city"
FROM (SELECT "t"."ss_customer_sk", "t"."ss_hdemo_sk", "t"."ss_addr_sk", "t"."ss_store_sk", "t"."ss_ticket_number", "t"."ss_coupon_amt", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_hdemo_sk", "ss_addr_sk", "ss_store_sk", "ss_ticket_number", "ss_coupon_amt", "ss_net_profit"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_dow" = 1 AND ("d_year" = 1999 OR "d_year" = 1999 + 1 OR "d_year" = 1999 + 2)) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "s_store_sk", "s_city"
FROM store
WHERE "s_number_employees" >= 200 AND "s_number_employees" <= 295) AS "t6" ON "t3"."ss_store_sk" = "t6"."s_store_sk"
;
SELECT "t6"."c_last_name", "t6"."c_first_name", "t5"."SUBSTRING", "t5"."ss_ticket_number", "t5"."amt", "t5"."profit"
FROM (SELECT "rs_table_79_0"."ss_ticket_number", "rs_table_79_0"."ss_customer_sk", SUM("rs_table_79_0"."ss_coupon_amt") AS "amt", SUM("rs_table_79_0"."ss_net_profit") AS "profit", SUBSTRING("rs_table_79_0"."s_city" FROM 1 FOR 30) AS "SUBSTRING"
FROM "rs_table_79_0"
INNER JOIN (SELECT "hd_demo_sk"
FROM household_demographics
WHERE "hd_dep_count" = 6 OR "hd_vehicle_count" > 2) AS "t1" ON "rs_table_79_0"."ss_hdemo_sk" = "t1"."hd_demo_sk"
GROUP BY "rs_table_79_0"."ss_ticket_number", "rs_table_79_0"."ss_customer_sk", "rs_table_79_0"."ss_addr_sk", "rs_table_79_0"."s_city") AS "t5"
INNER JOIN (SELECT "c_customer_sk", "c_first_name", "c_last_name"
FROM customer) AS "t6" ON "t5"."ss_customer_sk" = "t6"."c_customer_sk"
ORDER BY "t6"."c_last_name" NULLS FIRST, "t6"."c_first_name" NULLS FIRST, "t5"."SUBSTRING" NULLS FIRST, "t5"."profit" NULLS FIRST
LIMIT 100
;
