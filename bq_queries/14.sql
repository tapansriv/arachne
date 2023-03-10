WITH cross_items AS
  (SELECT i_item_sk ss_item_sk
   FROM `arachne-multicloud.tpcds.item` AS item,
     (SELECT iss.i_brand_id brand_id ,
             iss.i_class_id class_id ,
             iss.i_category_id category_id
      FROM `arachne-multicloud.tpcds.store_sales` AS store_sales ,
           `arachne-multicloud.tpcds.item` iss ,
           `arachne-multicloud.tpcds.date_dim` d1
      WHERE ss_item_sk = iss.i_item_sk
        AND ss_sold_date_sk = d1.d_date_sk
        AND d1.d_year BETWEEN 1999 AND 1999 + 2 INTERSECT
        DISTINCT SELECT ics.i_brand_id ,
               ics.i_class_id ,
               ics.i_category_id
        FROM `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales ,
             `arachne-multicloud.tpcds.item` ics ,
             `arachne-multicloud.tpcds.date_dim` d2 WHERE cs_item_sk = ics.i_item_sk
        AND cs_sold_date_sk = d2.d_date_sk
        AND d2.d_year BETWEEN 1999 AND 1999 + 2 INTERSECT
        DISTINCT SELECT iws.i_brand_id ,
               iws.i_class_id ,
               iws.i_category_id
        FROM `arachne-multicloud.tpcds.web_sales` AS web_sales ,
             `arachne-multicloud.tpcds.item` iws ,
             `arachne-multicloud.tpcds.date_dim` d3 WHERE ws_item_sk = iws.i_item_sk
        AND ws_sold_date_sk = d3.d_date_sk
        AND d3.d_year BETWEEN 1999 AND 1999 + 2) x
   WHERE i_brand_id = brand_id
     AND i_class_id = class_id
     AND i_category_id = category_id ),
 avg_sales AS
  (SELECT avg(quantity*list_price) average_sales
   FROM
     (SELECT ss_quantity quantity ,
             ss_list_price list_price
      FROM `arachne-multicloud.tpcds.store_sales` AS store_sales ,
           `arachne-multicloud.tpcds.date_dim` AS date_dim
      WHERE ss_sold_date_sk = d_date_sk
        AND d_year BETWEEN 1999 AND 2001
      UNION ALL SELECT cs_quantity quantity,
                       cs_list_price list_price
      FROM `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales ,
           `arachne-multicloud.tpcds.date_dim` AS date_dim
      WHERE cs_sold_date_sk = d_date_sk
        AND d_year BETWEEN 1999 AND 1999 + 2
      UNION ALL SELECT ws_quantity quantity ,
                       ws_list_price list_price
      FROM `arachne-multicloud.tpcds.web_sales` AS web_sales ,
           `arachne-multicloud.tpcds.date_dim` AS date_dim
      WHERE ws_sold_date_sk = d_date_sk
        AND d_year BETWEEN 1999 AND 1999 + 2) x),
 results AS
  (SELECT channel,
          i_brand_id,
          i_class_id,
          i_category_id,
          sum(sales) sum_sales,
          sum(number_sales) number_sales
   FROM
     ( SELECT 'store' channel,
                      i_brand_id,
                      i_class_id ,
                      i_category_id,
                      sum(ss_quantity*ss_list_price) sales ,
                      count(*) number_sales
      FROM `arachne-multicloud.tpcds.store_sales` AS store_sales ,
           `arachne-multicloud.tpcds.item` AS item ,
           `arachne-multicloud.tpcds.date_dim` AS date_dim
      WHERE ss_item_sk IN
          (SELECT ss_item_sk
           FROM cross_items)
        AND ss_item_sk = i_item_sk
        AND ss_sold_date_sk = d_date_sk
        AND d_year = 1999+2
        AND d_moy = 11
      GROUP BY i_brand_id,
               i_class_id,
               i_category_id
      HAVING sum(ss_quantity*ss_list_price) >
        (SELECT average_sales
         FROM avg_sales)
      UNION ALL SELECT 'catalog' channel,
                                 i_brand_id,
                                 i_class_id,
                                 i_category_id,
                                 sum(cs_quantity*cs_list_price) sales,
                                 count(*) number_sales
      FROM `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales ,
           `arachne-multicloud.tpcds.item` AS item ,
           `arachne-multicloud.tpcds.date_dim` AS date_dim
      WHERE cs_item_sk IN
          (SELECT ss_item_sk
           FROM cross_items)
        AND cs_item_sk = i_item_sk
        AND cs_sold_date_sk = d_date_sk
        AND d_year = 1999+2
        AND d_moy = 11
      GROUP BY i_brand_id,
               i_class_id,
               i_category_id
      HAVING sum(cs_quantity*cs_list_price) >
        (SELECT average_sales
         FROM avg_sales)
      UNION ALL SELECT 'web' channel,
                             i_brand_id,
                             i_class_id,
                             i_category_id,
                             sum(ws_quantity*ws_list_price) sales,
                             count(*) number_sales
      FROM `arachne-multicloud.tpcds.web_sales` AS web_sales ,
           `arachne-multicloud.tpcds.item` AS item ,
           `arachne-multicloud.tpcds.date_dim` AS date_dim
      WHERE ws_item_sk IN
          (SELECT ss_item_sk
           FROM cross_items)
        AND ws_item_sk = i_item_sk
        AND ws_sold_date_sk = d_date_sk
        AND d_year = 1999+2
        AND d_moy = 11
      GROUP BY i_brand_id,
               i_class_id,
               i_category_id
      HAVING sum(ws_quantity*ws_list_price) >
        (SELECT average_sales
         FROM avg_sales) ) y
   GROUP BY channel,
            i_brand_id,
            i_class_id,
            i_category_id)
SELECT channel,
       i_brand_id,
       i_class_id,
       i_category_id,
       sum_sales,
       number_sales
FROM
  ( SELECT channel,
           i_brand_id,
           i_class_id,
           i_category_id,
           sum_sales,
           number_sales
   FROM results
   UNION ALL SELECT channel,
                i_brand_id,
                i_class_id,
                NULL AS i_category_id,
                sum(sum_sales),
                sum(number_sales)
   FROM results
   GROUP BY channel,
            i_brand_id,
            i_class_id
   UNION ALL SELECT channel,
                i_brand_id,
                NULL AS i_class_id,
                NULL AS i_category_id,
                sum(sum_sales),
                sum(number_sales)
   FROM results
   GROUP BY channel,
            i_brand_id
   UNION ALL SELECT channel,
                NULL AS i_brand_id,
                NULL AS i_class_id,
                NULL AS i_category_id,
                sum(sum_sales),
                sum(number_sales)
   FROM results
   GROUP BY channel
   UNION ALL SELECT NULL AS channel,
                NULL AS i_brand_id,
                NULL AS i_class_id,
                NULL AS i_category_id,
                sum(sum_sales),
                sum(number_sales)
   FROM results) z
ORDER BY channel NULLS FIRST,
         i_brand_id NULLS FIRST,
         i_class_id NULLS FIRST,
         i_category_id NULLS FIRST
LIMIT 100;


