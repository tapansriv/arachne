/* Tapan Written: Compute 2-degree neighborhood for each vertex
\set country  '\'Taiwan\''
\set startPerson 14
 */

pragma enable_profiling = 'json';
pragma profile_output = 'nbr_2.json';
SELECT paths.src, paths.dst, min(paths.w) FROM (
      SELECT 28587302322191 as src, 28587302322191 as dst, 0 as w 
      UNION ALL 
      SELECT p.k_person1id as src, p.k_person2id as dst, 1 as w
        FROM persons_of_country_w_friends p
        WHERE 1=1
          AND p.k_person1id = 28587302322191
      UNION ALL
      SELECT p1.k_person1id as src, p2.k_person2id as dst, 2 as w 
        FROM persons_of_country_w_friends p1
           , persons_of_country_w_friends p2
         WHERE 1=1
            -- join
           AND p1.k_person2id = p2.k_person1id
            -- filter: neighbors of the start person 
           AND p1.k_person1id = 28587302322191
      UNION ALL
      SELECT p1.k_person1id as src, p2.k_person2id as dst, 3 as w 
        FROM persons_of_country_w_friends p1
           , persons_of_country_w_friends p2
           , persons_of_country_w_friends p3
         WHERE 1=1
            -- join
           AND p1.k_person2id = p2.k_person1id
           AND p2.k_person2id = p3.k_person1id
            -- filter: neighbors of the start person 
           AND p1.k_person1id = 28587302322191
      UNION ALL
      SELECT p1.k_person1id as src, p2.k_person2id as dst, 4 as w 
        FROM persons_of_country_w_friends p1
           , persons_of_country_w_friends p2
           , persons_of_country_w_friends p3
           , persons_of_country_w_friends p4
         WHERE 1=1
            -- join
           AND p1.k_person2id = p2.k_person1id
           AND p2.k_person2id = p3.k_person1id
           AND p3.k_person2id = p4.k_person1id
            -- filter: neighbors of the start person 
           AND p1.k_person1id = 28587302322191
      -- UNION ALL
      -- SELECT p1.k_person1id as src, p2.k_person2id as dst, 5 as w 
      --   FROM persons_of_country_w_friends p1
      --      , persons_of_country_w_friends p2
      --      , persons_of_country_w_friends p3
      --      , persons_of_country_w_friends p4
      --      , persons_of_country_w_friends p5
      --    WHERE 1=1
      --       -- join
      --      AND p1.k_person2id = p2.k_person1id
      --      AND p2.k_person2id = p3.k_person1id
      --      AND p3.k_person2id = p4.k_person1id
      --      AND p4.k_person2id = p5.k_person1id
      --       -- filter: neighbors of the start person 
      --      AND p1.k_person1id = 28587302322191
) paths
GROUP BY paths.src, paths.dst
;
