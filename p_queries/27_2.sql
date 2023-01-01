SELECT i_item_id,
       s_state,
       g_state,
       agg1,
       agg2,
       agg3,
       agg4
FROM
  ( SELECT i_item_id,
           s_state,
           0 AS g_state,
           avg(agg1) agg1,
           avg(agg2) agg2,
           avg(agg3) agg3,
           avg(agg4) agg4
   FROM results
   GROUP BY i_item_id ,
            s_state
   UNION ALL SELECT i_item_id,
                    NULL AS s_state,
                    1 AS g_state,
                    avg(agg1) agg1,
                    avg(agg2) agg2,
                    avg(agg3) agg3,
                    avg(agg4) agg4
   FROM results
   GROUP BY i_item_id
   UNION ALL SELECT NULL AS i_item_id,
                    NULL AS s_state,
                    1 AS g_state,
                    avg(agg1) agg1,
                    avg(agg2) agg2,
                    avg(agg3) agg3,
                    avg(agg4) agg4
   FROM results ) foo
ORDER BY i_item_id NULLS FIRST,
         s_state NULLS FIRST
LIMIT 100;

