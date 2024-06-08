-- Graph query 
WITH recursive nodes AS (
  SELECT c_customer_sk as custid,
         ss_sales_price as price
  FROM customer,
       store_sales
  WHERE c_customer_sk = ss_customer_sk
        AND ss_item_sk < 10
        AND c_first_name LIKE '%ro%'
), graph AS (
  SELECT c1.custid as p1,
         c2.custid as p2
  FROM nodes c1,
       nodes c2
  WHERE 1=1 
    AND (   c1.price < c2.price + 5
         OR c1.price > c2.price - 5
        )
), friend_shortest(startPerson, hopCount, friend) AS (
  SELECT c_customer_sk as startPerson, 0 as hopCount, c_customer_sk as friend
  FROM customer
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

