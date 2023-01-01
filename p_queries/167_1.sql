CREATE TABLE results AS
  (SELECT i_category,
          i_class,
          i_brand,
          i_product_name,
          d_year,
          d_qoy,
          d_moy,
          wp_web_page_id ,
          sum(coalesce(ws_sales_price*ws_quantity,0)) sumsales
   FROM '/mnt/disks/tpcds/parquet/web_sales.parquet',
        '/mnt/disks/tpcds/parquet/date_dim.parquet',
        '/mnt/disks/tpcds/parquet/web_page.parquet',
        '/mnt/disks/tpcds/parquet/item.parquet'
   WHERE ws_sold_date_sk=d_date_sk
     AND ws_item_sk=i_item_sk
     -- AND ss_store_sk = s_store_sk
     AND ws_web_page_sk = wp_web_page_sk
     AND d_month_seq BETWEEN 1200 AND 1200 + 11
   GROUP BY i_category,
            i_class,
            i_brand,
            i_product_name,
            d_year,
            d_qoy,
            d_moy,
            wp_web_page_id);

