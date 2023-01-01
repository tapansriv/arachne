CREATE TABLE rs_table_79_0 AS SELECT "t7"."ss_ticket_number", "t7"."ss_customer_sk", "t7"."ss_addr_sk", "t7"."s_city", "t7"."ss_coupon_amt", "t7"."ss_net_profit"
FROM (SELECT "t3"."ss_customer_sk", "t3"."ss_hdemo_sk", "t3"."ss_addr_sk", "t3"."ss_ticket_number", "t3"."ss_coupon_amt", "t3"."ss_net_profit", "t6"."s_city"
FROM (SELECT "t"."ss_customer_sk", "t"."ss_hdemo_sk", "t"."ss_addr_sk", "t"."ss_store_sk", "t"."ss_ticket_number", "t"."ss_coupon_amt", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_hdemo_sk", "ss_addr_sk", "ss_store_sk", "ss_ticket_number", "ss_coupon_amt", "ss_net_profit"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_dow" = 1 AND ("d_year" = 1999 OR "d_year" = 1999 + 1 OR "d_year" = 1999 + 2)) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "s_store_sk", "s_city"
FROM store
WHERE "s_number_employees" >= 200 AND "s_number_employees" <= 295) AS "t6" ON "t3"."ss_store_sk" = "t6"."s_store_sk") AS "t7"
INNER JOIN (SELECT "hd_demo_sk"
FROM household_demographics
WHERE "hd_dep_count" = 6 OR "hd_vehicle_count" > 2) AS "t10" ON "t7"."ss_hdemo_sk" = "t10"."hd_demo_sk"
;
SELECT "t2"."c_last_name", "t2"."c_first_name", "t1"."SUBSTRING", "t1"."ss_ticket_number", "t1"."amt", "t1"."profit"
FROM (SELECT "ss_ticket_number", "ss_customer_sk", SUM("ss_coupon_amt") AS "amt", SUM("ss_net_profit") AS "profit", SUBSTRING("s_city" FROM 1 FOR 30) AS "SUBSTRING"
FROM "rs_table_79_0"
GROUP BY "ss_ticket_number", "ss_customer_sk", "ss_addr_sk", "s_city") AS "t1"
INNER JOIN (SELECT "c_customer_sk", "c_first_name", "c_last_name"
FROM customer) AS "t2" ON "t1"."ss_customer_sk" = "t2"."c_customer_sk"
ORDER BY "t2"."c_last_name" NULLS FIRST, "t2"."c_first_name" NULLS FIRST, "t1"."SUBSTRING" NULLS FIRST, "t1"."profit" NULLS FIRST
LIMIT 100
;
