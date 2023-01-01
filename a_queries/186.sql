with results as
( select sum(ws_net_paid) as total_sum, sum(ws_net_profit) as profit_sum, i_category, i_class, 0 as g_category, 0 as g_class
 from
    web_sales
   ,date_dim d1
   ,item
 where
    d1.d_month_seq between 1200 and 1200+11
 and d1.d_date_sk = ws_sold_date_sk
 and i_item_sk  = ws_item_sk
 group by i_category,i_class
 ) ,

 results_rollup as
( select total_sum as total_sum2, profit_sum as profit_sum, i_category ,i_class, g_category, g_class, 0 as lochierarchy from results
  union
  select sum(total_sum) as total_sum2, sum(profit_sum) as profit_sum,  i_category, NULL as i_class, 0 as g_category, 1 as g_class, 1 as lochierarchy from results group by i_category
  union
  select sum(total_sum) as total_sum2, sum(profit_sum) as profit_sum, NULL as i_category, NULL as i_class, 1 as g_category, 1 as g_class, 2 as lochierarchy from results)
select
 t.total_sum2 , t.foo, t.bar, 
t.i_category ,t.i_class, t.lochierarchy
   ,rank() over (
  partition by t.lochierarchy,
  case when t.g_class = 0 then t.i_category end
  order by t.total_sum2 desc) as rank_within_parent
 from (
    select total_sum2 , sum(profit_sum) over (partition by i_category, i_class ) as foo,
        avg(total_sum2) over (partition by g_category, g_class order by g_category, g_class) as bar, i_category ,i_class, g_category, g_class, lochierarchy
    from results_rollup
 ) t
 order by
   t.lochierarchy desc NULLS FIRST,
   case when t.lochierarchy = 0 then t.i_category end NULLS FIRST,
   rank_within_parent NULLS FIRST
LIMIT 100;

