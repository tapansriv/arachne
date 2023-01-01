SELECT "t30"."SEGMENT", COUNT(*) AS "num_customers", "t30"."SEGMENT" * 50 AS "segment_base"
FROM (SELECT CAST(ROUND(SUM("t14"."ss_ext_sales_price") / 50) AS SIGNED) AS "SEGMENT"
FROM (SELECT "t12"."c_customer_sk", "t12"."ss_sold_date_sk", "t12"."ss_ext_sales_price"
FROM (SELECT "t10"."c_customer_sk", "t10"."ss_sold_date_sk", "t10"."ss_ext_sales_price", "t11"."ca_county", "t11"."ca_state"
FROM (SELECT "t8"."c_customer_sk", "t8"."c_current_addr_sk", "t9"."ss_sold_date_sk", "t9"."ss_ext_sales_price"
FROM (SELECT "c_customer_sk", "c_current_addr_sk"
FROM (SELECT *
FROM (SELECT "cs_sold_date_sk" AS "sold_date_sk", "cs_bill_customer_sk" AS "customer_sk", "cs_item_sk" AS "item_sk"
FROM catalog_sales) AS "t"
INNER JOIN (SELECT *
FROM item
WHERE "i_category" = 'Women' AND "i_class" = 'maternity') AS "t0" ON "t"."item_sk" = "t0"."i_item_sk"
INNER JOIN (SELECT *
FROM date_dim
WHERE "d_moy" = 12 AND "d_year" = 1998) AS "t1" ON "t"."sold_date_sk" = "t1"."d_date_sk"
INNER JOIN customer ON "t"."customer_sk" = "customer"."c_customer_sk"
UNION ALL
SELECT *
FROM (SELECT "ws_sold_date_sk" AS "sold_date_sk", "ws_bill_customer_sk" AS "customer_sk", "ws_item_sk" AS "item_sk"
FROM web_sales) AS "t2"
INNER JOIN (SELECT *
FROM item
WHERE "i_category" = 'Women' AND "i_class" = 'maternity') AS "t3" ON "t2"."item_sk" = "t3"."i_item_sk"
INNER JOIN (SELECT *
FROM date_dim
WHERE "d_moy" = 12 AND "d_year" = 1998) AS "t4" ON "t2"."sold_date_sk" = "t4"."d_date_sk"
INNER JOIN customer AS "customer0" ON "t2"."customer_sk" = "customer0"."c_customer_sk") AS "t5"
GROUP BY "c_customer_sk", "c_current_addr_sk") AS "t8"
INNER JOIN (SELECT "ss_sold_date_sk", "ss_customer_sk", "ss_ext_sales_price"
FROM store_sales) AS "t9" ON "t8"."c_customer_sk" = "t9"."ss_customer_sk") AS "t10"
INNER JOIN (SELECT "ca_address_sk", "ca_county", "ca_state"
FROM customer_address) AS "t11" ON "t10"."c_current_addr_sk" = "t11"."ca_address_sk") AS "t12"
INNER JOIN (SELECT "s_county", "s_state"
FROM store) AS "t13" ON "t12"."ca_county" = "t13"."s_county" AND "t12"."ca_state" = "t13"."s_state") AS "t14"
INNER JOIN (SELECT "date_dim1"."d_date_sk"
FROM date_dim AS "date_dim1"
LEFT JOIN (SELECT CASE COUNT("EXPR$0") WHEN 0 THEN NULL WHEN 1 THEN "EXPR$0" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT "d_month_seq" + 1 AS "EXPR$0"
FROM date_dim
WHERE "d_moy" = 12 AND "d_year" = 1998
GROUP BY "d_month_seq" + 1) AS "t18") AS "t19" ON TRUE
LEFT JOIN (SELECT CASE COUNT("EXPR$0") WHEN 0 THEN NULL WHEN 1 THEN "EXPR$0" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT "d_month_seq" + 3 AS "EXPR$0"
FROM date_dim
WHERE "d_moy" = 12 AND "d_year" = 1998
GROUP BY "d_month_seq" + 3) AS "t23") AS "t24" ON TRUE
WHERE "date_dim1"."d_month_seq" >= "t19"."$f0" AND "date_dim1"."d_month_seq" <= "t24"."$f0") AS "t27" ON "t14"."ss_sold_date_sk" = "t27"."d_date_sk"
GROUP BY "t14"."c_customer_sk") AS "t30"
GROUP BY "t30"."SEGMENT"
ORDER BY "t30"."SEGMENT", COUNT(*), "t30"."SEGMENT" * 50 IS NULL, "t30"."SEGMENT" * 50
LIMIT 100
;
