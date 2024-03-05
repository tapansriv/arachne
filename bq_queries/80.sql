WITH ssr AS
  (SELECT s_store_id AS store_id,
          sum(ss_ext_sales_price) AS sales,
          sum(coalesce(sr_return_amt, 0)) AS returns_,
          sum(ss_net_profit - coalesce(sr_net_loss, 0)) AS profit
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales
   LEFT OUTER JOIN `arachne-multicloud.tpcds.store_returns` AS store_returns ON (ss_item_sk = sr_item_sk
                                     AND ss_ticket_number = sr_ticket_number), `arachne-multicloud.tpcds.date_dim` AS date_dim,
                                                                               `arachne-multicloud.tpcds.store` AS store,
                                                                               `arachne-multicloud.tpcds.item` AS item,
                                                                               `arachne-multicloud.tpcds.promotion` AS promotion
   WHERE ss_sold_date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-22' AS date)
     AND ss_store_sk = s_store_sk
     AND ss_item_sk = i_item_sk
     AND i_current_price > 50
     AND ss_promo_sk = p_promo_sk
     AND p_channel_tv = 'N'
   GROUP BY s_store_id), 
 csr AS
  (SELECT cp_catalog_page_id AS catalog_page_id,
          sum(cs_ext_sales_price) AS sales,
          sum(coalesce(cr_return_amount, 0)) AS returns_,
          sum(cs_net_profit - coalesce(cr_net_loss, 0)) AS profit
   FROM `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales
   LEFT OUTER JOIN `arachne-multicloud.tpcds.catalog_returns` AS catalog_returns ON (cs_item_sk = cr_item_sk
                                       AND cs_order_number = cr_order_number), `arachne-multicloud.tpcds.date_dim` AS date_dim,
                                                                               `arachne-multicloud.tpcds.catalog_page` AS catalog_page,
                                                                               `arachne-multicloud.tpcds.item` AS item,
                                                                               `arachne-multicloud.tpcds.promotion` AS promotion
   WHERE cs_sold_date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-22' AS date)
     AND cs_catalog_page_sk = cp_catalog_page_sk
     AND cs_item_sk = i_item_sk
     AND i_current_price > 50
     AND cs_promo_sk = p_promo_sk
     AND p_channel_tv = 'N'
   GROUP BY cp_catalog_page_id), 
 wsr AS
  (SELECT web_site_id,
          sum(ws_ext_sales_price) AS sales,
          sum(coalesce(wr_return_amt, 0)) AS returns_,
          sum(ws_net_profit - coalesce(wr_net_loss, 0)) AS profit
   FROM `arachne-multicloud.tpcds.web_sales` AS web_sales
   LEFT OUTER JOIN `arachne-multicloud.tpcds.web_returns` AS web_returns ON (ws_item_sk = wr_item_sk
                                   AND ws_order_number = wr_order_number), `arachne-multicloud.tpcds.date_dim` AS date_dim,
                                                                           `arachne-multicloud.tpcds.web_site` AS web_site,
                                                                           `arachne-multicloud.tpcds.item` AS item,
                                                                           `arachne-multicloud.tpcds.promotion` AS promotion
   WHERE ws_sold_date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-22' AS date)
     AND ws_web_site_sk = web_site_sk
     AND ws_item_sk = i_item_sk
     AND i_current_price > 50
     AND ws_promo_sk = p_promo_sk
     AND p_channel_tv = 'N'
   GROUP BY web_site_id),
 results AS
  (SELECT channel ,
          id ,
          sum(sales) AS sales ,
          sum(returns_) AS returns_ ,
          sum(profit) AS profit
   FROM
     (SELECT 'store channel' AS channel ,
             concat('store', store_id) AS id ,
             sales ,
             returns_ ,
             profit
      FROM ssr
      UNION ALL SELECT 'catalog channel' AS channel ,
                       concat('catalog_page', catalog_page_id) AS id ,
                       sales ,
                       returns_ ,
                       profit
      FROM csr
      UNION ALL SELECT 'web channel' AS channel ,
                       concat('web_site', web_site_id) AS id ,
                       sales ,
                       returns_ ,
                       profit
      FROM wsr ) x
   GROUP BY channel,
            id)
SELECT channel ,
       id ,
       sales ,
       returns_ ,
       profit
FROM
  ( SELECT channel,
           id,
           sales,
           returns_,
           profit
   FROM results
   UNION ALL SELECT channel,
                NULL AS id,
                sum(sales) AS sales,
                sum(returns_) AS returns_,
                sum(profit) AS profit
   FROM results
   GROUP BY channel
   UNION ALL SELECT NULL AS channel,
                NULL AS id,
                sum(sales) AS sales,
                sum(returns_) AS returns_,
                sum(profit) AS profit
   FROM results ) foo
ORDER BY channel NULLS FIRST,
         id NULLS FIRST
LIMIT 100;

