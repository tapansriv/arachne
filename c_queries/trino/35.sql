SELECT "t16"."ca_state", "t17"."cd_gender", "t17"."cd_marital_status", "t17"."cd_dep_count", COUNT(*) AS "cnt1", MIN("t17"."cd_dep_count") AS "min1", MAX("t17"."cd_dep_count") AS "max1", AVG("t17"."cd_dep_count") AS "avg1", "t17"."cd_dep_employed_count", COUNT(*) AS "cnt2", MIN("t17"."cd_dep_employed_count") AS "min2", MAX("t17"."cd_dep_employed_count") AS "max2", AVG("t17"."cd_dep_employed_count") AS "avg2", "t17"."cd_dep_college_count", COUNT(*) AS "cnt3", MIN("t17"."cd_dep_college_count"), MAX("t17"."cd_dep_college_count"), AVG("t17"."cd_dep_college_count")
FROM (SELECT "t14"."c_current_cdemo_sk", "t15"."ca_state"
FROM (SELECT "$cor0"."c_current_cdemo_sk", "$cor0"."c_current_addr_sk"
FROM ((tpcds.sf1000.customer AS "$cor0", LATERAL (SELECT TRUE AS "i"
FROM (SELECT "store_sales"."ss_sold_date_sk", "store_sales"."ss_customer_sk", "date_dim"."d_date_sk", "date_dim"."d_year", "date_dim"."d_qoy"
FROM tpcds.sf1000.store_sales AS store_sales,
tpcds.sf1000.date_dim AS date_dim) AS "t"
WHERE "$cor0"."c_customer_sk" = "t"."ss_customer_sk" AND "t"."ss_sold_date_sk" = "t"."d_date_sk" AND "t"."d_year" = 2002 AND "t"."d_qoy" < 4
GROUP BY TRUE) AS "t2") AS "$cor0", LATERAL (SELECT TRUE AS "i"
FROM (SELECT "web_sales"."ws_sold_date_sk", "web_sales"."ws_bill_customer_sk", "date_dim0"."d_date_sk", "date_dim0"."d_year", "date_dim0"."d_qoy"
FROM tpcds.sf1000.web_sales AS web_sales,
tpcds.sf1000.date_dim AS "date_dim0") AS "t3"
WHERE "$cor0"."c_customer_sk" = "t3"."ws_bill_customer_sk" AND "t3"."ws_sold_date_sk" = "t3"."d_date_sk" AND "t3"."d_year" = 2002 AND "t3"."d_qoy" < 4
GROUP BY TRUE) AS "t6") AS "$cor0",
LATERAL (SELECT TRUE AS "i"
FROM (SELECT "catalog_sales"."cs_sold_date_sk", "catalog_sales"."cs_ship_customer_sk", "date_dim1"."d_date_sk", "date_dim1"."d_year", "date_dim1"."d_qoy"
FROM tpcds.sf1000.catalog_sales AS catalog_sales,
tpcds.sf1000.date_dim AS "date_dim1") AS "t7"
WHERE "$cor0"."c_customer_sk" = "t7"."cs_ship_customer_sk" AND "t7"."cs_sold_date_sk" = "t7"."d_date_sk" AND "t7"."d_year" = 2002 AND "t7"."d_qoy" < 4
GROUP BY TRUE) AS "t10"
WHERE "$cor0"."i0" IS NOT NULL OR "$cor0"."i1" IS NOT NULL) AS "t14"
INNER JOIN (SELECT "ca_address_sk", "ca_state"
FROM tpcds.sf1000.customer_address AS customer_address) AS "t15" ON "t14"."c_current_addr_sk" = "t15"."ca_address_sk") AS "t16"
INNER JOIN (SELECT "cd_demo_sk", "cd_gender", "cd_marital_status", "cd_dep_count", "cd_dep_employed_count", "cd_dep_college_count"
FROM tpcds.sf1000.customer_demographics AS customer_demographics) AS "t17" ON "t16"."c_current_cdemo_sk" = "t17"."cd_demo_sk"
GROUP BY "t16"."ca_state", "t17"."cd_gender", "t17"."cd_marital_status", "t17"."cd_dep_count", "t17"."cd_dep_employed_count", "t17"."cd_dep_college_count"
ORDER BY "t16"."ca_state", "t17"."cd_gender", "t17"."cd_marital_status", "t17"."cd_dep_count", "t17"."cd_dep_employed_count", "t17"."cd_dep_college_count"
LIMIT 100

