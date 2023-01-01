SELECT "t5"."c_count", COUNT(*) AS "custdist"
FROM (SELECT COUNT("t2"."o_orderkey") AS "c_count"
FROM (SELECT "c_custkey"
FROM customer) AS "t"
LEFT JOIN (SELECT "o_orderkey", "o_custkey"
FROM orders
WHERE "o_comment" NOT LIKE '%special%requests%') AS "t2" ON "t"."c_custkey" = "t2"."o_custkey"
GROUP BY "t"."c_custkey") AS "t5"
GROUP BY "t5"."c_count"
ORDER BY COUNT(*) DESC NULLS LAST, "t5"."c_count" DESC NULLS LAST

;