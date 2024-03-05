SELECT i_item_id,
       i_item_desc,
       s_store_id,
       s_store_name,
       sum(ss_quantity) AS store_sales_quantity,
       sum(sr_return_quantity) AS store_returns_quantity,
       sum(cs_quantity) AS catalog_sales_quantity
FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
     `arachne-multicloud.tpcds.store_returns` AS store_returns,
     `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales,
     `arachne-multicloud.tpcds.date_dim` d1,
     `arachne-multicloud.tpcds.date_dim` d2,
     `arachne-multicloud.tpcds.date_dim` d3,
     `arachne-multicloud.tpcds.store` AS store,
     `arachne-multicloud.tpcds.item` AS item
WHERE d1.d_moy = 9
  AND d1.d_year = 1999
  AND d1.d_date_sk = ss_sold_date_sk
  AND i_item_sk = ss_item_sk
  AND s_store_sk = ss_store_sk
  AND ss_customer_sk = sr_customer_sk
  AND ss_item_sk = sr_item_sk
  AND ss_ticket_number = sr_ticket_number
  AND sr_returned_date_sk = d2.d_date_sk
  AND d2.d_moy BETWEEN 9 AND 9 + 3
  AND d2.d_year = 1999
  AND sr_customer_sk = cs_bill_customer_sk
  AND sr_item_sk = cs_item_sk
  AND cs_sold_date_sk = d3.d_date_sk
  AND d3.d_year IN (1999,
                    1999+1,
                    1999+2)
GROUP BY i_item_id,
         i_item_desc,
         s_store_id,
         s_store_name
ORDER BY i_item_id,
         i_item_desc,
         s_store_id,
         s_store_name
LIMIT 100;

