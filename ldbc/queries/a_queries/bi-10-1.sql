/* Q10. Experts in social circle using shortest path semantics between startPerson and friends
\set personId 19791209310731
\set country '\'Pakistan\''
\set tagClass '\'MusicalArtist\''
\set minPathDistance 3
\set maxPathDistance 5
 */
CREATE TABLE friends AS 
WITH RECURSIVE tmp_friends(startPerson, hopCount, friend) AS (
    SELECT p_personid, 0, p_personid
      FROM person
     WHERE 1=1
       AND p_personid = 14
  UNION
    SELECT f.startPerson
         , f.hopCount+1
         , CASE WHEN f.friend = k.k_person1id then k.k_person2id ELSE k.k_person1id END
      FROM tmp_friends f
         , knows k
     WHERE 1=1
        -- join
       AND f.friend = k.k_person1id -- note, that knows table have both (p1, p2) and (p2, p1)
        -- filter
        -- stop condition
       AND f.hopCount < 5
) SELECT * FROM tmp_friends;
