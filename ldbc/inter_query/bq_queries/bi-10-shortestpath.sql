/* Q10. Experts in social circle using shortest path semantics between startPerson and friends
\set personId 19791209310731
\set country '\'Pakistan\''
\set tagclass '\'MusicalArtist\''
\set minPathDistance 3
\set maxPathDistance 5
 */
WITH RECURSIVE friends AS (
    SELECT p_personid as startPerson, 0 as hopCount, p_personid as friend
      FROM ldbc.person
     WHERE 1=1
       AND p_personid = 19791209310731
  UNION ALL
    SELECT f.startPerson as startPerson
         , f.hopCount+1 as hopCount
         , CASE WHEN f.friend = k.k_person1id then k.k_person2id ELSE k.k_person1id END as friend
      FROM friends f
         , ldbc.knows k
     WHERE 1=1
        -- join
       AND f.friend = k.k_person1id -- note, that knows table have both (p1, p2) and (p2, p1)
        -- filter
        -- stop condition
       AND f.hopCount < 5
)
   , friends_shortest AS (
     -- if a friend is reachable from startPerson using hopCount 2, 3 and 4, its distance from startPerson is 2
    SELECT startPerson, min(hopCount) AS hopCount, friend
      FROM friends
     GROUP BY startPerson, friend
)
   , friend_list AS (
    SELECT DISTINCT f.friend AS friendid
      FROM friends_shortest f
         , ldbc.person tf -- the friend's preson record
         , ldbc.place ci -- city
         , ldbc.place co -- country
     WHERE 1=1
        -- join
       AND f.friend = tf.p_personid
       AND tf.p_placeid = ci.pl_placeid
       AND ci.pl_containerplaceid = co.pl_placeid
        -- filter
       AND f.hopCount BETWEEN 3 AND 5
       AND co.pl_name = 'Pakistan'
)
   , messages_of_tagclass_by_friends AS (
    SELECT DISTINCT f.friendid
         , m.m_messageid AS messageid
      FROM friend_list f
         , ldbc.message m
         , ldbc.message_tag pt
         , ldbc.tag t
         , ldbc.tagclass tc
     WHERE 1=1
        -- join
       AND f.friendid = m.m_creatorid
       AND m.m_messageid = pt.mt_messageid
       AND pt.mt_tagid = t.t_tagid
       AND t.t_tagclassid = tc.tc_tagclassid
        -- filter
       AND tc.tc_name = 'MusicalArtist'
)
SELECT m.friendid AS personid
     , t.t_name AS tagname
     , count(*) AS messageCount
  FROM messages_of_tagclass_by_friends m
     , ldbc.message_tag pt
     , ldbc.tag t
 WHERE 1=1
    -- join
   AND m.messageid = pt.mt_messageid
   AND pt.mt_tagid = t.t_tagid
 GROUP BY m.friendid, t.t_name
 ORDER BY messageCount DESC, t.t_name, m.friendid
 LIMIT 100
;
