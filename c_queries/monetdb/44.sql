SELECT "t29"."rnk", "t29"."i_product_name" AS "best_performing", "t30"."i_product_name" AS "worst_performing"
FROM (SELECT "t27"."rnk", "t27"."item_sk0", "t28"."i_product_name"
FROM (SELECT "t12"."item_sk", "t12"."rnk", "t26"."item_sk" AS "item_sk0"
FROM (SELECT *
FROM (SELECT "t9"."item_sk", RANK() OVER (ORDER BY "t9"."rank_col" IS NULL, "t9"."rank_col") AS "rnk"
FROM (SELECT "t2"."item_sk", "t2"."rank_col"
FROM (SELECT "ss_item_sk" AS "item_sk", AVG("ss_net_profit") AS "rank_col"
FROM store_sales
WHERE "ss_store_sk" = 4
GROUP BY "ss_item_sk") AS "t2"
LEFT JOIN (SELECT CASE COUNT("rank_col") WHEN 0 THEN NULL WHEN 1 THEN "rank_col" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("ss_net_profit") AS "rank_col"
FROM (SELECT NULL AS "ss_addr_sk", NULL AS "ss_store_sk", NULL AS "ss_net_profit") AS "t"
WHERE 1 = 0
GROUP BY "ss_store_sk") AS "t6") AS "t7" ON TRUE
WHERE "t2"."rank_col" > 0.9 * "t7"."$f0") AS "t9") AS "t10"
WHERE "rnk" < 11) AS "t12"
INNER JOIN (SELECT *
FROM (SELECT "t23"."item_sk", RANK() OVER (ORDER BY "t23"."rank_col" IS NULL DESC, "t23"."rank_col" DESC) AS "rnk"
FROM (SELECT "t16"."item_sk", "t16"."rank_col"
FROM (SELECT "ss_item_sk" AS "item_sk", AVG("ss_net_profit") AS "rank_col"
FROM store_sales
WHERE "ss_store_sk" = 4
GROUP BY "ss_item_sk") AS "t16"
LEFT JOIN (SELECT CASE COUNT("rank_col") WHEN 0 THEN NULL WHEN 1 THEN "rank_col" ELSE (SELECT NULL
UNION ALL
SELECT NULL) END AS "$f0"
FROM (SELECT AVG("ss_net_profit") AS "rank_col"
FROM (SELECT NULL AS "ss_addr_sk", NULL AS "ss_store_sk", NULL AS "ss_net_profit") AS "t"
WHERE 1 = 0
GROUP BY "ss_store_sk") AS "t20") AS "t21" ON TRUE
WHERE "t16"."rank_col" > 0.9 * "t21"."$f0") AS "t23") AS "t24"
WHERE "rnk" < 11) AS "t26" ON "t12"."rnk" = "t26"."rnk") AS "t27"
INNER JOIN (SELECT "i_item_sk", "i_product_name"
FROM item) AS "t28" ON "t27"."item_sk" = "t28"."i_item_sk") AS "t29"
INNER JOIN (SELECT "i_item_sk", "i_product_name"
FROM item) AS "t30" ON "t29"."item_sk0" = "t30"."i_item_sk"
ORDER BY "t29"."rnk" IS NULL, "t29"."rnk"
LIMIT 100
;
