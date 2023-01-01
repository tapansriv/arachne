SELECT "t6"."c_name", "t6"."c_custkey", "t6"."o_orderkey", "t6"."o_orderdate", "t6"."o_totalprice", SUM("t7"."l_quantity")
FROM (SELECT "t"."c_custkey", "t"."c_name", "t5"."o_orderkey", "t5"."o_totalprice", "t5"."o_orderdate"
FROM (SELECT "c_custkey", "c_name"
FROM customer) AS "t"
INNER JOIN (SELECT "orders"."o_orderkey", "orders"."o_custkey", "orders"."o_totalprice", "orders"."o_orderdate"
FROM orders
INNER JOIN (SELECT "l_orderkey"
FROM lineitem
GROUP BY "l_orderkey"
HAVING SUM("l_quantity") > 300) AS "t3" ON "orders"."o_orderkey" = "t3"."l_orderkey") AS "t5" ON "t"."c_custkey" = "t5"."o_custkey") AS "t6"
INNER JOIN (SELECT "l_orderkey", "l_quantity"
FROM lineitem) AS "t7" ON "t6"."o_orderkey" = "t7"."l_orderkey"
GROUP BY "t6"."c_name", "t6"."c_custkey", "t6"."o_orderkey", "t6"."o_orderdate", "t6"."o_totalprice"
ORDER BY "t6"."o_totalprice" DESC NULLS LAST, "t6"."o_orderdate"
FETCH NEXT 100 ROWS ONLY

;