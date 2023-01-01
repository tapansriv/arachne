SELECT "t11"."p_brand", "t11"."p_type", "t11"."p_size", COUNT(DISTINCT "t9"."ps_suppkey") AS "supplier_cnt"
FROM (SELECT "partsupp"."ps_partkey", "partsupp"."ps_suppkey"
FROM partsupp,
(SELECT COUNT(*) AS "c", COUNT(*) AS "ck"
FROM supplier
WHERE "s_comment" LIKE '%Customer%Complaints%') AS "t1"
LEFT JOIN (SELECT "s_suppkey", TRUE AS "i"
FROM supplier
WHERE "s_comment" LIKE '%Customer%Complaints%'
GROUP BY "s_suppkey", TRUE) AS "t5" ON "partsupp"."ps_suppkey" = "t5"."s_suppkey"
WHERE "t1"."c" = 0 OR "t5"."i" IS NULL AND "t1"."ck" >= "t1"."c") AS "t9"
INNER JOIN (SELECT "p_partkey", "p_brand", "p_type", "p_size"
FROM part
WHERE "p_brand" <> 'Brand#45' AND "p_size" IN (3, 9, 14, 19, 23, 36, 45, 49) AND "p_type" NOT LIKE 'MEDIUM POLISHED%') AS "t11" ON "t9"."ps_partkey" = "t11"."p_partkey"
GROUP BY "t11"."p_brand", "t11"."p_type", "t11"."p_size"
ORDER BY COUNT(DISTINCT "t9"."ps_suppkey") DESC NULLS LAST, "t11"."p_brand", "t11"."p_type", "t11"."p_size"

;