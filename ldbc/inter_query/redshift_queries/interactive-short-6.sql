-- WITH RECURSIVE chain(parent, child) as(
-- 	SELECT m_c_replyof, m_messageid FROM message where m_messageid = 687194767741
-- 	UNION ALL
-- 	SELECT p.m_c_replyof, p.m_messageid FROM message p, chain c where p.m_messageid = c.parent 
-- )
-- select f_forumid, f_title, p_personid, p_firstname, p_lastname
-- from message, person, forum
-- where m_messageid = (select coalesce(min(parent), 687194767741) from chain)
--   and m_ps_forumid = f_forumid and f_moderatorid = p_personid;

WITH RECURSIVE chain(parent, child) as(
	SELECT m_c_replyof, m_messageid FROM message where m_messageid = 687194767741
	UNION ALL
	SELECT p.m_c_replyof, p.m_messageid FROM message p, chain c where p.m_messageid = c.parent
), min_value as (
	select coalesce(min(parent), 687194767741) as m from chain
), foo AS (
    select f_forumid, f_title, p_personid, p_firstname, p_lastname, m_messageid
    from message, person, forum
    where 1=1
    	and m_ps_forumid = f_forumid and f_moderatorid = p_personid
)
select f_forumid, f_title, p_personid, p_firstname, p_lastname
from foo cross join min_value
where m_messageid = min_value.m;
