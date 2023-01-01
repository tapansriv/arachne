CREATE TABLE ss AS
  (SELECT i_item_id,
          sum(ss_ext_sales_price) total_sales
   FROM 'store_sales.parquet' AS store_sales,
        'date_dim.parquet' AS date_dim,
        'customer_address.parquet' AS customer_address,
        'item.parquet' AS item
   WHERE i_item_id IN
       (SELECT i_item_id
        FROM 'item.parquet' AS item
        WHERE i_color IN ('slate',
                          'blanched',
                          'burnished'))
     AND ss_item_sk = i_item_sk
     AND ss_sold_date_sk = d_date_sk
     AND d_year = 2001
     AND d_moy = 2
     AND ss_addr_sk = ca_address_sk
     AND ca_gmt_offset = -5
   GROUP BY i_item_id);
CREATE TABLE cs AS
  (SELECT i_item_id,
          sum(cs_ext_sales_price) total_sales
   FROM 'catalog_sales.parquet' AS catalog_sales,
        'date_dim.parquet' AS date_dim,
        'customer_address.parquet' AS customer_address,
        'item.parquet' AS item
   WHERE i_item_id IN
       (SELECT i_item_id
        FROM 'item.parquet' AS item
        WHERE i_color IN ('slate',
                          'blanched',
                          'burnished'))
     AND cs_item_sk = i_item_sk
     AND cs_sold_date_sk = d_date_sk
     AND d_year = 2001
     AND d_moy = 2
     AND cs_bill_addr_sk = ca_address_sk
     AND ca_gmt_offset = -5
   GROUP BY i_item_id);
CREATE TABLE ws AS
  (SELECT i_item_id,
          sum(ws_ext_sales_price) total_sales
   FROM 'web_sales.parquet' AS web_sales,
        'date_dim.parquet' AS date_dim,
        'customer_address.parquet' AS customer_address,
        'item.parquet' AS item
   WHERE i_item_id IN
       (SELECT i_item_id
        FROM 'item.parquet' AS item
        WHERE i_color IN ('slate',
                          'blanched',
                          'burnished'))
     AND ws_item_sk = i_item_sk
     AND ws_sold_date_sk = d_date_sk
     AND d_year = 2001
     AND d_moy = 2
     AND ws_bill_addr_sk = ca_address_sk
     AND ca_gmt_offset = -5
   GROUP BY i_item_id);
SELECT i_item_id,
       sum(total_sales) total_sales
FROM
  (SELECT *
   FROM ss
   UNION ALL SELECT *
   FROM cs
   UNION ALL SELECT *
   FROM ws) tmp1
GROUP BY i_item_id
ORDER BY total_sales  NULLS FIRST,
         i_item_id NULLS FIRST
LIMIT 100;

