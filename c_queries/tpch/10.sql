SELECT "t7"."c_custkey", "t7"."c_name", SUM("t7"."*") AS "revenue", "t7"."c_acctbal", "t8"."n_name", "t7"."c_address", "t7"."c_phone", "t7"."c_comment"
FROM (SELECT "t3"."c_custkey", "t3"."c_name", "t3"."c_address", "t3"."c_nationkey", "t3"."c_phone", "t3"."c_acctbal", "t3"."c_comment", "t6"."*" AS "*"
FROM (SELECT "t"."c_custkey", "t"."c_name", "t"."c_address", "t"."c_nationkey", "t"."c_phone", "t"."c_acctbal", "t"."c_comment", "t2"."o_orderkey"
FROM (SELECT "c_custkey", "c_name", "c_address", "c_nationkey", "c_phone", "c_acctbal", "c_comment"
FROM customer) AS "t"
INNER JOIN (SELECT "o_orderkey", "o_custkey"
FROM orders
WHERE "o_orderdate" >= DATE '1993-10-01' AND "o_orderdate" < DATE '1994-01-01') AS "t2" ON "t"."c_custkey" = "t2"."o_custkey") AS "t3"
INNER JOIN (SELECT "l_orderkey", "l_extendedprice" * (1 - "l_discount") AS "*"
FROM lineitem
WHERE "l_returnflag" = 'R') AS "t6" ON "t3"."o_orderkey" = "t6"."l_orderkey") AS "t7"
INNER JOIN (SELECT "n_nationkey", "n_name"
FROM nation) AS "t8" ON "t7"."c_nationkey" = "t8"."n_nationkey"
GROUP BY "t7"."c_custkey", "t7"."c_name", "t7"."c_acctbal", "t7"."c_phone", "t8"."n_name", "t7"."c_address", "t7"."c_comment"
ORDER BY SUM("t7"."*") DESC NULLS LAST
FETCH NEXT 20 ROWS ONLY

;