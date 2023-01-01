SELECT i_category,
        i_class,
        i_brand,
        i_product_name,
        d_year,
        d_qoy,
        d_moy,
        s_store_id,
        sumsales
 FROM results
 UNION ALL SELECT i_category,
                  i_class,
                  i_brand,
                  i_product_name,
                  d_year,
                  d_qoy,
                  d_moy,
                  NULL s_store_id,
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
                       NULL s_store_id,
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
                            NULL s_store_id,
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
                                 NULL s_store_id,
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
                                      NULL s_store_id,
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
                                           NULL s_store_id,
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
                                                NULL s_store_id,
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
                                                     NULL s_store_id,
                                                          sum(sumsales) sumsales
 FROM results;

