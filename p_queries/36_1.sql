CREATE TABLE results AS
  (SELECT ss_net_profit,
          ss_ext_sales_price,
          ss_store_sk,
          ss_item_sk,
          0 AS g_category,
          0 AS g_class
   FROM 'store_sales.parquet' AS store_sales ,
        'date_dim.parquet' d1
   WHERE d1.d_year = 2001
     AND d1.d_date_sk = ss_sold_date_sk);
