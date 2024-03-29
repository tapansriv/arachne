select p2.m_messageid, p2.m_content, p2.m_creationdate, p_personid, p_firstname, p_lastname,
    (case when exists (
     	   	       select 1 from ldbc.knows
		       where p1.m_creatorid = k_person1id and p2.m_creatorid = k_person2id)
      then TRUE
      else FALSE
      end) as knows2
from ldbc.message p1, ldbc.message p2, ldbc.person
where
  p1.m_messageid = 687194767741 and p2.m_c_replyof = p1.m_messageid and p2.m_creatorid = p_personid
order by p2.m_creationdate desc, p2.m_creatorid asc;
