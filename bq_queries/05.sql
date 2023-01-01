WITH ssr AS
  (SELECT s_store_id,
          sum(sales_price) AS sales,
          sum(profit) AS profit,
          sum(return_amt) AS returns_,
          sum(net_loss) AS profit_loss
   FROM
     (SELECT ss_store_sk AS store_sk,
             ss_sold_date_sk AS date_sk,
             ss_ext_sales_price AS sales_price,
             ss_net_profit AS profit,
             0 AS return_amt,
             0 AS net_loss
      FROM `arachne-multicloud.tpcds.store_sales` AS store_sales
      UNION ALL SELECT sr_store_sk AS store_sk,
                       sr_returned_date_sk AS date_sk,
                       0 AS sales_price,
                       0 AS profit,
                       sr_return_amt AS return_amt,
                       sr_net_loss AS net_loss
      FROM `arachne-multicloud.tpcds.store_returns` AS store_returns ) salesreturns,
        `arachne-multicloud.tpcds.date_dim` AS date_dim,
        `arachne-multicloud.tpcds.store` AS store
   WHERE date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-06' AS date)
     AND store_sk = s_store_sk
   GROUP BY s_store_id),
csr AS
  (SELECT cp_catalog_page_id,
          sum(sales_price) AS sales,
          sum(profit) AS profit,
          sum(return_amt) AS returns_,
          sum(net_loss) AS profit_loss
   FROM
     (SELECT cs_catalog_page_sk AS page_sk,
             cs_sold_date_sk AS date_sk,
             cs_ext_sales_price AS sales_price,
             cs_net_profit AS profit,
             0 AS return_amt,
             0 AS net_loss
      FROM `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales
      UNION ALL SELECT cr_catalog_page_sk AS page_sk,
                       cr_returned_date_sk AS date_sk,
                       0 AS sales_price,
                       0 AS profit,
                       cr_return_amount AS return_amt,
                       cr_net_loss AS net_loss
      FROM `arachne-multicloud.tpcds.catalog_returns` AS catalog_returns ) salesreturns,
        `arachne-multicloud.tpcds.date_dim` AS date_dim,
        `arachne-multicloud.tpcds.catalog_page` AS catalog_page
   WHERE date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-06' AS date)
     AND page_sk = cp_catalog_page_sk
   GROUP BY cp_catalog_page_id),
 wsr AS
  (SELECT web_site_id,
          sum(sales_price) AS sales,
          sum(profit) AS profit,
          sum(return_amt) AS returns_,
          sum(net_loss) AS profit_loss
   FROM
     (SELECT ws_web_site_sk AS wsr_web_site_sk,
             ws_sold_date_sk AS date_sk,
             ws_ext_sales_price AS sales_price,
             ws_net_profit AS profit,
             0 AS return_amt,
             0 AS net_loss
      FROM `arachne-multicloud.tpcds.web_sales` AS web_sales
      UNION ALL SELECT ws_web_site_sk AS wsr_web_site_sk,
                       wr_returned_date_sk AS date_sk,
                       0 AS sales_price,
                       0 AS profit,
                       wr_return_amt AS return_amt,
                       wr_net_loss AS net_loss
      FROM `arachne-multicloud.tpcds.web_returns` AS web_returns
      LEFT OUTER JOIN `arachne-multicloud.tpcds.web_sales` AS web_sales ON (wr_item_sk = ws_item_sk
                                    AND wr_order_number = ws_order_number) ) salesreturns,
        `arachne-multicloud.tpcds.date_dim` AS date_dim,
        `arachne-multicloud.tpcds.web_site` AS web_site
   WHERE date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-06' AS date)
     AND wsr_web_site_sk = web_site_sk
   GROUP BY web_site_id),
 results AS
  (SELECT channel ,
          id ,
          sum(sales) AS sales ,
          sum(returns_) AS returns_ ,
          sum(profit) AS profit
   FROM
     (SELECT 'store channel' AS channel ,
             concat('store', s_store_id) AS id ,
             sales ,
             returns_ ,
             (profit - profit_loss) AS profit
      FROM ssr
      UNION ALL SELECT 'catalog channel' AS channel ,
                       concat('catalog_page', cp_catalog_page_id) AS id ,
                       sales ,
                       returns_ ,
                       (profit - profit_loss) AS profit
      FROM csr
      UNION ALL SELECT 'web channel' AS channel ,
                       concat('web_site', web_site_id) AS id ,
                       sales ,
                       returns_ ,
                       (profit - profit_loss) AS profit
      FROM wsr ) x
   GROUP BY channel,
            id)
SELECT channel,
       id,
       sales,
       returns_,
       profit
FROM
  (SELECT channel,
          id,
          sales,
          returns_,
          profit
   FROM results
   UNION ALL SELECT channel,
                NULL AS id,
                sum(sales),
                sum(returns_),
                sum(profit)
   FROM results
   GROUP BY channel
   UNION ALL SELECT NULL AS channel,
                NULL AS id,
                sum(sales),
                sum(returns_),
                sum(profit)
   FROM results) foo
ORDER BY channel NULLS FIRST,
         id NULLS FIRST
LIMIT 100;
