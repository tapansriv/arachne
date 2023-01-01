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
CREATE TABLE results_rollup AS
  (SELECT i_category,
          i_class,
          i_brand,
          i_product_name,
          d_year,
          d_qoy,
          d_moy,
          wp_web_page_id,
          sumsales
   FROM results
   UNION ALL SELECT i_category,
                    i_class,
                    i_brand,
                    i_product_name,
                    d_year,
                    d_qoy,
                    d_moy,
                    NULL wp_web_page_id,
                         sum(sumsales) sumsales
   FROM results
   GROUP BY i_category,
            i_class,
            i_brand,
            i_product_name,
            d_year,
            d_qoy,
            d_moy
   UNION ALL SELECT i_category,
                    i_class,
                    i_brand,
                    i_product_name,
                    d_year,
                    d_qoy,
                    NULL d_moy,
                         NULL wp_web_page_id,
                              sum(sumsales) sumsales
   FROM results
   GROUP BY i_category,
            i_class,
            i_brand,
            i_product_name,
            d_year,
            d_qoy
   UNION ALL SELECT i_category,
                    i_class,
                    i_brand,
                    i_product_name,
                    d_year,
                    NULL d_qoy,
                         NULL d_moy,
                              NULL wp_web_page_id,
                                   sum(sumsales) sumsales
   FROM results
   GROUP BY i_category,
            i_class,
            i_brand,
            i_product_name,
            d_year
   UNION ALL SELECT i_category,
                    i_class,
                    i_brand,
                    i_product_name,
                    NULL d_year,
                         NULL d_qoy,
                              NULL d_moy,
                                   NULL wp_web_page_id,
                                        sum(sumsales) sumsales
   FROM results
   GROUP BY i_category,
            i_class,
            i_brand,
            i_product_name
   UNION ALL SELECT i_category,
                    i_class,
                    i_brand,
                    NULL i_product_name,
                         NULL d_year,
                              NULL d_qoy,
                                   NULL d_moy,
                                        NULL wp_web_page_id,
                                             sum(sumsales) sumsales
   FROM results
   GROUP BY i_category,
            i_class,
            i_brand
   UNION ALL SELECT i_category,
                    i_class,
                    NULL i_brand,
                         NULL i_product_name,
                              NULL d_year,
                                   NULL d_qoy,
                                        NULL d_moy,
                                             NULL wp_web_page_id,
                                                  sum(sumsales) sumsales
   FROM results
   GROUP BY i_category,
            i_class
   UNION ALL SELECT i_category,
                    NULL i_class,
                         NULL i_brand,
                              NULL i_product_name,
                                   NULL d_year,
                                        NULL d_qoy,
                                             NULL d_moy,
                                                  NULL wp_web_page_id,
                                                       sum(sumsales) sumsales
   FROM results
   GROUP BY i_category
   UNION ALL SELECT NULL i_category,
                         NULL i_class,
                              NULL i_brand,
                                   NULL i_product_name,
                                        NULL d_year,
                                             NULL d_qoy,
                                                  NULL d_moy,
                                                       NULL wp_web_page_id,
                                                            sum(sumsales) sumsales
   FROM results);
SELECT *
FROM
  (SELECT i_category ,
          i_class ,
          i_brand ,
          i_product_name ,
          d_year ,
          d_qoy ,
          d_moy ,
          wp_web_page_id ,
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
         wp_web_page_id NULLS LAST,
         sumsales NULLS LAST,
         rk NULLS LAST
LIMIT 100;

