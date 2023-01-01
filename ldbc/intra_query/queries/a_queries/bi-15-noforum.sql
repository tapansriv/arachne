/* Q15. Trusted connection paths through forums created in a given timeframe
\set person1Id 21990232564808
\set person2Id 26388279076936
\set startDate '\'2010-11-01\''::timestamp
\set endDate '\'2010-12-01\''::timestamp
 */
with recursive
srcs(f) as (select :person1Id),
dsts(t) as (select :person2Id),
-- myForums(id) as (
--     select f_forumid as id from forum f where f.f_creationdate between :startDate and :endDate
-- ),
mm as (
    select least(msg.m_creatorid, reply.m_creatorid) as src, greatest(msg.m_creatorid, reply.m_creatorid) as dst, sum(case when msg.m_c_replyof is null then 10 else 5 end) as w
    from knows k, message msg, message reply
    where true
          and k.k_person1id = msg.m_creatorid 
          and k.k_person2id = reply.m_creatorid
          and reply.m_c_replyof = msg.m_messageid
          -- and exists (select * from myForums f where f.id = msg.containerforumid)
          -- and exists (select * from myForums f where f.id = reply.containerforumid)
    group by src, dst
),
path(src, dst, w) as (
    select k.person1id, k.person2id, 10::double precision / (coalesce(w, 0) + 10)
    from knows k left join mm on least(k.k_person1id, k.k_person2id) = mm.src and greatest(k.k_person1id, k.k_person2id) = mm.dst
),
shorts(dir, gsrc, dst, w, dead, iter) as (
    (
        select false, f, f, 0::double precision, false, 0 from srcs
        union all
        select true, t, t, 0::double precision, false, 0 from dsts
    )
    union all
    (
        with
        ss as (select * from shorts),
        toExplore as (select * from ss where dead = false order by w limit 1000),
        -- assumes graph is undirected
        newPoints(dir, gsrc, dst, w, dead) as (
            select e.dir, e.gsrc as gsrc, p.dst as dst, e.w + p.w as w, false as dead
            from path p join toExplore e on (e.dst = p.src)
            union all
            select dir, gsrc, dst, w, dead or exists (select * from toExplore e where e.dir = o.dir and e.gsrc = o.gsrc and e.dst = o.dst) from ss o
        ),
        fullTable as (
            select distinct on(dir, gsrc, dst) dir, gsrc, dst, w, dead
            from newPoints
            order by dir, gsrc, dst, w, dead desc
        ),
        found as (
            select min(l.w + r.w) as w
            from fullTable l, fullTable r
            where l.dir = false and r.dir = true and l.dst = r.dst
        )
        select dir,
               gsrc,
               dst,
               w,
               dead or (coalesce(t.w > (select f.w/2 from found f), false)),
               e.iter + 1 as iter
        from fullTable t, (select iter from toExplore limit 1) e
    )
),
ss(dir, gsrc, dst, w, iter) as (
    select dir, gsrc, dst, w, iter from shorts where iter = (select max(iter) from shorts)
),
results(f, t, w) as (
    select l.gsrc, r.gsrc, min(l.w + r.w)
    from ss l, ss r
    where l.dir = false and r.dir = true and l.dst = r.dst
    group by l.gsrc, r.gsrc
)
select coalesce(min(w), -1) from results;
