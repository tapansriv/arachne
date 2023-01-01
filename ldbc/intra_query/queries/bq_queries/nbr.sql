/* Tapan Written: Compute 2-degree neighborhood for each vertex
\set country  '\'Taiwan\''
\set startPerson 14
 */

-- CREATE TABLE persons_of_country_w_friends AS
WITH country_pop as (
    SELECT co.pl_placeid AS pl_placeid
         , COUNT(p.p_personid) as cnt
      FROM ldbc.person p
         , ldbc.place ci -- city
         , ldbc.place co -- country
     WHERE 1=1
        -- join
       AND p.p_placeid = ci.pl_placeid
       AND ci.pl_containerplaceid = co.pl_placeid
       AND (co.pl_name = 'China' OR co.pl_name = 'India' OR co.pl_name = 'Mexico')
    GROUP BY co.pl_placeid
),
persons_of_country_w_friends AS (
    SELECT p.p_personid AS k_person1id
         , k.k_person2id as k_person2id
         -- , k.k_creationdate as creationdate
      FROM ldbc.person p
         , ldbc.place ci -- city
         , country_pop co -- country
         , ldbc.knows k
     WHERE 1=1
        -- join
       AND p.p_placeid = ci.pl_placeid
       AND ci.pl_containerplaceid = co.pl_placeid
       AND p.p_personid = k.k_person1id
        -- filter
       AND co.cnt > 100
       AND 1354147200000 <= k.k_creationdate
       AND k.k_creationdate <= 1362441600000
       -- AND to_timestamp(k.k_creationdate/1000) between '2012-11-29' and '2013-03-05'
) -- SELECT COUNT(*) from persons_of_country_w_friends;
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
