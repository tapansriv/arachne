SELECT "t28"."rnk", "t28"."i_product_name" AS "best_performing", "t29"."i_product_name" AS "worst_performing"
FROM (SELECT "t26"."rnk", "t26"."item_sk0", "t27"."i_product_name"
FROM (SELECT "t11"."item_sk", "t11"."rnk", "t25"."item_sk" AS "item_sk0"
FROM (SELECT *
FROM (SELECT "t9"."item_sk", RANK() OVER (ORDER BY "t9"."rank_col") AS "rnk"
FROM (SELECT "t2"."item_sk", "t2"."rank_col"
FROM (SELECT "ss_item_sk" AS "item_sk", AVG("ss_net_profit") AS "rank_col"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales
WHERE "ss_store_sk" = 4
GROUP BY "ss_item_sk") AS "t2"
LEFT JOIN (SELECT SINGLE_VALUE("rank_col") AS "$f0"
FROM (SELECT AVG("ss_net_profit") AS "rank_col"
FROM (VALUES (NULL, NULL, NULL)) AS "t" ("ss_addr_sk", "ss_store_sk", "ss_net_profit")
WHERE 1 = 0
GROUP BY "ss_store_sk") AS "t6") AS "t7" ON TRUE
WHERE "t2"."rank_col" > 0.9 * "t7"."$f0") AS "t9") AS "t10"
WHERE "rnk" < 11) AS "t11"
INNER JOIN (SELECT *
FROM (SELECT "t22"."item_sk", RANK() OVER (ORDER BY "t22"."rank_col" DESC) AS "rnk"
FROM (SELECT "t15"."item_sk", "t15"."rank_col"
FROM (SELECT "ss_item_sk" AS "item_sk", AVG("ss_net_profit") AS "rank_col"
FROM '/mnt/disks/tpcds/parquet/store_sales.parquet' AS store_sales
WHERE "ss_store_sk" = 4
GROUP BY "ss_item_sk") AS "t15"
LEFT JOIN (SELECT SINGLE_VALUE("rank_col") AS "$f0"
FROM (SELECT AVG("ss_net_profit") AS "rank_col"
FROM (VALUES (NULL, NULL, NULL)) AS "t" ("ss_addr_sk", "ss_store_sk", "ss_net_profit")
WHERE 1 = 0
GROUP BY "ss_store_sk") AS "t19") AS "t20" ON TRUE
WHERE "t15"."rank_col" > 0.9 * "t20"."$f0") AS "t22") AS "t23"
WHERE "rnk" < 11) AS "t25" ON "t11"."rnk" = "t25"."rnk") AS "t26"
INNER JOIN (SELECT "i_item_sk", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t27" ON "t26"."item_sk" = "t27"."i_item_sk") AS "t28"
INNER JOIN (SELECT "i_item_sk", "i_product_name"
FROM '/mnt/disks/tpcds/parquet/item.parquet' AS item) AS "t29" ON "t28"."item_sk0" = "t29"."i_item_sk"
ORDER BY "t28"."rnk"
FETCH NEXT 100 ROWS ONLY

