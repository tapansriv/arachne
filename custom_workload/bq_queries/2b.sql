-- Graph query 
WITH recursive nodes AS (
  SELECT c_customer_sk as custid,
         ws_item_sk as itemid 
  FROM tpcds.customer,
       tpcds.web_sales
  WHERE c_customer_sk = ws_bill_customer_sk
        AND ws_item_sk < 10000
        AND c_birth_country LIKE '%STAN'
), graph AS (
  SELECT c1.custid as p1,
         c2.custid as p2
  FROM nodes c1,
       nodes c2
  WHERE c1.itemid = c2.itemid 
), friend_shortest AS (
  SELECT c_customer_sk as startPerson, 0 as hopCount, c_customer_sk as friend
  FROM tpcds.customer
  WHERE c_customer_sk = 1

  UNION ALL
    SELECT f.startPerson, f.hopCount+1
          , CASE WHEN f.friend = g.p1 then g.p2 else g.p1 END
    FROM friend_shortest f
        ,graph g
    WHERE 1=1
        AND (f.friend = g.p1 or f.friend = g.p2)
        AND f.hopCount < 3
)
SELECT * FROM friend_shortest;



