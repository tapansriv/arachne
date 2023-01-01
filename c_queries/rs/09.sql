SELECT CASE WHEN "t1"."EXPR$0" > 74129 THEN "t5"."EXPR$0" ELSE "t9"."EXPR$0" END AS "bucket1", CASE WHEN "t11"."EXPR$0" > 122840 THEN "t15"."EXPR$0" ELSE "t19"."EXPR$0" END AS "bucket2", CASE WHEN "t21"."EXPR$0" > 56580 THEN "t25"."EXPR$0" ELSE "t29"."EXPR$0" END AS "bucket3", CASE WHEN "t31"."EXPR$0" > 10097 THEN "t35"."EXPR$0" ELSE "t39"."EXPR$0" END AS "bucket4", CASE WHEN "t41"."EXPR$0" > 165306 THEN "t45"."EXPR$0" ELSE "t49"."EXPR$0" END AS "bucket5"
FROM (SELECT *
FROM reason
WHERE "r_reason_sk" = 1) AS "t"
LEFT JOIN (SELECT COUNT(*) AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 1 AND "ss_quantity" <= 20) AS "t1" ON TRUE
LEFT JOIN (SELECT AVG("ss_ext_discount_amt") AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 1 AND "ss_quantity" <= 20) AS "t5" ON TRUE
LEFT JOIN (SELECT AVG("ss_net_paid") AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 1 AND "ss_quantity" <= 20) AS "t9" ON TRUE
LEFT JOIN (SELECT COUNT(*) AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 21 AND "ss_quantity" <= 40) AS "t11" ON TRUE
LEFT JOIN (SELECT AVG("ss_ext_discount_amt") AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 21 AND "ss_quantity" <= 40) AS "t15" ON TRUE
LEFT JOIN (SELECT AVG("ss_net_paid") AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 21 AND "ss_quantity" <= 40) AS "t19" ON TRUE
LEFT JOIN (SELECT COUNT(*) AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 41 AND "ss_quantity" <= 60) AS "t21" ON TRUE
LEFT JOIN (SELECT AVG("ss_ext_discount_amt") AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 41 AND "ss_quantity" <= 60) AS "t25" ON TRUE
LEFT JOIN (SELECT AVG("ss_net_paid") AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 41 AND "ss_quantity" <= 60) AS "t29" ON TRUE
LEFT JOIN (SELECT COUNT(*) AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 61 AND "ss_quantity" <= 80) AS "t31" ON TRUE
LEFT JOIN (SELECT AVG("ss_ext_discount_amt") AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 61 AND "ss_quantity" <= 80) AS "t35" ON TRUE
LEFT JOIN (SELECT AVG("ss_net_paid") AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 61 AND "ss_quantity" <= 80) AS "t39" ON TRUE
LEFT JOIN (SELECT COUNT(*) AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 81 AND "ss_quantity" <= 100) AS "t41" ON TRUE
LEFT JOIN (SELECT AVG("ss_ext_discount_amt") AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 81 AND "ss_quantity" <= 100) AS "t45" ON TRUE
LEFT JOIN (SELECT AVG("ss_net_paid") AS "EXPR$0"
FROM store_sales
WHERE "ss_quantity" >= 81 AND "ss_quantity" <= 100) AS "t49" ON TRUE

