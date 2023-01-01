SELECT "t15"."c_last_name", "t15"."c_first_name", "t14"."SUBSTRING", "t14"."ss_ticket_number", "t14"."amt", "t14"."profit"
FROM (SELECT "t7"."ss_ticket_number", "t7"."ss_customer_sk", SUM("t7"."ss_coupon_amt") AS "amt", SUM("t7"."ss_net_profit") AS "profit", SUBSTR("t7"."s_city", 1, 30) AS "SUBSTRING"
FROM (SELECT "t3"."ss_customer_sk", "t3"."ss_hdemo_sk", "t3"."ss_addr_sk", "t3"."ss_ticket_number", "t3"."ss_coupon_amt", "t3"."ss_net_profit", "t6"."s_city"
FROM (SELECT "t"."ss_customer_sk", "t"."ss_hdemo_sk", "t"."ss_addr_sk", "t"."ss_store_sk", "t"."ss_ticket_number", "t"."ss_coupon_amt", "t"."ss_net_profit"
FROM (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_hdemo_sk", "ss_addr_sk", "ss_store_sk", "ss_ticket_number", "ss_coupon_amt", "ss_net_profit"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM tpcds.sf1000.date_dim AS date_dim
WHERE "d_dow" = 1 AND ("d_year" = 1999 OR "d_year" = 1999 + 1 OR "d_year" = 1999 + 2)) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "s_store_sk", "s_city"
FROM tpcds.sf1000.store AS store
WHERE "s_number_employees" >= 200 AND "s_number_employees" <= 295) AS "t6" ON "t3"."ss_store_sk" = "t6"."s_store_sk") AS "t7"
INNER JOIN (SELECT "hd_demo_sk"
FROM tpcds.sf1000.household_demographics AS household_demographics
WHERE "hd_dep_count" = 6 OR "hd_vehicle_count" > 2) AS "t10" ON "t7"."ss_hdemo_sk" = "t10"."hd_demo_sk"
GROUP BY "t7"."ss_ticket_number", "t7"."ss_customer_sk", "t7"."ss_addr_sk", "t7"."s_city") AS "t14"
INNER JOIN (SELECT "c_customer_sk", "c_first_name", "c_last_name"
FROM tpcds.sf1000.customer AS customer) AS "t15" ON "t14"."ss_customer_sk" = "t15"."c_customer_sk"
ORDER BY "t15"."c_last_name", "t15"."c_first_name", "t14"."SUBSTRING", "t14"."profit"
LIMIT 100

