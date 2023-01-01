SELECT "t7"."l_orderkey", SUM("t7"."*") AS "revenue", "t4"."o_orderdate", "t4"."o_shippriority"
FROM (SELECT "t3"."o_orderkey", "t3"."o_orderdate", "t3"."o_shippriority"
FROM (SELECT "c_custkey"
FROM customer
WHERE "c_mktsegment" = 'BUILDING') AS "t1"
INNER JOIN (SELECT "o_orderkey", "o_custkey", "o_orderdate", "o_shippriority"
FROM orders
WHERE "o_orderdate" < DATE '1995-03-15') AS "t3" ON "t1"."c_custkey" = "t3"."o_custkey") AS "t4"
INNER JOIN (SELECT "l_orderkey", "l_extendedprice" * (1 - "l_discount") AS "*"
FROM lineitem
WHERE "l_shipdate" > DATE '1995-03-15') AS "t7" ON "t4"."o_orderkey" = "t7"."l_orderkey"
GROUP BY "t7"."l_orderkey", "t4"."o_orderdate", "t4"."o_shippriority"
ORDER BY SUM("t7"."*") DESC NULLS LAST, "t4"."o_orderdate"
FETCH NEXT 10 ROWS ONLY

;