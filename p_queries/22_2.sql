CREATE TABLE results_rollup AS
  (SELECT i_product_name,
          i_brand,
          i_class,
          i_category,
          avg(qoh) qoh
   FROM results
   GROUP BY i_product_name,
            i_brand,
            i_class,
            i_category
   UNION ALL SELECT i_product_name,
                    i_brand,
                    i_class,
                    NULL i_category,
                         avg(qoh) qoh
   FROM results
   GROUP BY i_product_name,
            i_brand,
            i_class
   UNION ALL SELECT i_product_name,
                    i_brand,
                    NULL i_class,
                         NULL i_category,
                              avg(qoh) qoh
   FROM results
   GROUP BY i_product_name,
            i_brand
   UNION ALL SELECT i_product_name,
                    NULL i_brand,
                         NULL i_class,
                              NULL i_category,
                                   avg(qoh) qoh
   FROM results
   GROUP BY i_product_name
   UNION ALL SELECT NULL i_product_name,
                         NULL i_brand,
                              NULL i_class,
                                   NULL i_category,
                                        avg(qoh) qoh
   FROM results);

