
SELECT i_item_id ,
       i_item_desc ,
       s_store_id ,
       s_store_name ,
       sum(ss_net_profit) AS store_sales_profit ,
       sum(sr_net_loss) AS store_returns_loss ,
       sum(cs_net_profit) AS catalog_sales_profit
FROM `arachne-multicloud.tpcds.store_sales` AS store_sales ,
     `arachne-multicloud.tpcds.store_returns` AS store_returns ,
     `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales ,
     `arachne-multicloud.tpcds.date_dim` d1 ,
     `arachne-multicloud.tpcds.date_dim` d2 ,
     `arachne-multicloud.tpcds.date_dim` d3 ,
     `arachne-multicloud.tpcds.store` AS store ,
     `arachne-multicloud.tpcds.item` AS item
WHERE d1.d_moy = 4
  AND d1.d_year = 2001
  AND d1.d_date_sk = ss_sold_date_sk
  AND i_item_sk = ss_item_sk
  AND s_store_sk = ss_store_sk
  AND ss_customer_sk = sr_customer_sk
  AND ss_item_sk = sr_item_sk
  AND ss_ticket_number = sr_ticket_number
  AND sr_returned_date_sk = d2.d_date_sk
  AND d2.d_moy BETWEEN 4 AND 10
  AND d2.d_year = 2001
  AND sr_customer_sk = cs_bill_customer_sk
  AND sr_item_sk = cs_item_sk
  AND cs_sold_date_sk = d3.d_date_sk
  AND d3.d_moy BETWEEN 4 AND 10
  AND d3.d_year = 2001
GROUP BY i_item_id ,
         i_item_desc ,
         s_store_id ,
         s_store_name
ORDER BY i_item_id ,
         i_item_desc ,
         s_store_id ,
         s_store_name
LIMIT 100;

