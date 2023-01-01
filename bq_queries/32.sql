SELECT sum(cs_ext_discount_amt) AS excess_discount_amount
FROM `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales ,
     `arachne-multicloud.tpcds.item` AS item ,
     `arachne-multicloud.tpcds.date_dim` AS date_dim
WHERE i_manufact_id = 977
  AND i_item_sk = cs_item_sk
  AND cast(d_date as date)  BETWEEN '2000-01-27' AND cast('2000-04-26' AS date)
  AND d_date_sk = cs_sold_date_sk
  AND cs_ext_discount_amt >
    ( SELECT 1.3 * avg(cs_ext_discount_amt)
     FROM `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales ,
          `arachne-multicloud.tpcds.date_dim` AS date_dim
     WHERE cs_item_sk = i_item_sk
       AND cast(d_date as date) BETWEEN '2000-01-27' AND cast('2000-04-26' AS date)
       AND d_date_sk = cs_sold_date_sk )
LIMIT 100;

