SELECT i_brand_id brand_id,
       i_brand brand,
       sum(ss_ext_sales_price) ext_price
FROM `arachne-multicloud.tpcds.date_dim` AS date_dim,
     `arachne-multicloud.tpcds.store_sales` AS store_sales,
     `arachne-multicloud.tpcds.item` AS item
WHERE d_date_sk = ss_sold_date_sk
  AND ss_item_sk = i_item_sk
  AND i_manager_id=28
  AND d_moy=11
  AND d_year=1999
GROUP BY i_brand,
         i_brand_id
ORDER BY ext_price DESC,
         i_brand_id
LIMIT 100 ;

