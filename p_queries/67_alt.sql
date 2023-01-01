CREATE TABLE results_rollup AS
  (SELECT i_category,
          i_class,
          i_brand,
          i_product_name,
          d_year,
          d_qoy,
          d_moy,
          s_store_id ,
          sum(coalesce(ss_sales_price*ss_quantity,0)) sumsales
   FROM '/mnt/disks/tpcds/parquet/store_sales.parquet',
        '/mnt/disks/tpcds/parquet/date_dim.parquet',
        '/mnt/disks/tpcds/parquet/store.parquet',
        '/mnt/disks/tpcds/parquet/item.parquet'
   WHERE ss_sold_date_sk=d_date_sk
     AND ss_item_sk=i_item_sk
     AND ss_store_sk = s_store_sk
     AND d_month_seq BETWEEN 1200 AND 1200 + 11
   GROUP BY i_category,
            i_class,
            i_brand,
            i_product_name,
            d_year,
            d_qoy,
            d_moy,
            s_store_id);
SELECT *
FROM
  (SELECT i_category ,
          i_class ,
          i_brand ,
          i_product_name ,
          d_year ,
          d_qoy ,
          d_moy ,
          s_store_id ,
          sumsales ,
          rank() OVER (PARTITION BY i_category
                       ORDER BY sumsales DESC) rk
   FROM results_rollup) dw2
WHERE rk <= 100
ORDER BY i_category NULLS LAST,
         i_class NULLS LAST,
         i_brand NULLS LAST,
         i_product_name NULLS LAST,
         d_year NULLS LAST,
         d_qoy NULLS LAST,
         d_moy NULLS LAST,
         s_store_id NULLS LAST,
         sumsales NULLS LAST,
         rk NULLS LAST
LIMIT 100;


