SELECT SUM("t7"."l_extendedprice") / 7.0 AS "avg_yearly"
FROM (SELECT "$cor0"."l_partkey", "$cor0"."l_extendedprice"
FROM lineitem AS "$cor0",
LATERAL (SELECT SINGLE_VALUE("EXPR$0") AS "$f0"
FROM (SELECT 0.2 * AVG("l_quantity") AS "EXPR$0"
FROM (SELECT "l_partkey", "l_quantity"
FROM lineitem) AS "t"
WHERE "l_partkey" = "$cor0"."$f0") AS "t3") AS "t4"
WHERE "$cor0"."l_quantity" < "$cor0"."$f0") AS "t7"
INNER JOIN (SELECT "p_partkey"
FROM part
WHERE "p_brand" = 'Brand#23' AND "p_container" = 'MED BOX') AS "t10" ON "t7"."l_partkey" = "t10"."p_partkey"

;