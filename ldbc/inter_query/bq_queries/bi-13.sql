/* Q13. Zombies in a country
\set country '\'Belarus\''
\set endDate '\'2013-01-01T00:00:00.000+00:00\''::timestamp
 */
WITH zombies AS (
    SELECT p.p_personid AS zombieid
      FROM ldbc.place co -- country
         , ldbc.place ci -- city
         , ldbc.person p
           LEFT JOIN ldbc.message m ON (p.p_personid = m.m_creatorid AND m.m_creationdate BETWEEN p.p_creationdate AND cast('2013-01-01T00:00:00' as timestamp))
     WHERE 1=1
        -- join
       AND co.pl_placeid = ci.pl_containerplaceid
       AND ci.pl_placeid = p.p_placeid
        -- filter
       AND co.pl_name = 'Belarus'
       AND p.p_creationdate < cast('2013-01-01T00:00:00' as timestamp)
     GROUP BY p.p_personid, p.p_creationdate
        -- average of [0, 1) messages per month is equivalent with having less messages than the month span between ldbc.person creationDate and parameter :endDate
    HAVING count(m_messageid) < 12*extract(YEAR FROM cast('2013-01-01T00:00:00' as timestamp))+extract(MONTH FROM cast('2013-01-01T00:00:00' as timestamp)) - (12*extract(YEAR FROM p.p_creationdate) + extract(MONTH FROM p.p_creationdate)) + 1
)
SELECT z.zombieid AS zombieid
     , count(zl.zombieid) AS zombieLikeCount
     , count(l.l_personid) AS totalLikeCount
     , CASE WHEN count(l.l_personid) = 0 THEN 0 ELSE cast(count(zl.zombieid) as decimal)/count(l.l_personid) END AS zombieScore
  FROM ldbc.message m
       INNER JOIN ldbc.likes l ON (m.m_messageid = l.l_messageid)
       INNER JOIN ldbc.person p ON (l.l_personid = p.p_personid AND p.p_creationdate < cast('2013-01-01T00:00:00' as timestamp))
       LEFT  JOIN zombies zl ON (p.p_personid = zl.zombieid) -- see if the like was given by a zombie
       RIGHT JOIN zombies z ON (z.zombieid = m.m_creatorid)
 GROUP BY z.zombieid
 ORDER BY zombieScore DESC, z.zombieid
 LIMIT 100
;
