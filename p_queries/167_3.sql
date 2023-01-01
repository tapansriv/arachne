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

