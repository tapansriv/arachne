SELECT "t6"."ps_partkey", "t6"."value1"
FROM (SELECT "t1"."ps_partkey", SUM("t1"."*") AS "value1"
FROM (SELECT "t"."ps_partkey", "t0"."s_nationkey", "t"."*" AS "*"
FROM (SELECT "ps_partkey", "ps_suppkey", "ps_supplycost" * "ps_availqty" AS "*"
FROM partsupp) AS "t"
INNER JOIN (SELECT "s_suppkey", "s_nationkey"
FROM supplier) AS "t0" ON "t"."ps_suppkey" = "t0"."s_suppkey") AS "t1"
INNER JOIN (SELECT "n_nationkey"
FROM nation
WHERE "n_name" = 'GERMANY') AS "t4" ON "t1"."s_nationkey" = "t4"."n_nationkey"
GROUP BY "t1"."ps_partkey") AS "t6"
LEFT JOIN (SELECT SINGLE_VALUE("t11"."EXPR$0") AS "$f0"
FROM (SELECT SUM("partsupp0"."ps_supplycost" * "partsupp0"."ps_availqty") * 0.0001000000 AS "EXPR$0"
FROM partsupp AS "partsupp0",
supplier AS "supplier0",
nation AS "nation0"
WHERE "partsupp0"."ps_suppkey" = "supplier0"."s_suppkey" AND "supplier0"."s_nationkey" = "nation0"."n_nationkey" AND "nation0"."n_name" = 'GERMANY') AS "t11") AS "t12" ON TRUE
WHERE "t6"."value1" > "t12"."$f0"
ORDER BY "t6"."value1" DESC NULLS LAST

;