CREATE TABLE results_rollup AS
  (SELECT gross_margin,
          i_category,
          i_class,
          0 AS t_category,
          0 AS t_class,
          0 AS lochierarchy
   FROM results2
   UNION SELECT (sum(ss_net_profit)*1.0000)/sum(ss_ext_sales_price) AS gross_margin,
                i_category,
                NULL AS i_class,
                0 AS t_category,
                1 AS t_class,
                1 AS lochierarchy
   FROM results2
   GROUP BY i_category
   UNION SELECT (sum(ss_net_profit)*1.0000)/sum(ss_ext_sales_price) AS gross_margin,
                NULL AS i_category,
                NULL AS i_class,
                1 AS t_category,
                1 AS t_class,
                2 AS lochierarchy
   FROM results2);

