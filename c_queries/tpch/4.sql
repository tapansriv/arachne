SELECT "$cor0"."o_orderpriority", COUNT(*) AS "order_count"
FROM orders AS "$cor0",
LATERAL (SELECT TRUE AS "i"
FROM (SELECT "l_orderkey", "l_commitdate", "l_receiptdate"
FROM lineitem) AS "t"
WHERE "l_orderkey" = "$cor0"."o_orderkey" AND "l_commitdate" < "l_receiptdate"
GROUP BY TRUE) AS "t2"
WHERE "$cor0"."o_orderdate" >= DATE '1993-07-01' AND "$cor0"."o_orderdate" < DATE '1993-10-01'
GROUP BY "$cor0"."o_orderpriority"
ORDER BY "$cor0"."o_orderpriority"

;