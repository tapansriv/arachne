-- Graph query 
WITH pairs AS (
  SELECT DISTINCT c1.c_customer_sk as personid,
         c2.c_customer_sk as friendid
  FROM tpcds.customer c1,
       tpcds.customer c2,
       tpcds.catalog_returns cr,
       tpcds.customer_address ca,
       tpcds.customer_demographics cd
  WHERE 1=1
        AND c1.c_customer_sk = cr_refunded_customer_sk
        AND c2.c_customer_sk = cr_refunded_customer_sk
        AND c1.c_current_cdemo_sk = cd.cd_demo_sk
        AND c1.c_current_addr_sk = ca.ca_address_sk
        AND cr_item_sk < 1000
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

