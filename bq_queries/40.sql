SELECT w_state,
       i_item_id,
       sum(CASE
               WHEN (cast(d_date AS date) < CAST ('2000-03-11' AS date)) THEN cs_sales_price - coalesce(cr_refunded_cash,0)
               ELSE 0
           END) AS sales_before,
       sum(CASE
               WHEN (cast(d_date AS date) >= CAST ('2000-03-11' AS date)) THEN cs_sales_price - coalesce(cr_refunded_cash,0)
               ELSE 0
           END) AS sales_after
FROM `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales
LEFT OUTER JOIN `arachne-multicloud.tpcds.catalog_returns` AS catalog_returns ON (cs_order_number = cr_order_number
                                    AND cs_item_sk = cr_item_sk) ,`arachne-multicloud.tpcds.warehouse` AS warehouse,
                                                                  `arachne-multicloud.tpcds.item` AS item,
                                                                  `arachne-multicloud.tpcds.date_dim` AS date_dim
WHERE i_current_price BETWEEN 0.99 AND 1.49
  AND i_item_sk = cs_item_sk
  AND cs_warehouse_sk = w_warehouse_sk
  AND cs_sold_date_sk = d_date_sk
  AND cast(d_date as date) BETWEEN CAST ('2000-02-10' AS date) AND CAST ('2000-04-10' AS date)
GROUP BY w_state,
         i_item_id
ORDER BY w_state,
         i_item_id
LIMIT 100;

