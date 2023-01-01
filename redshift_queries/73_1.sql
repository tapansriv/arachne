CREATE TABLE rs_table_73_0 AS SELECT "t7"."ss_ticket_number", "t7"."ss_customer_sk", COUNT(*) AS "cnt"
FROM (SELECT "t3"."ss_customer_sk", "t3"."ss_hdemo_sk", "t3"."ss_ticket_number"
FROM (SELECT "t"."ss_customer_sk", "t"."ss_hdemo_sk", "t"."ss_store_sk", "t"."ss_ticket_number"
FROM (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_hdemo_sk", "ss_store_sk", "ss_ticket_number"
FROM store_sales) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_dom" >= 1 AND "d_dom" <= 2 AND ("d_year" = 1999 OR "d_year" = 1999 + 1 OR "d_year" = 1999 + 2)) AS "t2" ON "t"."ss_sold_date_sk" = "t2"."d_date_sk") AS "t3"
INNER JOIN (SELECT "s_store_sk"
FROM store
WHERE "s_county" IN ('Bronx County', 'Franklin Parish', 'Orange County', 'Williamson County')) AS "t6" ON "t3"."ss_store_sk" = "t6"."s_store_sk") AS "t7"
INNER JOIN (SELECT "hd_demo_sk"
FROM household_demographics
WHERE "hd_buy_potential" IN ('>10000', 'Unknown') AND "hd_vehicle_count" > 0 AND CASE WHEN "hd_vehicle_count" > 0 THEN "hd_dep_count" * 1.000 / "hd_vehicle_count" ELSE NULL END > 1) AS "t10" ON "t7"."ss_hdemo_sk" = "t10"."hd_demo_sk"
GROUP BY "t7"."ss_ticket_number", "t7"."ss_customer_sk"
HAVING COUNT(*) >= 1 AND COUNT(*) <= 5
;
SELECT "t"."c_last_name", "t"."c_first_name", "t"."c_salutation", "t"."c_preferred_cust_flag", "rs_table_73_0"."ss_ticket_number", "rs_table_73_0"."cnt"
FROM "rs_table_73_0"
INNER JOIN (SELECT "c_customer_sk", "c_salutation", "c_first_name", "c_last_name", "c_preferred_cust_flag"
FROM customer) AS "t" ON "rs_table_73_0"."ss_customer_sk" = "t"."c_customer_sk"
ORDER BY "rs_table_73_0"."cnt" DESC NULLS LAST, "t"."c_last_name"
;
