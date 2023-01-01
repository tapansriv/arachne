SELECT "t"."s_suppkey", "t"."s_name", "t"."s_address", "t"."s_phone", "t12"."total_revenue"
FROM (SELECT "s_suppkey", "s_name", "s_address", "s_phone"
FROM supplier) AS "t"
INNER JOIN (SELECT "t3"."l_suppkey", "t3"."total_revenue"
FROM (SELECT "l_suppkey", SUM("l_extendedprice" * (1 - "l_discount")) AS "total_revenue"
FROM lineitem
WHERE "l_shipdate" >= DATE '1996-01-01' AND "l_shipdate" < DATE '1996-04-01'
GROUP BY "l_suppkey") AS "t3"
LEFT JOIN (SELECT MAX("total_revenue") AS "EXPR$0"
FROM (SELECT SUM("l_extendedprice" * (1 - "l_discount")) AS "total_revenue"
FROM lineitem
WHERE "l_shipdate" >= DATE '1996-01-01' AND "l_shipdate" < DATE '1996-04-01'
GROUP BY "l_suppkey") AS "t8") AS "t9" ON TRUE
WHERE "t3"."total_revenue" = "t9"."EXPR$0") AS "t12" ON "t"."s_suppkey" = "t12"."l_suppkey"
ORDER BY "t"."s_suppkey"

;