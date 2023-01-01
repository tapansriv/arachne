SELECT "t22"."c_customer_id"
FROM (SELECT "t17"."ctr_customer_sk"
FROM (SELECT "$cor0"."ctr_customer_sk", "$cor0"."ctr_store_sk"
FROM (SELECT "t"."sr_customer_sk" AS "ctr_customer_sk", "t"."sr_store_sk" AS "ctr_store_sk", SUM("t"."sr_return_amt") AS "ctr_total_return"
FROM (SELECT "sr_returned_date_sk", "sr_customer_sk", "sr_store_sk", "sr_return_amt"
FROM store_returns) AS "t"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_year" = 2000) AS "t2" ON "t"."sr_returned_date_sk" = "t2"."d_date_sk"
GROUP BY "t"."sr_customer_sk", "t"."sr_store_sk") AS "$cor0",
LATERAL (SELECT SINGLE_VALUE("EXPR$0") AS "$f0"
FROM (SELECT AVG("ctr_total_return") * 1.2 AS "EXPR$0"
FROM (SELECT "store_returns0"."sr_store_sk" AS "ctr_store_sk", SUM("store_returns0"."sr_return_amt") AS "ctr_total_return"
FROM store_returns AS "store_returns0",
date_dim AS "date_dim0"
WHERE "store_returns0"."sr_returned_date_sk" = "date_dim0"."d_date_sk" AND "date_dim0"."d_year" = 2000
GROUP BY "store_returns0"."sr_customer_sk", "store_returns0"."sr_store_sk") AS "t9"
WHERE "$cor0"."ctr_store_sk" = "t9"."ctr_store_sk") AS "t13") AS "t14"
WHERE "$cor0"."ctr_total_return" > "$cor0"."$f0") AS "t17"
INNER JOIN (SELECT "s_store_sk"
FROM store
WHERE "s_state" = 'TN') AS "t20" ON "t17"."ctr_store_sk" = "t20"."s_store_sk") AS "t21"
INNER JOIN (SELECT "c_customer_sk", "c_customer_id"
FROM customer) AS "t22" ON "t21"."ctr_customer_sk" = "t22"."c_customer_sk"
ORDER BY "t22"."c_customer_id"
FETCH NEXT 100 ROWS ONLY

