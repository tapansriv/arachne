CREATE TABLE results2 AS
  (SELECT sum(ss_net_profit) AS ss_net_profit,
          sum(ss_ext_sales_price) AS ss_ext_sales_price,
          (sum(ss_net_profit)*1.0000)/sum(ss_ext_sales_price) AS gross_margin ,
          i_category ,
          i_class ,
          0 AS g_category,
          0 AS g_class
   FROM results,
        'item.parquet' AS item ,
        'store.parquet' AS store
   WHERE i_item_sk = ss_item_sk
     AND s_store_sk = ss_store_sk
     AND s_state ='TN'
   GROUP BY i_category,
            i_class);

