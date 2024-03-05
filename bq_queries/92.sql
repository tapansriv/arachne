SELECT sum(ws_ext_discount_amt) AS excess_discount_amount
FROM `arachne-multicloud.tpcds.web_sales` AS web_sales,
     `arachne-multicloud.tpcds.item` AS item,
     `arachne-multicloud.tpcds.date_dim` AS date_dim
WHERE i_manufact_id = 350
  AND i_item_sk = ws_item_sk
  AND cast(d_date as date) BETWEEN '2000-01-27' AND cast('2000-04-26' AS date)
  AND d_date_sk = ws_sold_date_sk
  AND ws_ext_discount_amt >
    (SELECT 1.3 * avg(ws_ext_discount_amt)
     FROM `arachne-multicloud.tpcds.web_sales` AS web_sales,
          `arachne-multicloud.tpcds.date_dim` AS date_dim
     WHERE ws_item_sk = i_item_sk
       AND cast(d_date as date) BETWEEN '2000-01-27' AND cast('2000-04-26' AS date)
       AND d_date_sk = ws_sold_date_sk )
ORDER BY sum(ws_ext_discount_amt)
LIMIT 100;

