/* Q2. Tag evolution
\set year 2010
\set month 11
 */
WITH detail AS (
SELECT t.t_name
     , count(DISTINCT CASE WHEN extract(MONTH FROM m.m_creationdate)  = 11 THEN m.m_messageid ELSE NULL END) AS countMonth1
     , count(DISTINCT CASE WHEN extract(MONTH FROM m.m_creationdate) != 11 THEN m.m_messageid ELSE NULL END) AS countMonth2
  FROM ldbc.message m
     , ldbc.message_tag mt
     , ldbc.tag t
 WHERE 1=1
    -- join
   AND m.m_messageid = mt.mt_messageid
   AND mt.mt_tagid = t.t_tagid
    -- filter
   AND m.m_creationdate >= cast('2010-11-1' as timestamp)
   AND m.m_creationdate <  cast((cast('2010-11-1' as date) + interval 2 month) as timestamp)
 GROUP BY t.t_name
)
SELECT t_name as tagname
     , countMonth1
     , countMonth2
     , abs(countMonth1-countMonth2) AS diff
  FROM detail d
 ORDER BY diff desc, t_name
 LIMIT 100
;
