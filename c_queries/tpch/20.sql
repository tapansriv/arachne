SELECT "t15"."s_name", "t15"."s_address"
FROM (SELECT "supplier"."s_name", "supplier"."s_address", "supplier"."s_nationkey"
FROM supplier
INNER JOIN (SELECT "$cor0"."ps_suppkey"
FROM (partsupp INNER JOIN (SELECT "p_partkey"
FROM part
WHERE "p_name" LIKE 'forest%'
GROUP BY "p_partkey") AS "t2" ON "partsupp"."ps_partkey" = "t2"."p_partkey") AS "$cor0",
LATERAL (SELECT SINGLE_VALUE("EXPR$0") AS "$f0"
FROM (SELECT 0.5 * SUM("l_quantity") AS "EXPR$0"
FROM (SELECT "l_partkey", "l_suppkey", "l_quantity", "l_shipdate"
FROM lineitem) AS "t3"
WHERE "l_partkey" = "$cor0"."ps_partkey" AND "l_suppkey" = "$cor0"."ps_suppkey" AND ("l_shipdate" >= DATE '1994-01-01' AND "l_shipdate" < DATE '1995-01-01')) AS "t7") AS "t8"
WHERE "$cor0"."ps_availqty" > "$cor0"."$f0"
GROUP BY "$cor0"."ps_suppkey") AS "t13" ON "supplier"."s_suppkey" = "t13"."ps_suppkey") AS "t15"
INNER JOIN (SELECT "n_nationkey"
FROM nation
WHERE "n_name" = 'CANADA') AS "t18" ON "t15"."s_nationkey" = "t18"."n_nationkey"
ORDER BY "t15"."s_name"

;