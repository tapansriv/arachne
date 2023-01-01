SELECT co.pl_placeid AS pl_placeid
     , co.pl_name AS name
     , COUNT(p.p_personid) as cnt
  FROM person p
     , place ci -- city
     , place co -- country
 WHERE 1=1
    -- join
   AND p.p_placeid = ci.pl_placeid
   AND ci.pl_containerplaceid = co.pl_placeid
GROUP BY co.pl_placeid, co.pl_name
ORDER BY cnt DESC
