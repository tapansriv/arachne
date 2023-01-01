WITH ssales AS
  (SELECT c_last_name,
          c_first_name,
          s_store_name,
          ca_state,
          s_state,
          i_color,
          i_current_price,
          i_manager_id,
          i_units,
          i_size,
          sum(ss_net_paid) netpaid
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.store_returns` AS store_returns,
        `arachne-multicloud.tpcds.store` AS store,
        `arachne-multicloud.tpcds.item` AS item,
        `arachne-multicloud.tpcds.customer` AS customer,
        `arachne-multicloud.tpcds.customer_address` AS customer_address
   WHERE ss_ticket_number = sr_ticket_number
     AND ss_item_sk = sr_item_sk
     AND ss_customer_sk = c_customer_sk
     AND ss_item_sk = i_item_sk
     AND ss_store_sk = s_store_sk
     AND c_current_addr_sk = ca_address_sk
     AND c_birth_country <> upper(ca_country)
     AND s_zip = ca_zip
     AND s_market_id=8
   GROUP BY c_last_name,
            c_first_name,
            s_store_name,
            ca_state,
            s_state,
            i_color,
            i_current_price,
            i_manager_id,
            i_units,
            i_size)
SELECT c_last_name,
       c_first_name,
       s_store_name,
       sum(netpaid) paid
FROM ssales
WHERE i_color = 'peach'
GROUP BY c_last_name,
         c_first_name,
         s_store_name
HAVING sum(netpaid) >
  (SELECT 0.05*avg(netpaid)
   FROM ssales)
ORDER BY c_last_name,
         c_first_name,
         s_store_name ;