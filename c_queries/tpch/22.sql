SELECT SUBSTRING("$cor0"."c_phone" FROM 1 FOR 2) AS "cntrycode", COUNT(*) AS "numcust", SUM("$cor0"."c_acctbal") AS "totacctbal"
FROM (customer LEFT JOIN (SELECT AVG("c_acctbal") AS "EXPR$0"
FROM customer
WHERE "c_acctbal" > 0.00 AND (SUBSTRING("c_phone" FROM 1 FOR 2) = '13' OR (SUBSTRING("c_phone" FROM 1 FOR 2) = '31' OR SUBSTRING("c_phone" FROM 1 FOR 2) = '23') OR (SUBSTRING("c_phone" FROM 1 FOR 2) = '29' OR SUBSTRING("c_phone" FROM 1 FOR 2) = '30' OR (SUBSTRING("c_phone" FROM 1 FOR 2) = '18' OR SUBSTRING("c_phone" FROM 1 FOR 2) = '17')))) AS "t2" ON TRUE) AS "$cor0",
LATERAL (SELECT TRUE AS "i"
FROM (SELECT "o_custkey"
FROM orders) AS "t3"
WHERE "o_custkey" = "$cor0"."c_custkey"
GROUP BY TRUE) AS "t6"
WHERE (SUBSTRING("$cor0"."c_phone" FROM 1 FOR 2) = '13' OR (SUBSTRING("$cor0"."c_phone" FROM 1 FOR 2) = '31' OR SUBSTRING("$cor0"."c_phone" FROM 1 FOR 2) = '23') OR (SUBSTRING("$cor0"."c_phone" FROM 1 FOR 2) = '29' OR SUBSTRING("$cor0"."c_phone" FROM 1 FOR 2) = '30' OR (SUBSTRING("$cor0"."c_phone" FROM 1 FOR 2) = '18' OR SUBSTRING("$cor0"."c_phone" FROM 1 FOR 2) = '17'))) AND "$cor0"."c_acctbal" > "$cor0"."EXPR$0" AND "$cor0"."i" IS NULL
GROUP BY SUBSTRING("$cor0"."c_phone" FROM 1 FOR 2)
ORDER BY SUBSTRING("$cor0"."c_phone" FROM 1 FOR 2)

;