SELECT "t3"."l_shipmode", SUM("t0"."CASE") AS "high_line_count", SUM("t0"."CASE2") AS "low_line_count"
FROM (SELECT "o_orderkey", CASE WHEN "o_orderpriority" IN ('1-URGENT', '2-HIGH') THEN 1 ELSE 0 END AS "CASE", CASE WHEN "o_orderpriority" NOT IN ('1-URGENT', '2-HIGH') THEN 1 ELSE 0 END AS "CASE2"
FROM orders) AS "t0"
INNER JOIN (SELECT "l_orderkey", "l_shipmode"
FROM lineitem
WHERE "l_shipmode" IN ('MAIL', 'SHIP') AND "l_commitdate" < "l_receiptdate" AND "l_shipdate" < "l_commitdate" AND ("l_receiptdate" >= DATE '1994-01-01' AND "l_receiptdate" < DATE '1995-01-01')) AS "t3" ON "t0"."o_orderkey" = "t3"."l_orderkey"
GROUP BY "t3"."l_shipmode"
ORDER BY "t3"."l_shipmode"

;