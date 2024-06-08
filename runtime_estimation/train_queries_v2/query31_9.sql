



select  *
from (select avg(ss_list_price) B1_LP
            ,count(ss_list_price) B1_CNT
            ,count(distinct ss_list_price) B1_CNTD
      from store_sales
      where ss_quantity between 0 and 5
        and (ss_list_price between 96 and 96+10 
             or ss_coupon_amt between 6669 and 6669+1000
             or ss_wholesale_cost between 58 and 58+20)) B1,
     (select avg(ss_list_price) B2_LP
            ,count(ss_list_price) B2_CNT
            ,count(distinct ss_list_price) B2_CNTD
      from store_sales
      where ss_quantity between 6 and 10
        and (ss_list_price between 43 and 43+10
          or ss_coupon_amt between 9256 and 9256+1000
          or ss_wholesale_cost between 15 and 15+20)) B2,
     (select avg(ss_list_price) B3_LP
            ,count(ss_list_price) B3_CNT
            ,count(distinct ss_list_price) B3_CNTD
      from store_sales
      where ss_quantity between 11 and 15
        and (ss_list_price between 84 and 84+10
          or ss_coupon_amt between 7116 and 7116+1000
          or ss_wholesale_cost between 30 and 30+20)) B3,
     (select avg(ss_list_price) B4_LP
            ,count(ss_list_price) B4_CNT
            ,count(distinct ss_list_price) B4_CNTD
      from store_sales
      where ss_quantity between 16 and 20
        and (ss_list_price between 108 and 108+10
          or ss_coupon_amt between 6454 and 6454+1000
          or ss_wholesale_cost between 20 and 20+20)) B4,
     (select avg(ss_list_price) B5_LP
            ,count(ss_list_price) B5_CNT
            ,count(distinct ss_list_price) B5_CNTD
      from store_sales
      where ss_quantity between 21 and 25
        and (ss_list_price between 165 and 165+10
          or ss_coupon_amt between 122 and 122+1000
          or ss_wholesale_cost between 32 and 32+20)) B5,
     (select avg(ss_list_price) B6_LP
            ,count(ss_list_price) B6_CNT
            ,count(distinct ss_list_price) B6_CNTD
      from store_sales
      where ss_quantity between 26 and 30
        and (ss_list_price between 79 and 79+10
          or ss_coupon_amt between 16915 and 16915+1000
          or ss_wholesale_cost between 79 and 79+20)) B6
limit 100