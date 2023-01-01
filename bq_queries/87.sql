WITH t1 AS 
    (SELECT c_last_name,
            c_first_name,
            d_date
     FROM `arachne-multicloud.tpcds.store_sales` AS store_sales,
          `arachne-multicloud.tpcds.date_dim` AS date_dim,
          `arachne-multicloud.tpcds.customer` AS customer
     WHERE store_sales.ss_sold_date_sk = date_dim.d_date_sk
       AND store_sales.ss_customer_sk = customer.c_customer_sk
       AND d_month_seq BETWEEN 1200 AND 1200+11),
 t2 AS  
    (SELECT DISTINCT c_last_name,
                     c_first_name,
                     d_date
     FROM `arachne-multicloud.tpcds.catalog_sales` AS catalog_sales,
          `arachne-multicloud.tpcds.date_dim` AS date_dim,
          `arachne-multicloud.tpcds.customer` AS customer
     WHERE catalog_sales.cs_sold_date_sk = date_dim.d_date_sk
       AND catalog_sales.cs_bill_customer_sk = customer.c_customer_sk
       AND d_month_seq BETWEEN 1200 AND 1200+11),
 t3 AS  
    (SELECT DISTINCT c_last_name,
                     c_first_name,
                     d_date
     FROM `arachne-multicloud.tpcds.web_sales` AS web_sales,
          `arachne-multicloud.tpcds.date_dim` AS date_dim,
          `arachne-multicloud.tpcds.customer` AS customer
     WHERE web_sales.ws_sold_date_sk = date_dim.d_date_sk
       AND web_sales.ws_bill_customer_sk = customer.c_customer_sk
       AND d_month_seq BETWEEN 1200 AND 1200+11),
 t4 AS 
    (SELECT *  
     FROM t1 
     EXCEPT DISTINCT 
     (SELECT * FROM t2)
     EXCEPT DISTINCT 
     (SELECT * FROM t3))
SELECT count(*)
FROM t4;
