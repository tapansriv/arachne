/* Tapan Written: Compute 2-degree neighborhood for each vertex
\set country  '\'Taiwan\''
\set startPerson 14
 */

pragma enable_profiling = 'json';
pragma profile_output = 'nbr_1.json';
drop table if exists persons_of_country_w_friends;
CREATE TABLE persons_of_country_w_friends AS
WITH country_pop as (
    SELECT co.pl_placeid AS pl_placeid
         , COUNT(p.p_personid) as cnt
      FROM person p
         , place ci -- city
         , place co -- country
     WHERE 1=1
        -- join
       AND p.p_placeid = ci.pl_placeid
       AND ci.pl_containerplaceid = co.pl_placeid
       AND (co.pl_name = 'China' OR co.pl_name = 'India' OR co.pl_name = 'Mexico')
    GROUP BY co.pl_placeid
)
SELECT p.p_personid AS k_person1id
     , k.k_person2id as k_person2id
     -- , k.k_creationdate as creationdate
  FROM person p
     , place ci -- city
     , country_pop co -- country
     , knows k
 WHERE 1=1
    -- join
   AND p.p_placeid = ci.pl_placeid
   AND ci.pl_containerplaceid = co.pl_placeid
   AND p.p_personid = k.k_person1id
    -- filter
   AND co.cnt > 100
   AND to_timestamp(k.k_creationdate/1000) between '2012-11-29' and '2013-03-05';
