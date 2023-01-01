SELECT i_item_id,
       ss_quantity,
       ss_list_price,
       ss_coupon_amt,
       ss_sales_price
FROM 'store_sales.parquet' AS store_sales,
     'customer_demographics.parquet' AS customer_demographics,
     'date_dim.parquet' AS date_dim,
     'item.parquet' AS item,
     'promotion.parquet' AS promotion
WHERE ss_sold_date_sk = d_date_sk
  AND ss_item_sk = i_item_sk
  AND ss_cdemo_sk = cd_demo_sk
  AND ss_promo_sk = p_promo_sk
  AND cd_gender = 'M'
  AND cd_marital_status = 'S'
  AND cd_education_status = 'College'
  AND (p_channel_email = 'N'
       OR p_channel_event = 'N')
  AND d_year = 2000;

