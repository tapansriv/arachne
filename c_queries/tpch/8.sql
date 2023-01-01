SELECT "t15"."EXTRACT" AS "o_year", SUM("t15"."CASE") / SUM("t15"."*") AS "mkt_share"
FROM (SELECT "t12"."n_regionkey", "t12"."EXTRACT", CASE WHEN "t13"."=" THEN "t12"."*" ELSE 0 END AS "CASE", "t12"."*" AS "*"
FROM (SELECT "t10"."s_nationkey", "t11"."n_regionkey", "t10"."EXTRACT", "t10"."*" AS "*"
FROM (SELECT "t8"."s_nationkey", "t9"."c_nationkey", "t8"."EXTRACT", "t8"."*" AS "*"
FROM (SELECT "t4"."s_nationkey", "t7"."o_custkey", "t7"."EXTRACT", "t4"."*" AS "*"
FROM (SELECT "t2"."s_nationkey", "t3"."l_orderkey", "t3"."*" AS "*"
FROM (SELECT "p_partkey"
FROM part
WHERE "p_type" = 'ECONOMY ANODIZED STEEL') AS "t1",
(SELECT "s_suppkey", "s_nationkey"
FROM supplier) AS "t2"
INNER JOIN (SELECT "l_orderkey", "l_partkey", "l_suppkey", "l_extendedprice" * (1 - "l_discount") AS "*"
FROM lineitem) AS "t3" ON "t1"."p_partkey" = "t3"."l_partkey" AND "t2"."s_suppkey" = "t3"."l_suppkey") AS "t4"
INNER JOIN (SELECT "o_orderkey", "o_custkey", EXTRACT(YEAR FROM "o_orderdate") AS "EXTRACT"
FROM orders
WHERE "o_orderdate" >= DATE '1995-01-01' AND "o_orderdate" <= DATE '1996-12-31') AS "t7" ON "t4"."l_orderkey" = "t7"."o_orderkey") AS "t8"
INNER JOIN (SELECT "c_custkey", "c_nationkey"
FROM customer) AS "t9" ON "t8"."o_custkey" = "t9"."c_custkey") AS "t10"
INNER JOIN (SELECT "n_nationkey", "n_regionkey"
FROM nation) AS "t11" ON "t10"."c_nationkey" = "t11"."n_nationkey") AS "t12"
INNER JOIN (SELECT "n_nationkey", "n_name" = 'BRAZIL' AS "="
FROM nation) AS "t13" ON "t12"."s_nationkey" = "t13"."n_nationkey") AS "t15"
INNER JOIN (SELECT "r_regionkey"
FROM region
WHERE "r_name" = 'AMERICA') AS "t18" ON "t15"."n_regionkey" = "t18"."r_regionkey"
GROUP BY "t15"."EXTRACT"
ORDER BY "t15"."EXTRACT"

;