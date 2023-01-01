SELECT "t9"."n_name", SUM("t9"."*") AS "revenue"
FROM (SELECT "t8"."n_name", "t8"."n_regionkey", "t7"."*" AS "*"
FROM (SELECT "t6"."s_nationkey", "t5"."*" AS "*"
FROM (SELECT "t3"."c_nationkey", "t4"."l_suppkey", "t4"."*" AS "*"
FROM (SELECT "t"."c_nationkey", "t2"."o_orderkey"
FROM (SELECT "c_custkey", "c_nationkey"
FROM customer) AS "t"
INNER JOIN (SELECT "o_orderkey", "o_custkey"
FROM orders
WHERE "o_orderdate" >= DATE '1994-01-01' AND "o_orderdate" < DATE '1995-01-01') AS "t2" ON "t"."c_custkey" = "t2"."o_custkey") AS "t3"
INNER JOIN (SELECT "l_orderkey", "l_suppkey", "l_extendedprice" * (1 - "l_discount") AS "*"
FROM lineitem) AS "t4" ON "t3"."o_orderkey" = "t4"."l_orderkey") AS "t5"
INNER JOIN (SELECT "s_suppkey", "s_nationkey"
FROM supplier) AS "t6" ON "t5"."l_suppkey" = "t6"."s_suppkey" AND "t5"."c_nationkey" = "t6"."s_nationkey") AS "t7"
INNER JOIN (SELECT "n_nationkey", "n_name", "n_regionkey"
FROM nation) AS "t8" ON "t7"."s_nationkey" = "t8"."n_nationkey") AS "t9"
INNER JOIN (SELECT "r_regionkey"
FROM region
WHERE "r_name" = 'ASIA') AS "t12" ON "t9"."n_regionkey" = "t12"."r_regionkey"
GROUP BY "t9"."n_name"
ORDER BY SUM("t9"."*") DESC NULLS LAST

;