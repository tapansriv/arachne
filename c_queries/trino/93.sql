SELECT "t1"."ss_customer_sk", SUM("t1"."CASE") AS "sumsales"
FROM (SELECT "t"."ss_customer_sk", "t0"."sr_reason_sk", CASE WHEN "t0"."sr_return_quantity" IS NOT NULL THEN ("t"."ss_quantity" - "t0"."sr_return_quantity") * "t"."ss_sales_price" ELSE "t"."""*""" END AS "CASE"
FROM (SELECT "ss_item_sk", "ss_customer_sk", "ss_ticket_number", "ss_quantity", "ss_sales_price", "ss_quantity" * "ss_sales_price" AS "*"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t"
LEFT JOIN (SELECT "sr_item_sk", "sr_reason_sk", "sr_ticket_number", "sr_return_quantity"
FROM tpcds.sf1000.store_returns AS store_returns) AS "t0" ON "t"."ss_item_sk" = "t0"."sr_item_sk" AND "t"."ss_ticket_number" = "t0"."sr_ticket_number") AS "t1"
INNER JOIN (SELECT "r_reason_sk"
FROM tpcds.sf1000.reason AS reason
WHERE "r_reason_desc" = 'reason 28') AS "t4" ON "t1"."sr_reason_sk" = "t4"."r_reason_sk"
GROUP BY "t1"."ss_customer_sk"
ORDER BY SUM("t1"."CASE"), "t1"."ss_customer_sk"
LIMIT 100

