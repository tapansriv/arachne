CREATE TABLE messages_of_tagclass_by_friends AS
    SELECT DISTINCT f.friendid
         , m.m_messageid AS messageid
      FROM friend_list f
         , message m
         , message_tag pt
         , tag t
         , tagclass tc
     WHERE 1=1
        -- join
       AND f.friendid = m.m_creatorid
       AND m.m_messageid = pt.mt_messageid
       AND pt.mt_tagid = t.t_tagid
       AND t.t_tagclassid = tc.tc_tagclassid
        -- filter
       AND tc.tc_name = 'AmericanFootballPlayer';
