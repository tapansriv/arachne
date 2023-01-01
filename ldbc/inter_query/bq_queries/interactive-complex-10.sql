select p_personid, p_firstname, p_lastname,
       ( select count(distinct m_messageid)
         from ldbc.message, ldbc.message_tag pt1
         where
         m_creatorid = p_personid and
         m_c_replyof IS NULL and -- post, not comment
         m_messageid = mt_messageid and
         exists (select * from ldbc.person_tag where pt_personid = 21990232556256 and pt_tagid = pt1.mt_tagid)
       ) -
       ( select count(*)
         from ldbc.message
         where
         m_creatorid = p_personid and
         m_c_replyof IS NULL and -- post, not comment
         not exists (select * from ldbc.person_tag, ldbc.message_tag where pt_personid = 21990232556256 and pt_tagid = mt_tagid and mt_messageid = m_messageid)
       ) as score,
       p_gender, pl_name
from ldbc.person, ldbc.place,
 ( select distinct k2.k_person2id
   from ldbc.knows k1, ldbc.knows k2
   where
   k1.k_person1id = 21990232556256 and k1.k_person2id = k2.k_person1id and k2.k_person2id <> 21990232556256 and
   not exists (select * from ldbc.knows where k_person1id = 21990232556256 and k_person2id = k2.k_person2id)
 ) f
where
p_placeid = pl_placeid and
p_personid = f.k_person2id and
(
	(extract(month from cast(p_birthday as timestamp)) = 10 and (case when extract(day from cast(p_birthday as timestamp)) >= 21 then true else false end)) -- :month
	or
	(extract(month from cast(p_birthday as timestamp)) = 11 and (case when extract(day from cast(p_birthday as timestamp)) <  22 then true else false end)) -- :nextMonth
)
order by score desc, p_personid
limit 10
;
