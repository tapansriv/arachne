-- Graph query 
WITH pairs AS (
  SELECT DISTINCT c1.c_customer_sk as personid,
         c2.c_customer_sk as friendid
  FROM customer c1,
       customer c2,
       store_returns sr,
       customer_address ca,
       customer_demographics cd
  WHERE 1=1
        AND c1.c_customer_sk = sr_customer_sk
        AND c2.c_customer_sk = sr_customer_sk
        AND c1.c_current_cdemo_sk = cd.cd_demo_sk
        AND c1.c_current_addr_sk = ca.ca_address_sk
        AND sr_item_sk < 1000
        AND cd.cd_marital_status LIKE 'S'
        AND ca.ca_zip LIKE '9%'
)
SELECT COUNT(*)
FROM pairs p1
   , pairs p2
   , pairs p3
WHERE 1=1
  AND p1.friendid = p2.personid
  AND p2.friendid = p3.personid
  AND p3.friendid = p1.personid
-- filter: unique triangles only
  AND p1.personid < p2.personid
  AND p2.personid < p3.personid
;

