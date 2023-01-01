SELECT "t9"."n_name" AS "supp_nation", "t10"."n_name" AS "cust_nation", "t9"."EXTRACT" AS "l_year", SUM("t9"."*") AS "revenue"
FROM (SELECT "t7"."c_nationkey", "t8"."n_name", "t7"."EXTRACT", "t7"."*" AS "*", "t8"."=", "t8"."=3" AS "=5"
FROM (SELECT "t5"."s_nationkey", "t6"."c_nationkey", "t5"."EXTRACT", "t5"."*" AS "*"
FROM (SELECT "t3"."s_nationkey", "t4"."o_custkey", "t3"."EXTRACT", "t3"."*" AS "*"
FROM (SELECT "t"."s_nationkey", "t2"."l_orderkey", "t2"."EXTRACT", "t2"."*" AS "*"
FROM (SELECT "s_suppkey", "s_nationkey"
FROM supplier) AS "t"
INNER JOIN (SELECT "l_orderkey", "l_suppkey", EXTRACT(YEAR FROM "l_shipdate") AS "EXTRACT", "l_extendedprice" * (1 - "l_discount") AS "*"
FROM lineitem
WHERE "l_shipdate" >= DATE '1995-01-01' AND "l_shipdate" <= DATE '1996-12-31') AS "t2" ON "t"."s_suppkey" = "t2"."l_suppkey") AS "t3"
INNER JOIN (SELECT "o_orderkey", "o_custkey"
FROM orders) AS "t4" ON "t3"."l_orderkey" = "t4"."o_orderkey") AS "t5"
INNER JOIN (SELECT "c_custkey", "c_nationkey"
FROM customer) AS "t6" ON "t5"."o_custkey" = "t6"."c_custkey") AS "t7"
INNER JOIN (SELECT "n_nationkey", "n_name", "n_name" = 'FRANCE' AS "=", "n_name" = 'GERMANY' AS "=3"
FROM nation) AS "t8" ON "t7"."s_nationkey" = "t8"."n_nationkey") AS "t9"
INNER JOIN (SELECT "n_nationkey", "n_name", "n_name" = 'GERMANY' AS "=", "n_name" = 'FRANCE' AS "=3"
FROM nation) AS "t10" ON "t9"."c_nationkey" = "t10"."n_nationkey" AND ("t9"."=" AND "t10"."=" OR "t9"."=5" AND "t10"."=3")
GROUP BY "t9"."n_name", "t10"."n_name", "t9"."EXTRACT"
ORDER BY "t9"."n_name", "t10"."n_name", "t9"."EXTRACT"

;