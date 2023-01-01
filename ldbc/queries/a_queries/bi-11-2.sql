SELECT count(*)
  FROM persons_of_country_w_friends p1
     , persons_of_country_w_friends p2
     , persons_of_country_w_friends p3
 WHERE 1=1
    -- join
   AND p1.friendid = p2.personid
   AND p2.friendid = p3.personid
   AND p3.friendid = p1.personid
    -- filter: unique trinagles only
   AND p1.personid < p2.personid
   AND p2.personid < p3.personid
   -- AND :startDate <= p1.creationdate AND p1.creationdate <= :endDate
   -- AND :startDate <= p2.creationdate AND p2.creationdate <= :endDate
   -- AND :startDate <= p3.creationdate AND p3.creationdate <= :endDate
;


