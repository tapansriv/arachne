SELECT SUM("t11"."ws_ext_discount_amt") AS "Excess Discount Amount"
FROM (SELECT "t7"."ws_sold_date_sk", "t7"."ws_ext_discount_amt"
FROM (SELECT "$cor0"."ws_sold_date_sk", "$cor0"."ws_item_sk", "$cor0"."ws_ext_discount_amt"
FROM web_sales AS "$cor0",
LATERAL (SELECT CASE COUNT("EXPR$0") WHEN 0 THEN NULL WHEN 1 THEN "EXPR$0" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT 1.3 * AVG("ws_ext_discount_amt") AS "EXPR$0"
FROM (SELECT "web_sales0"."ws_sold_date_sk", "web_sales0"."ws_item_sk", "web_sales0"."ws_ext_discount_amt", "date_dim"."d_date_sk", "date_dim"."d_date"
FROM web_sales AS "web_sales0",
date_dim) AS "t"
WHERE "t"."ws_item_sk" = "$cor0"."$f0" AND ("t"."d_date" >= DATE '2000-01-27' AND "t"."d_date" <= DATE '2000-04-26') AND "t"."d_date_sk" = "t"."ws_sold_date_sk") AS "t3") AS "t4"
WHERE "$cor0"."ws_ext_discount_amt" > "$cor0"."$f0") AS "t7"
INNER JOIN (SELECT "i_item_sk"
FROM item
WHERE "i_manufact_id" = 350) AS "t10" ON "t7"."ws_item_sk" = "t10"."i_item_sk") AS "t11"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-01-27' AND "d_date" <= DATE '2000-04-26') AS "t14" ON "t11"."ws_sold_date_sk" = "t14"."d_date_sk"
ORDER BY SUM("t11"."ws_ext_discount_amt") IS NULL, SUM("t11"."ws_ext_discount_amt")
LIMIT 100
;
