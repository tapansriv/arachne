/* Q3. Popular topics in a country
\set ldbc.tagclass '\'MusicalArtist\''
\set country  '\'Burma\''
 */
SELECT f.f_forumid      AS forumid
     , f.f_title        AS forumtitle
     , f.f_creationdate AS forumcreationDate
     , f.f_moderatorid  AS personid
     , count(DISTINCT p.m_messageid) AS postCount
  FROM ldbc.tagclass tc
     , ldbc.tag t
     , ldbc.message_tag pt
     , ldbc.message p
     , ldbc.forum f
     , ldbc.person m   -- moderator
     , ldbc.place  ci  -- city
     , ldbc.place  co  -- country
 WHERE 1=1
    -- join
   AND tc.tc_tagclassid = t.t_tagclassid
   AND t.t_tagid = pt.mt_tagid
   AND pt.mt_messageid = p.m_messageid
   AND p.m_ps_forumid = f.f_forumid
   AND f.f_moderatorid = m.p_personid
   AND m.p_placeid = ci.pl_placeid
   AND ci.pl_containerplaceid = co.pl_placeid
    -- filter
   AND tc.tc_name = 'MusicalArtist'
   AND co.pl_name = 'Burma'
 GROUP BY f.f_forumid, f.f_title, f.f_creationdate, f.f_moderatorid
 ORDER BY postCount DESC, f.f_forumid
 LIMIT 20
;
