/* Q11. Friend triangles
\set country  '\'China\''
2012-11-29
2013-03-05
 */

-- pragma enable_profiling;

WITH persons_of_country_w_friends AS (
    SELECT p.p_personid AS personid
         , k.k_person2id as friendid
      FROM person p
         , place ci -- city
         , place co -- country
         , knows k
     WHERE 1=1
        -- join
       AND p.p_placeid = ci.pl_placeid
       AND ci.pl_containerplaceid = co.pl_placeid
       AND p.p_personid = k.k_person1id
        -- filter
       AND co.pl_name = 'China'
       AND 1354147200000 <= k.k_creationdate
       AND k.k_creationdate <= 1362441600000
       -- AND to_timestamp(k.k_creationdate/1000) between '2012-11-29' and '2013-03-05'
)
SELECT count(*)
  FROM persons_of_country_w_friends p1
     , persons_of_country_w_friends p2
     , persons_of_country_w_friends p3
     , persons_of_country_w_friends p4
 WHERE 1=1
    -- join
   AND p1.friendid = p2.personid
   AND p2.friendid = p3.personid
   AND p3.friendid = p4.personid
   AND p4.friendid = p1.personid
    -- filter: unique trinagles only
   AND p1.personid < p2.personid
   AND p2.personid < p3.personid
   AND p3.personid < p4.personid
;
