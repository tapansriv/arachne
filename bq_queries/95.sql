WITH ws_wh AS
  (SELECT ws1.ws_order_number,
          ws1.ws_warehouse_sk wh1,
          ws2.ws_warehouse_sk wh2
   FROM `arachne-multicloud.tpcds.web_sales` ws1,
        `arachne-multicloud.tpcds.web_sales` ws2
   WHERE ws1.ws_order_number = ws2.ws_order_number
     AND ws1.ws_warehouse_sk <> ws2.ws_warehouse_sk)
SELECT count(DISTINCT ws_order_number) AS order_count ,
       sum(ws_ext_ship_cost) AS total_shipping_cost ,
       sum(ws_net_profit) AS total_net_profit
FROM `arachne-multicloud.tpcds.web_sales` ws1 ,
     `arachne-multicloud.tpcds.date_dim` AS date_dim ,
     `arachne-multicloud.tpcds.customer_address` AS customer_address ,
     `arachne-multicloud.tpcds.web_site` AS web_site
WHERE cast(d_date as date) BETWEEN '1999-02-01' AND cast('1999-04-02' AS date)
  AND ws1.ws_ship_date_sk = d_date_sk
  AND ws1.ws_ship_addr_sk = ca_address_sk
  AND ca_state = 'IL'
  AND ws1.ws_web_site_sk = web_site_sk
  AND web_company_name = 'pri'
  AND ws1.ws_order_number IN
    (SELECT ws_order_number
     FROM ws_wh)
  AND ws1.ws_order_number IN
    (SELECT wr_order_number
     FROM `arachne-multicloud.tpcds.web_returns` AS web_returns,
          ws_wh
     WHERE wr_order_number = ws_wh.ws_order_number)
ORDER BY count(DISTINCT ws_order_number)
LIMIT 100;

