SELECT "t9"."n_name" AS "nation", "t8"."EXTRACT" AS "o_year", SUM("t8"."-") AS "sum_profit"
FROM (SELECT "t6"."s_nationkey", "t7"."EXTRACT", "t6"."-"
FROM (SELECT "t4"."s_nationkey", "t4"."l_orderkey", "t4"."*" - "t5"."ps_supplycost" * "t4"."l_quantity" AS "-"
FROM (SELECT "t2"."s_nationkey", "t3"."l_orderkey", "t3"."l_partkey", "t3"."l_suppkey", "t3"."l_quantity", "t3"."*" AS "*"
FROM (SELECT "p_partkey"
FROM part
WHERE "p_name" LIKE '%green%') AS "t1",
(SELECT "s_suppkey", "s_nationkey"
FROM supplier) AS "t2"
INNER JOIN (SELECT "l_orderkey", "l_partkey", "l_suppkey", "l_quantity", "l_extendedprice" * (1 - "l_discount") AS "*"
FROM lineitem) AS "t3" ON "t2"."s_suppkey" = "t3"."l_suppkey" AND "t1"."p_partkey" = "t3"."l_partkey") AS "t4"
INNER JOIN (SELECT "ps_partkey", "ps_suppkey", "ps_supplycost"
FROM partsupp) AS "t5" ON "t4"."l_suppkey" = "t5"."ps_suppkey" AND "t4"."l_partkey" = "t5"."ps_partkey") AS "t6"
INNER JOIN (SELECT "o_orderkey", EXTRACT(YEAR FROM "o_orderdate") AS "EXTRACT"
FROM orders) AS "t7" ON "t6"."l_orderkey" = "t7"."o_orderkey") AS "t8"
INNER JOIN (SELECT "n_nationkey", "n_name"
FROM nation) AS "t9" ON "t8"."s_nationkey" = "t9"."n_nationkey"
GROUP BY "t9"."n_name", "t8"."EXTRACT"
ORDER BY "t9"."n_name", "t8"."EXTRACT" DESC NULLS LAST

;