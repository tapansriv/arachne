SELECT 100.00 * SUM(CASE WHEN "t2"."LIKE" THEN "t1"."*" ELSE 0 END) / SUM("t1"."*") AS "promo_revenue"
FROM (SELECT "l_partkey", "l_extendedprice" * (1 - "l_discount") AS "*"
FROM lineitem
WHERE "l_shipdate" >= DATE '1995-09-01' AND "l_shipdate" < DATE '1995-10-01') AS "t1"
INNER JOIN (SELECT "p_partkey", "p_type" LIKE 'PROMO%' AS "LIKE"
FROM part) AS "t2" ON "t1"."l_partkey" = "t2"."p_partkey"

;