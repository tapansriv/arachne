with recursive cposts AS (
	  select m_messageid, m_content, m_ps_imagefile, m_creationdate, m_c_replyof, m_creatorid
	  from ldbc.message
	  where m_creatorid = 21990232556256
	  order by m_creationdate desc
	  limit 10
), parent AS (
	  select m_messageid as postid, m_c_replyof as replyof, m_messageid as orig_postid, m_creatorid as creator from cposts
	UNION ALL
	  select m_messageid as postid, m_c_replyof as replyof, orig_postid, m_creatorid as creator 
      from ldbc.message,parent
      where m_messageid=replyof
)
select p1.m_messageid, COALESCE(m_ps_imagefile,'')||COALESCE(m_content,'') as content, p1.m_creationdate,
       p2.m_messageid, p2.p_personid, p2.p_firstname, p2.p_lastname
from 
     (select m_messageid, m_content, m_ps_imagefile, m_creationdate, m_c_replyof from cposts
     ) p1
     left join
     (select orig_postid, postid as m_messageid, p_personid, p_firstname, p_lastname
      from parent, ldbc.person
      where replyof is null and creator = p_personid
     )p2  
     on p2.orig_postid = p1.m_messageid
      order by m_creationdate desc, p2.m_messageid desc;
