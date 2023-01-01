SELECT "t19"."cd_gender", "t19"."cd_marital_status", "t19"."cd_education_status", COUNT(*) AS "cnt1", "t19"."cd_purchase_estimate", COUNT(*) AS "cnt2", "t19"."cd_credit_rating", COUNT(*) AS "cnt3"
FROM (SELECT "t14"."c_current_cdemo_sk"
FROM (SELECT "$cor0"."c_current_cdemo_sk", "$cor0"."c_current_addr_sk"
FROM ((customer AS "$cor0", LATERAL (SELECT TRUE AS "i"
FROM (SELECT "store_sales"."ss_sold_date_sk", "store_sales"."ss_customer_sk", "date_dim"."d_date_sk", "date_dim"."d_year", "date_dim"."d_moy"
FROM store_sales,
date_dim) AS "t"
WHERE "$cor0"."c_customer_sk" = "t"."ss_customer_sk" AND "t"."ss_sold_date_sk" = "t"."d_date_sk" AND "t"."d_year" = 2001 AND "t"."d_moy" >= 4 AND "t"."d_moy" <= 4 + 2
GROUP BY TRUE) AS "t2") AS "$cor0", LATERAL (SELECT TRUE AS "i"
FROM (SELECT "web_sales"."ws_sold_date_sk", "web_sales"."ws_bill_customer_sk", "date_dim0"."d_date_sk", "date_dim0"."d_year", "date_dim0"."d_moy"
FROM web_sales,
date_dim AS "date_dim0") AS "t3"
WHERE "$cor0"."c_customer_sk" = "t3"."ws_bill_customer_sk" AND "t3"."ws_sold_date_sk" = "t3"."d_date_sk" AND "t3"."d_year" = 2001 AND "t3"."d_moy" >= 4 AND "t3"."d_moy" <= 4 + 2
GROUP BY TRUE) AS "t6") AS "$cor0",
LATERAL (SELECT TRUE AS "i"
FROM (SELECT "catalog_sales"."cs_sold_date_sk", "catalog_sales"."cs_ship_customer_sk", "date_dim1"."d_date_sk", "date_dim1"."d_year", "date_dim1"."d_moy"
FROM catalog_sales,
date_dim AS "date_dim1") AS "t7"
WHERE "$cor0"."c_customer_sk" = "t7"."cs_ship_customer_sk" AND "t7"."cs_sold_date_sk" = "t7"."d_date_sk" AND "t7"."d_year" = 2001 AND "t7"."d_moy" >= 4 AND "t7"."d_moy" <= 4 + 2
GROUP BY TRUE) AS "t10"
WHERE "$cor0"."i0" IS NULL AND "$cor0"."i1" IS NULL) AS "t14"
INNER JOIN (SELECT "ca_address_sk"
FROM customer_address
WHERE "ca_state" IN ('GA', 'KY', 'NM')) AS "t17" ON "t14"."c_current_addr_sk" = "t17"."ca_address_sk") AS "t18"
INNER JOIN (SELECT "cd_demo_sk", "cd_gender", "cd_marital_status", "cd_education_status", "cd_purchase_estimate", "cd_credit_rating"
FROM customer_demographics) AS "t19" ON "t18"."c_current_cdemo_sk" = "t19"."cd_demo_sk"
GROUP BY "t19"."cd_gender", "t19"."cd_marital_status", "t19"."cd_education_status", "t19"."cd_purchase_estimate", "t19"."cd_credit_rating"
ORDER BY "t19"."cd_gender", "t19"."cd_marital_status", "t19"."cd_education_status", "t19"."cd_purchase_estimate", "t19"."cd_credit_rating"
FETCH NEXT 100 ROWS ONLY

