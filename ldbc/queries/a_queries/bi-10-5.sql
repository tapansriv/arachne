SELECT m.friendid AS "person.id"
     , t.t_name AS "tag.name"
     , count(*) AS messageCount
  FROM messages_of_tagclass_by_friends m
     , message_tag pt
     , tag t
 WHERE 1=1
    -- join
   AND m.messageid = pt.mt_messageid
   AND pt.mt_tagid = t.t_tagid
 GROUP BY m.friendid, t.t_name
 ORDER BY messageCount DESC, t.t_name, m.friendid
 LIMIT 100
;
