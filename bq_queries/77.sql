WITH ss AS
  (SELECT s_store_sk,
          sum(ss_ext_sales_price) AS sales,
          sum(ss_net_profit) AS profit
   FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
        `arachne-multicloud.tpcds.date_dim` AS date_dim,
        `arachne-multicloud.tpcds.store` AS store
   WHERE ss_sold_date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-22' AS date)
     AND ss_store_sk = s_store_sk
   GROUP BY s_store_sk),
 sr AS
  (SELECT s_store_sk,
          sum(sr_return_amt) AS returns_,
          sum(sr_net_loss) AS profit_loss
   FROM `arachne-multicloud.tpcds.store_returns` AS store_returns,
        `arachne-multicloud.tpcds.date_dim` AS date_dim,
        `arachne-multicloud.tpcds.store` AS store
   WHERE sr_returned_date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-22' AS date)
     AND sr_store_sk = s_store_sk
   GROUP BY s_store_sk),
 cs AS
  (SELECT cs_call_center_sk,
          sum(cs_ext_sales_price) AS sales,
          sum(cs_net_profit) AS profit
   FROM `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales,
        `arachne-multicloud.tpcds.date_dim` AS date_dim
   WHERE cs_sold_date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-22' AS date)
   GROUP BY cs_call_center_sk),
 cr AS
  (SELECT cr_call_center_sk,
          sum(cr_return_amount) AS returns_,
          sum(cr_net_loss) AS profit_loss
   FROM `arachne-multicloud.tpcds.catalog_returns` AS catalog_returns,
        `arachne-multicloud.tpcds.date_dim` AS date_dim
   WHERE cr_returned_date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-22' AS date)
   GROUP BY cr_call_center_sk),
 ws AS
  (SELECT wp_web_page_sk,
          sum(ws_ext_sales_price) AS sales,
          sum(ws_net_profit) AS profit
   FROM `arachne-multicloud.tpcds.web_sales` AS web_sales,
        `arachne-multicloud.tpcds.date_dim` AS date_dim,
        `arachne-multicloud.tpcds.web_page` AS web_page
   WHERE ws_sold_date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-22' AS date)
     AND ws_web_page_sk = wp_web_page_sk
   GROUP BY wp_web_page_sk),
 wr AS
  (SELECT wp_web_page_sk,
          sum(wr_return_amt) AS returns_,
          sum(wr_net_loss) AS profit_loss
   FROM `arachne-multicloud.tpcds.web_returns` AS web_returns,
        `arachne-multicloud.tpcds.date_dim` AS date_dim,
        `arachne-multicloud.tpcds.web_page` AS web_page
   WHERE wr_returned_date_sk = d_date_sk
     AND cast(d_date as date) BETWEEN cast('2000-08-23' AS date) AND cast('2000-09-22' AS date)
     AND wr_web_page_sk = wp_web_page_sk
   GROUP BY wp_web_page_sk),
 results AS
  (SELECT channel ,
          id ,
          sum(sales) AS sales ,
          sum(returns_) AS returns_ ,
          sum(profit) AS profit
   FROM
     (SELECT 'store channel' AS channel ,
             ss.s_store_sk AS id ,
             sales ,
             coalesce(returns_, 0) AS returns_ ,
             (profit - coalesce(profit_loss,0)) AS profit
      FROM ss
      LEFT JOIN sr ON ss.s_store_sk = sr.s_store_sk
      UNION ALL SELECT 'catalog channel' AS channel ,
                       cs_call_center_sk AS id ,
                       sales ,
                       returns_ ,
                       (profit - profit_loss) AS profit
      FROM cs ,
           cr
      UNION ALL SELECT 'web channel' AS channel ,
                       ws.wp_web_page_sk AS id ,
                       sales ,
                       coalesce(returns_, 0) returns_ ,
                       (profit - coalesce(profit_loss,0)) AS profit
      FROM ws
      LEFT JOIN wr ON ws.wp_web_page_sk = wr.wp_web_page_sk ) x
   GROUP BY channel,
            id)
SELECT *
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
   FROM results) foo
ORDER BY channel NULLS FIRST,
         id NULLS FIRST
LIMIT 100;
