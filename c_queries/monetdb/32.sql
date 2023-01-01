SELECT SUM("t11"."cs_ext_discount_amt") AS "excess discount amount"
FROM (SELECT "t7"."cs_sold_date_sk", "t7"."cs_ext_discount_amt"
FROM (SELECT "$cor0"."cs_sold_date_sk", "$cor0"."cs_item_sk", "$cor0"."cs_ext_discount_amt"
FROM catalog_sales AS "$cor0",
LATERAL (SELECT CASE COUNT("EXPR$0") WHEN 0 THEN NULL WHEN 1 THEN "EXPR$0" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT 1.3 * AVG("cs_ext_discount_amt") AS "EXPR$0"
FROM (SELECT "catalog_sales0"."cs_sold_date_sk", "catalog_sales0"."cs_item_sk", "catalog_sales0"."cs_ext_discount_amt", "date_dim"."d_date_sk", "date_dim"."d_date"
FROM catalog_sales AS "catalog_sales0",
date_dim) AS "t"
WHERE "t"."cs_item_sk" = "$cor0"."$f0" AND ("t"."d_date" >= DATE '2000-01-27' AND "t"."d_date" <= DATE '2000-04-26') AND "t"."d_date_sk" = "t"."cs_sold_date_sk") AS "t3") AS "t4"
WHERE "$cor0"."cs_ext_discount_amt" > "$cor0"."$f0") AS "t7"
INNER JOIN (SELECT "i_item_sk"
FROM item
WHERE "i_manufact_id" = 977) AS "t10" ON "t7"."cs_item_sk" = "t10"."i_item_sk") AS "t11"
INNER JOIN (SELECT "d_date_sk"
FROM date_dim
WHERE "d_date" >= DATE '2000-01-27' AND "d_date" <= DATE '2000-04-26') AS "t14" ON "t11"."cs_sold_date_sk" = "t14"."d_date_sk"
LIMIT 100
;
