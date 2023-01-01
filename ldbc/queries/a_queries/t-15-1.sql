/* Q15. Trusted connection paths through forums created in a given timeframe
\set person1Id 28587302322191
\set person2Id 26388279066632
\set startDate '\'2012-12-08''::timestamp
\set endDate '\'2012-12-12\''::timestamp
 */

create table weights as
with myForums(id) as (
    select f_forumid as id from forum f where to_timestamp(f.f_creationdate/1000) between '2012-12-08' and '2012-12-12'
),
persons_of_country_w_friends AS (
    SELECT p.p_personid AS k_person1id
         , k.k_person2id as k_person2id
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
),
mm as (
    select least(msg.m_creatorid, reply.m_creatorid) as src, greatest(msg.m_creatorid, reply.m_creatorid) as dst, sum(case when msg.m_c_replyof is null then 10 else 5 end) as w
    from persons_of_country_w_friends k, 
         message msg, 
         message reply
    where true
          and k.k_person1id = msg.m_creatorid 
          and k.k_person2id = reply.m_creatorid
          and reply.m_c_replyof = msg.m_messageid
          and msg.m_forumid in (select f.id from myForums f)
          and reply.m_forumid in (select f.id from myForums f)
          -- and exists (select * from myForums f where f.id = msg.containerforumid)
          -- and exists (select * from myForums f where f.id = reply.containerforumid)
    group by src, dst
)
select k.k_person1id as src, k.k_person2id as dst, 10::double precision / (coalesce(w, 0) + 10) as w
    from persons_of_country_w_friends k left join mm on least(k.k_person1id, k.k_person2id) = mm.src and greatest(k.k_person1id, k.k_person2id) = mm.dst
;

with recursive
shorts(src, dst, w, p, cycle) as (
    select src, dst, w, [src, dst], false from weights where src = 28587302322191 
    union all
    select s.src as src,
            wgts.dst as dst,
            s.w + wgts.w as w,
            s.p || [wgts.dst] as p,
            wgts.dst = ANY(s.p) as cycle
    from shorts s
         join weights wgts ON s.dst = wgts.src
    where 1 = 1
          and not s.cycle
)
select coalesce(min(w), -1)
    from shorts s
    where 1 = 1
        and src = 28587302322191 
        and dst = 26388279066632 
    group by src, dst;
