CREATE TABLE rs_table_28_0 AS SELECT *
FROM (SELECT AVG("ss_list_price") AS "B1_LP", COUNT(*) AS "B1_CNT", COUNT(DISTINCT "ss_list_price") AS "B1_CNTD"
FROM store_sales
WHERE "ss_quantity" >= 0 AND "ss_quantity" <= 5 AND ("ss_list_price" >= 8 AND "ss_list_price" <= 8 + 10 OR "ss_coupon_amt" >= 459 AND "ss_coupon_amt" <= 459 + 1000 OR "ss_wholesale_cost" >= 57 AND "ss_wholesale_cost" <= 57 + 20)) AS "t2",
(SELECT AVG("ss_list_price") AS "B2_LP", COUNT(*) AS "B2_CNT", COUNT(DISTINCT "ss_list_price") AS "B2_CNTD"
FROM store_sales
WHERE "ss_quantity" >= 6 AND "ss_quantity" <= 10 AND ("ss_list_price" >= 90 AND "ss_list_price" <= 90 + 10 OR "ss_coupon_amt" >= 2323 AND "ss_coupon_amt" <= 2323 + 1000 OR "ss_wholesale_cost" >= 31 AND "ss_wholesale_cost" <= 31 + 20)) AS "t6",
(SELECT AVG("ss_list_price") AS "B3_LP", COUNT(*) AS "B3_CNT", COUNT(DISTINCT "ss_list_price") AS "B3_CNTD"
FROM store_sales
WHERE "ss_quantity" >= 11 AND "ss_quantity" <= 15 AND ("ss_list_price" >= 142 AND "ss_list_price" <= 142 + 10 OR "ss_coupon_amt" >= 12214 AND "ss_coupon_amt" <= 12214 + 1000 OR "ss_wholesale_cost" >= 79 AND "ss_wholesale_cost" <= 79 + 20)) AS "t10",
(SELECT AVG("ss_list_price") AS "B4_LP", COUNT(*) AS "B4_CNT", COUNT(DISTINCT "ss_list_price") AS "B4_CNTD"
FROM store_sales
WHERE "ss_quantity" >= 16 AND "ss_quantity" <= 20 AND ("ss_list_price" >= 135 AND "ss_list_price" <= 135 + 10 OR "ss_coupon_amt" >= 6071 AND "ss_coupon_amt" <= 6071 + 1000 OR "ss_wholesale_cost" >= 38 AND "ss_wholesale_cost" <= 38 + 20)) AS "t14",
(SELECT AVG("ss_list_price") AS "B5_LP", COUNT(*) AS "B5_CNT", COUNT(DISTINCT "ss_list_price") AS "B5_CNTD"
FROM store_sales
WHERE "ss_quantity" >= 21 AND "ss_quantity" <= 25 AND ("ss_list_price" >= 122 AND "ss_list_price" <= 122 + 10 OR "ss_coupon_amt" >= 836 AND "ss_coupon_amt" <= 836 + 1000 OR "ss_wholesale_cost" >= 17 AND "ss_wholesale_cost" <= 17 + 20)) AS "t18"
;
SELECT *
FROM "rs_table_28_0",
(SELECT AVG("ss_list_price") AS "B6_LP", COUNT(*) AS "B6_CNT", COUNT(DISTINCT "ss_list_price") AS "B6_CNTD"
FROM store_sales
WHERE "ss_quantity" >= 26 AND "ss_quantity" <= 30 AND ("ss_list_price" >= 154 AND "ss_list_price" <= 154 + 10 OR "ss_coupon_amt" >= 7326 AND "ss_coupon_amt" <= 7326 + 1000 OR "ss_wholesale_cost" >= 7 AND "ss_wholesale_cost" <= 7 + 20)) AS "t2"
LIMIT 100
;
