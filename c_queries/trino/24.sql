SELECT "t16"."c_last_name", "t16"."c_first_name", "t16"."s_store_name", "t16"."paid"
FROM (SELECT "t15"."c_last_name", "t15"."c_first_name", "t15"."s_store_name", SUM("t15"."netpaid") AS "paid"
FROM (SELECT "t9"."c_last_name", "t9"."c_first_name", "t9"."s_store_name", SUM("t9"."ss_net_paid") AS "netpaid"
FROM (SELECT "t7"."ss_net_paid", "t7"."s_store_name", "t7"."s_state", "t7"."s_zip", "t7"."i_current_price", "t7"."i_size", "t7"."i_color", "t7"."i_units", "t7"."i_manager_id", "t8"."c_current_addr_sk", "t8"."c_first_name", "t8"."c_last_name", "t8"."c_birth_country"
FROM (SELECT "t5"."ss_customer_sk", "t5"."ss_net_paid", "t5"."s_store_name", "t5"."s_state", "t5"."s_zip", "t6"."i_current_price", "t6"."i_size", "t6"."i_color", "t6"."i_units", "t6"."i_manager_id"
FROM (SELECT "t1"."ss_item_sk", "t1"."ss_customer_sk", "t1"."ss_net_paid", "t4"."s_store_name", "t4"."s_state", "t4"."s_zip"
FROM (SELECT "t"."ss_item_sk", "t"."ss_customer_sk", "t"."ss_store_sk", "t"."ss_net_paid"
FROM (SELECT "ss_item_sk", "ss_customer_sk", "ss_store_sk", "ss_ticket_number", "ss_net_paid"
FROM tpcds.sf1000.store_sales AS store_sales) AS "t"
INNER JOIN (SELECT "sr_item_sk", "sr_ticket_number"
FROM tpcds.sf1000.store_returns AS store_returns) AS "t0" ON "t"."ss_ticket_number" = "t0"."sr_ticket_number" AND "t"."ss_item_sk" = "t0"."sr_item_sk") AS "t1"
INNER JOIN (SELECT "s_store_sk", "s_store_name", "s_state", "s_zip"
FROM tpcds.sf1000.store AS store
WHERE "s_market_id" = 8) AS "t4" ON "t1"."ss_store_sk" = "t4"."s_store_sk") AS "t5"
INNER JOIN (SELECT "i_item_sk", "i_current_price", "i_size", "i_color", "i_units", "i_manager_id"
FROM tpcds.sf1000.item AS item) AS "t6" ON "t5"."ss_item_sk" = "t6"."i_item_sk") AS "t7"
INNER JOIN (SELECT "c_customer_sk", "c_current_addr_sk", "c_first_name", "c_last_name", "c_birth_country"
FROM tpcds.sf1000.customer AS customer) AS "t8" ON "t7"."ss_customer_sk" = "t8"."c_customer_sk") AS "t9"
INNER JOIN (SELECT "ca_address_sk", "ca_state", "ca_zip", UPPER("ca_country") AS "UPPER"
FROM tpcds.sf1000.customer_address AS customer_address) AS "t10" ON "t9"."c_current_addr_sk" = "t10"."ca_address_sk" AND "t9"."c_birth_country" <> "t10"."UPPER" AND "t9"."s_zip" = "t10"."ca_zip"
GROUP BY "t9"."c_last_name", "t9"."c_first_name", "t9"."s_store_name", "t10"."ca_state", "t9"."s_state", "t9"."i_color", "t9"."i_current_price", "t9"."i_manager_id", "t9"."i_units", "t9"."i_size"
HAVING "t9"."i_color" = 'peach') AS "t15"
GROUP BY "t15"."c_last_name", "t15"."c_first_name", "t15"."s_store_name") AS "t16"
LEFT JOIN (SELECT SINGLE_VALUE("EXPR$0") AS "$f0"
FROM (SELECT 0.05 * AVG("t21"."netpaid") AS "EXPR$0"
FROM (SELECT SUM("store_sales0"."ss_net_paid") AS "netpaid"
FROM tpcds.sf1000.store_sales AS "store_sales0",
tpcds.sf1000.store_returns AS "store_returns0",
tpcds.sf1000.store AS "store0",
tpcds.sf1000.item AS "item0",
tpcds.sf1000.customer AS "customer0",
tpcds.sf1000.customer_address AS "customer_address0"
WHERE "store_sales0"."ss_ticket_number" = "store_returns0"."sr_ticket_number" AND "store_sales0"."ss_item_sk" = "store_returns0"."sr_item_sk" AND ("store_sales0"."ss_customer_sk" = "customer0"."c_customer_sk" AND "store_sales0"."ss_item_sk" = "item0"."i_item_sk") AND ("store_sales0"."ss_store_sk" = "store0"."s_store_sk" AND "customer0"."c_current_addr_sk" = "customer_address0"."ca_address_sk" AND ("customer0"."c_birth_country" <> UPPER("customer_address0"."ca_country") AND ("store0"."s_zip" = "customer_address0"."ca_zip" AND "store0"."s_market_id" = 8)))
GROUP BY "customer0"."c_last_name", "customer0"."c_first_name", "store0"."s_store_name", "customer_address0"."ca_state", "store0"."s_state", "item0"."i_color", "item0"."i_current_price", "item0"."i_manager_id", "item0"."i_units", "item0"."i_size") AS "t21") AS "t23") AS "t24" ON TRUE
WHERE "t16"."paid" > "t24"."$f0"
ORDER BY "t16"."c_last_name" IS NULL, "t16"."c_last_name", "t16"."c_first_name" IS NULL, "t16"."c_first_name", "t16"."s_store_name" IS NULL, "t16"."s_store_name"

