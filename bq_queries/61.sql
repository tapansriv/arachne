SELECT promotions,
       total,
       cast(promotions AS numeric)/cast(total AS numeric)*100
FROM
  (SELECT sum(ss_ext_sales_price) promotions
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.store` AS store,
        `arachne-multicloud.tpcds.promotion` AS promotion,
        `arachne-multicloud.tpcds.date_dim` AS date_dim,
        `arachne-multicloud.tpcds.customer` AS customer,
        `arachne-multicloud.tpcds.customer_address` AS customer_address,
        `arachne-multicloud.tpcds.item` AS item
   WHERE ss_sold_date_sk = d_date_sk
     AND ss_store_sk = s_store_sk
     AND ss_promo_sk = p_promo_sk
     AND ss_customer_sk= c_customer_sk
     AND ca_address_sk = c_current_addr_sk
     AND ss_item_sk = i_item_sk
     AND ca_gmt_offset = -5
     AND i_category = 'Jewelry'
     AND (p_channel_dmail = 'Y'
          OR p_channel_email = 'Y'
          OR p_channel_tv = 'Y')
     AND s_gmt_offset = -5
     AND d_year = 1998
     AND d_moy = 11) promotional_sales,
  (SELECT sum(ss_ext_sales_price) total
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.store` AS store,
        `arachne-multicloud.tpcds.date_dim` AS date_dim,
        `arachne-multicloud.tpcds.customer` AS customer,
        `arachne-multicloud.tpcds.customer_address` AS customer_address,
        `arachne-multicloud.tpcds.item` AS item
   WHERE ss_sold_date_sk = d_date_sk
     AND ss_store_sk = s_store_sk
     AND ss_customer_sk= c_customer_sk
     AND ca_address_sk = c_current_addr_sk
     AND ss_item_sk = i_item_sk
     AND ca_gmt_offset = -5
     AND i_category = 'Jewelry'
     AND s_gmt_offset = -5
     AND d_year = 1998
     AND d_moy = 11) all_sales
ORDER BY promotions,
         total
LIMIT 100;

