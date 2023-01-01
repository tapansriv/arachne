SELECT i_brand_id brand_id,
       i_brand brand,
       i_manufact_id,
       i_manufact,
       sum(ss_ext_sales_price) ext_price
FROM `arachne-multicloud.tpcds.date_dim` AS date_dim,
     `arachne-multicloud.tpcds.store_sales` AS store_sales,
     `arachne-multicloud.tpcds.item` AS item,
     `arachne-multicloud.tpcds.customer` AS customer,
     `arachne-multicloud.tpcds.customer_address` AS customer_address,
     `arachne-multicloud.tpcds.store` AS store
WHERE d_date_sk = ss_sold_date_sk
  AND ss_item_sk = i_item_sk
  AND i_manager_id=8
  AND d_moy=11
  AND d_year=1998
  AND ss_customer_sk = c_customer_sk
  AND c_current_addr_sk = ca_address_sk
  AND SUBSTRING(ca_zip, 1, 5) <> SUBSTRING(s_zip, 1, 5)
  AND ss_store_sk = s_store_sk
GROUP BY i_brand,
         i_brand_id,
         i_manufact_id,
         i_manufact
ORDER BY ext_price DESC,
         i_brand,
         i_brand_id,
         i_manufact_id,
         i_manufact
LIMIT 100 ;

