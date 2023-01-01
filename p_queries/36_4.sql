SELECT gross_margin,
       i_category,
       i_class,
       lochierarchy,
       rank() OVER ( PARTITION BY lochierarchy,
                                  CASE
                                      WHEN t_class = 0 THEN i_category
                                  END
                    ORDER BY gross_margin ASC) AS rank_within_parent
FROM results_rollup
ORDER BY lochierarchy DESC NULLS FIRST,
         CASE
             WHEN lochierarchy = 0 THEN i_category
         END NULLS FIRST,
         rank_within_parent NULLS FIRST
LIMIT 100;


