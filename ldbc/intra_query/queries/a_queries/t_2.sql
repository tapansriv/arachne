WITH RECURSIVE graph_search(node_id, connected_to, path, cycle) AS (
        SELECT node_id, connected_to, [node_id], false FROM persons_of_country_w_friends
    UNION
        SELECT p.node_id, p.connected_to, gs.path || p.node_id, p.node_id=ANY(gs.path)
        FROM graph_search gs JOIN persons_of_country_w_friends p ON gs.connected_to = p.node_id AND NOT gs.cycle
)
SELECT count(DISTINCT component)
FROM (
        SELECT node_id,
               array_agg(DISTINCT reachable_node ORDER BY reachable_node) as component
        FROM (
            SELECT node_id, unnest(path) as reachable_node from graph_search
        ) sub
        GROUP BY node_id
    -- UNION ALL /*need to append lonely nodes - they are components for themselves*/
    --     SELECT p_personid, ARRAY[p_personid]
    --     FROM person p
    --     WHERE p_personid NOT IN (SELECT k_person1id from knows)
) sub;


