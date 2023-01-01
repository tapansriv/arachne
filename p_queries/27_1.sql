CREATE TABLE results AS
  (SELECT i_item_id,
          s_state,
          0 AS g_state,
          ss_quantity agg1,
          ss_list_price agg2,
          ss_coupon_amt agg3,
          ss_sales_price agg4
   FROM 'store_sales.parquet' AS store_sales,
        'customer_demographics.parquet' AS customer_demographics,
        'date_dim.parquet' AS date_dim,
        'store.parquet' AS store,
        'item.parquet' AS item
   WHERE ss_sold_date_sk = d_date_sk
     AND ss_item_sk = i_item_sk
     AND ss_store_sk = s_store_sk
     AND ss_cdemo_sk = cd_demo_sk
     AND cd_gender = 'M'
     AND cd_marital_status = 'S'
     AND cd_education_status = 'College'
     AND d_year = 2002
     AND s_state = 'TN' );

