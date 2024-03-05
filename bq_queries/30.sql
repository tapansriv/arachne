WITH customer_total_return AS
  (SELECT wr_returning_customer_sk AS ctr_customer_sk,
          ca_state AS ctr_state,
          sum(wr_return_amt) AS ctr_total_return
   FROM `arachne-multicloud.tpcds.web_returns` AS web_returns,
        `arachne-multicloud.tpcds.date_dim` AS date_dim,
        `arachne-multicloud.tpcds.customer_address` AS customer_address
   WHERE wr_returned_date_sk = d_date_sk
     AND d_year = 2002
     AND wr_returning_addr_sk = ca_address_sk
   GROUP BY wr_returning_customer_sk,
            ca_state)
SELECT c_customer_id,
       c_salutation,
       c_first_name,
       c_last_name,
       c_preferred_cust_flag,
       c_birth_day,
       c_birth_month,
       c_birth_year,
       c_birth_country,
       c_login,
       c_email_address,
       c_last_review_date_sk,
       ctr_total_return
FROM customer_total_return ctr1,
     `arachne-multicloud.tpcds.customer_address` AS customer_address,
     `arachne-multicloud.tpcds.customer` AS customer
WHERE ctr1.ctr_total_return >
    (SELECT avg(ctr_total_return)*1.2
     FROM customer_total_return ctr2
     WHERE ctr1.ctr_state = ctr2.ctr_state)
  AND ca_address_sk = c_current_addr_sk
  AND ca_state = 'GA'
  AND ctr1.ctr_customer_sk = c_customer_sk
ORDER BY c_customer_id NULLS FIRST,
         c_salutation NULLS FIRST,
         c_first_name NULLS FIRST,
         c_last_name NULLS FIRST,
         c_preferred_cust_flag NULLS FIRST,
         c_birth_day NULLS FIRST,
         c_birth_month NULLS FIRST,
         c_birth_year NULLS FIRST,
         c_birth_country NULLS FIRST,
         c_login NULLS FIRST,
         c_email_address NULLS FIRST,
         c_last_review_date_sk NULLS FIRST,
         ctr_total_return NULLS FIRST
LIMIT 100;

