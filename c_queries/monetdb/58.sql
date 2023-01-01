SELECT "t31"."item_id", "t31"."ss_item_rev", "t31"."ss_item_rev" / (("t31"."+" + "t47"."ws_item_rev") / 3) * 100 AS "ss_dev", "t31"."cs_item_rev", "t31"."cs_item_rev" / (("t31"."+" + "t47"."ws_item_rev") / 3) * 100 AS "cs_dev", "t47"."ws_item_rev", "t47"."ws_item_rev" / (("t31"."+" + "t47"."ws_item_rev") / 3) * 100 AS "ws_dev", ("t31"."+" + "t47"."ws_item_rev") / 3 AS "average"
FROM (SELECT "t14"."item_id", "t14"."ss_item_rev", "t30"."cs_item_rev", "t14"."ss_item_rev" + "t30"."cs_item_rev" AS "+", "t14"."*" AS "*", "t14"."*3" AS "*5", "t30"."*" AS "*6", "t30"."*3" AS "*7"
FROM (SELECT "t1"."i_item_id" AS "item_id", SUM("t1"."ss_ext_sales_price") AS "ss_item_rev", 0.9 * SUM("t1"."ss_ext_sales_price") AS "*", 1.1 * SUM("t1"."ss_ext_sales_price") AS "*3"
FROM (SELECT "t"."ss_sold_date_sk", "t"."ss_ext_sales_price", "t0"."i_item_id"
FROM (SELECT "ss_sold_date_sk", "ss_item_sk", "ss_ext_sales_price"
FROM store_sales) AS "t"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t0" ON "t"."ss_item_sk" = "t0"."i_item_sk") AS "t1"
INNER JOIN (SELECT "date_dim"."d_date_sk"
FROM date_dim
INNER JOIN (SELECT "date_dim0"."d_date"
FROM date_dim AS "date_dim0"
LEFT JOIN (SELECT CASE COUNT("d_week_seq") WHEN 0 THEN NULL WHEN 1 THEN "d_week_seq" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM date_dim
WHERE "d_date" = DATE '2000-01-03') AS "t5" ON TRUE
WHERE "date_dim0"."d_week_seq" = "t5"."$f0"
GROUP BY "date_dim0"."d_date") AS "t9" ON "date_dim"."d_date" = "t9"."d_date") AS "t11" ON "t1"."ss_sold_date_sk" = "t11"."d_date_sk"
GROUP BY "t1"."i_item_id") AS "t14"
INNER JOIN (SELECT "t17"."i_item_id" AS "item_id", SUM("t17"."cs_ext_sales_price") AS "cs_item_rev", 0.9 * SUM("t17"."cs_ext_sales_price") AS "*", 1.1 * SUM("t17"."cs_ext_sales_price") AS "*3"
FROM (SELECT "t15"."cs_sold_date_sk", "t15"."cs_ext_sales_price", "t16"."i_item_id"
FROM (SELECT "cs_sold_date_sk", "cs_item_sk", "cs_ext_sales_price"
FROM catalog_sales) AS "t15"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t16" ON "t15"."cs_item_sk" = "t16"."i_item_sk") AS "t17"
INNER JOIN (SELECT "date_dim2"."d_date_sk"
FROM date_dim AS "date_dim2"
INNER JOIN (SELECT "date_dim3"."d_date"
FROM date_dim AS "date_dim3"
LEFT JOIN (SELECT CASE COUNT("d_week_seq") WHEN 0 THEN NULL WHEN 1 THEN "d_week_seq" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM date_dim
WHERE "d_date" = DATE '2000-01-03') AS "t21" ON TRUE
WHERE "date_dim3"."d_week_seq" = "t21"."$f0"
GROUP BY "date_dim3"."d_date") AS "t25" ON "date_dim2"."d_date" = "t25"."d_date") AS "t27" ON "t17"."cs_sold_date_sk" = "t27"."d_date_sk"
GROUP BY "t17"."i_item_id") AS "t30" ON "t14"."item_id" = "t30"."item_id" AND "t14"."ss_item_rev" >= "t30"."*" AND "t14"."ss_item_rev" <= "t30"."*3" AND "t14"."*" <= "t30"."cs_item_rev" AND "t14"."*3" >= "t30"."cs_item_rev") AS "t31"
INNER JOIN (SELECT "t34"."i_item_id" AS "item_id", SUM("t34"."ws_ext_sales_price") AS "ws_item_rev", 0.9 * SUM("t34"."ws_ext_sales_price") AS "*", 1.1 * SUM("t34"."ws_ext_sales_price") AS "*3"
FROM (SELECT "t32"."ws_sold_date_sk", "t32"."ws_ext_sales_price", "t33"."i_item_id"
FROM (SELECT "ws_sold_date_sk", "ws_item_sk", "ws_ext_sales_price"
FROM web_sales) AS "t32"
INNER JOIN (SELECT "i_item_sk", "i_item_id"
FROM item) AS "t33" ON "t32"."ws_item_sk" = "t33"."i_item_sk") AS "t34"
INNER JOIN (SELECT "date_dim5"."d_date_sk"
FROM date_dim AS "date_dim5"
INNER JOIN (SELECT "date_dim6"."d_date"
FROM date_dim AS "date_dim6"
LEFT JOIN (SELECT CASE COUNT("d_week_seq") WHEN 0 THEN NULL WHEN 1 THEN "d_week_seq" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM date_dim
WHERE "d_date" = DATE '2000-01-03') AS "t38" ON TRUE
WHERE "date_dim6"."d_week_seq" = "t38"."$f0"
GROUP BY "date_dim6"."d_date") AS "t42" ON "date_dim5"."d_date" = "t42"."d_date") AS "t44" ON "t34"."ws_sold_date_sk" = "t44"."d_date_sk"
GROUP BY "t34"."i_item_id") AS "t47" ON "t31"."item_id" = "t47"."item_id" AND "t31"."ss_item_rev" >= "t47"."*" AND ("t31"."ss_item_rev" <= "t47"."*3" AND "t31"."cs_item_rev" >= "t47"."*") AND ("t31"."cs_item_rev" <= "t47"."*3" AND "t31"."*" <= "t47"."ws_item_rev" AND ("t31"."*5" >= "t47"."ws_item_rev" AND ("t31"."*6" <= "t47"."ws_item_rev" AND "t31"."*7" >= "t47"."ws_item_rev")))
ORDER BY "t31"."item_id", "t31"."ss_item_rev"
LIMIT 100
;
