 with results as
( select sum(ws_net_paid) as total_sum, i_category, i_class, 0 as g_category, 0 as g_class
 from
    `arachne-multicloud.tpcds.web_sales` AS web_sales
   ,`arachne-multicloud.tpcds.date_dim` d1
   ,`arachne-multicloud.tpcds.item` AS item
 where
    d1.d_month_seq between 1200 and 1200+11
 and d1.d_date_sk = ws_sold_date_sk
 and i_item_sk  = ws_item_sk
 group by i_category,i_class
 ) ,

 results_rollup as
( select total_sum ,i_category ,i_class, g_category, g_class, 0 as lochierarchy from results
  union all
  select sum(total_sum) as total_sum, i_category, NULL as i_class, 0 as g_category, 1 as g_class, 1 as lochierarchy from results group by i_category
  union all
  select sum(total_sum) as total_sum, NULL as i_category, NULL as i_class, 1 as g_category, 1 as g_class, 2 as lochierarchy from results)
select
 total_sum ,i_category ,i_class, lochierarchy
   ,rank() over (
  partition by lochierarchy,
  case when g_class = 0 then i_category end
  order by total_sum desc) as rank_within_parent
 from
 results_rollup
 order by
   lochierarchy desc NULLS FIRST,
   case when lochierarchy = 0 then i_category end NULLS FIRST,
   rank_within_parent NULLS FIRST
LIMIT 100;
