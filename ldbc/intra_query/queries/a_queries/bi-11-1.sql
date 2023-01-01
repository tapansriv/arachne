/* Q11. Friend triangles
\set country  '\'China\''
2012-11-29
2013-03-05
 */

CREATE TABLE persons_of_country_w_friends AS
    SELECT p.p_personid AS personid
         , k.k_person2id as friendid
         , k.k_creationdate as creationdate
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
;
