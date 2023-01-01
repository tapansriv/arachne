SELECT "t12"."s_acctbal", "t12"."s_name", "t12"."n_name", "t12"."p_partkey", "t12"."p_mfgr", "t12"."s_address", "t12"."s_phone", "t12"."s_comment"
FROM (SELECT "t10"."p_partkey", "t10"."p_mfgr", "t10"."s_name", "t10"."s_address", "t10"."s_phone", "t10"."s_acctbal", "t10"."s_comment", "t11"."n_name", "t11"."n_regionkey"
FROM (SELECT "t1"."p_partkey", "t1"."p_mfgr", "t2"."s_name", "t2"."s_address", "t2"."s_nationkey", "t2"."s_phone", "t2"."s_acctbal", "t2"."s_comment"
FROM (SELECT "p_partkey", "p_mfgr"
FROM part
WHERE "p_size" = 15 AND "p_type" LIKE '%BRASS') AS "t1",
(SELECT *
FROM supplier) AS "t2"
INNER JOIN (SELECT "$cor0"."ps_partkey", "$cor0"."ps_suppkey"
FROM partsupp AS "$cor0",
LATERAL (SELECT MIN("ps_supplycost") AS "EXPR$0"
FROM (SELECT "partsupp0"."ps_partkey", "partsupp0"."ps_suppkey", "partsupp0"."ps_supplycost", "supplier0"."s_suppkey", "supplier0"."s_nationkey", "nation"."n_nationkey", "nation"."n_regionkey", "region"."r_regionkey", "region"."r_name"
FROM partsupp AS "partsupp0",
supplier AS "supplier0",
nation,
region) AS "t3"
WHERE "$cor0"."ps_partkey" = "t3"."ps_partkey" AND "t3"."s_suppkey" = "t3"."ps_suppkey" AND "t3"."s_nationkey" = "t3"."n_nationkey" AND "t3"."n_regionkey" = "t3"."r_regionkey" AND "t3"."r_name" = 'EUROPE') AS "t6"
WHERE "$cor0"."ps_supplycost" = "$cor0"."EXPR$0") AS "t9" ON "t1"."p_partkey" = "t9"."ps_partkey" AND "t2"."s_suppkey" = "t9"."ps_suppkey") AS "t10"
INNER JOIN (SELECT "n_nationkey", "n_name", "n_regionkey"
FROM nation) AS "t11" ON "t10"."s_nationkey" = "t11"."n_nationkey") AS "t12"
INNER JOIN (SELECT "r_regionkey"
FROM region
WHERE "r_name" = 'EUROPE') AS "t15" ON "t12"."n_regionkey" = "t15"."r_regionkey"
ORDER BY "t12"."s_acctbal" DESC NULLS LAST, "t12"."n_name", "t12"."s_name", "t12"."p_partkey"
FETCH NEXT 100 ROWS ONLY

;