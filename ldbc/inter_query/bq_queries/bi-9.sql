/* Q9. Top thread initiators
\set startDate '\'2012-06-01T00:00:00.000+00:00\''::timestamp
\set endDate   '\'2012-07-01T00:00:00.000+00:00\''::timestamp
 */
WITH RECURSIVE post_all AS (
    SELECT m_messageid AS psa_threadid
         , m_creatorid AS psa_thread_creatorid
         , m_messageid AS psa_messageid
         , m_creationdate AS psa_creationdate
         , 'Post' AS psa_messagetype
      FROM ldbc.message
     WHERE 1=1
       AND m_c_replyof IS NULL -- post, not comment
       AND m_creationdate BETWEEN '2012-06-01T00:00:00' AND '2012-07-01T00:00:00'
  UNION ALL
    SELECT psa.psa_threadid AS psa_threadid
         , psa.psa_thread_creatorid AS psa_thread_creatorid
         , m_messageid AS psa_messageid
         , m_creationdate AS psa_creationdate
         , 'Comment' AS psa_messagetype
      FROM ldbc.message p
         , post_all psa
     WHERE 1=1
       AND p.m_c_replyof = psa.psa_messageid
        -- this is a performance optimisation only
       AND m_creationdate BETWEEN '2012-06-01T00:00:00' AND '2012-07-01T00:00:00'
)
SELECT p.p_personid AS personid
     , p.p_firstname AS personfirstName
     , p.p_lastname AS personlastName
     , count(DISTINCT psa.psa_threadid) AS threadCount
     -- if the thread initiator ldbc.message does not count as a reply
     --, count(DISTINCT CASE WHEN psa.psa_messagetype = 'Comment' then psa.psa_messageid ELSE null END) AS messageCount
     , count(DISTINCT psa.psa_messageid) AS messageCount
  FROM ldbc.person p left join post_all psa on (
       1=1
   AND p.p_personid = psa.psa_thread_creatorid
   AND psa_creationdate BETWEEN '2012-06-01T00:00:00' AND '2012-07-01T00:00:00'
   )
 GROUP BY p.p_personid, p.p_firstname, p.p_lastname
 ORDER BY messageCount DESC, p.p_personid
 LIMIT 100
;
