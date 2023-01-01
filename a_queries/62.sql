SELECT w_substr,
       sm_type,
       web_name,
       sum(CASE
               WHEN (ws_ship_date_sk - ws_sold_date_sk <= 30) THEN 1
               ELSE 0
           END) AS days_30,
       sum(CASE
               WHEN (ws_ship_date_sk - ws_sold_date_sk > 30)
                    AND (ws_ship_date_sk - ws_sold_date_sk <= 60) THEN 1
               ELSE 0
           END) AS days_31_60,
       sum(CASE
               WHEN (ws_ship_date_sk - ws_sold_date_sk > 60)
                    AND (ws_ship_date_sk - ws_sold_date_sk <= 90) THEN 1
               ELSE 0
           END) AS days_61_90,
       sum(CASE
               WHEN (ws_ship_date_sk - ws_sold_date_sk > 90)
                    AND (ws_ship_date_sk - ws_sold_date_sk <= 120) THEN 1
               ELSE 0
           END) AS days_90_120,
       sum(CASE
               WHEN (ws_ship_date_sk - ws_sold_date_sk > 120) THEN 1
               ELSE 0
           END) AS days_over_120
FROM web_sales,
  (SELECT SUBSTRING(w_warehouse_name,1,20) w_substr,
          *
   FROM warehouse) sq1,
     ship_mode,
     web_site,
     date_dim
WHERE d_month_seq BETWEEN 1200 AND 1200 + 11
  AND ws_ship_date_sk = d_date_sk
  AND ws_warehouse_sk = w_warehouse_sk
  AND ws_ship_mode_sk = sm_ship_mode_sk
  AND ws_web_site_sk = web_site_sk
GROUP BY w_substr,
         sm_type,
         web_name
ORDER BY 1 NULLS FIRST,
         2 NULLS FIRST,
         3 NULLS FIRST
LIMIT 100;

