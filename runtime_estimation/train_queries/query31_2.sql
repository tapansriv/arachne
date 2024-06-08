



select  *
from (select avg(ss_list_price) B1_LP
            ,count(ss_list_price) B1_CNT
            ,count(distinct ss_list_price) B1_CNTD
      from store_sales
      where ss_quantity between 0 and 5
        and (ss_list_price between 2 and 2+10 
             or ss_coupon_amt between 13544 and 13544+1000
             or ss_wholesale_cost between 57 and 57+20)) B1,
     (select avg(ss_list_price) B2_LP
            ,count(ss_list_price) B2_CNT
            ,count(distinct ss_list_price) B2_CNTD
      from store_sales
      where ss_quantity between 6 and 10
        and (ss_list_price between 133 and 133+10
          or ss_coupon_amt between 5897 and 5897+1000
          or ss_wholesale_cost between 44 and 44+20)) B2,
     (select avg(ss_list_price) B3_LP
            ,count(ss_list_price) B3_CNT
            ,count(distinct ss_list_price) B3_CNTD
      from store_sales
      where ss_quantity between 11 and 15
        and (ss_list_price between 106 and 106+10
          or ss_coupon_amt between 835 and 835+1000
          or ss_wholesale_cost between 55 and 55+20)) B3,
     (select avg(ss_list_price) B4_LP
            ,count(ss_list_price) B4_CNT
            ,count(distinct ss_list_price) B4_CNTD
      from store_sales
      where ss_quantity between 16 and 20
        and (ss_list_price between 47 and 47+10
          or ss_coupon_amt between 2418 and 2418+1000
          or ss_wholesale_cost between 71 and 71+20)) B4,
     (select avg(ss_list_price) B5_LP
            ,count(ss_list_price) B5_CNT
            ,count(distinct ss_list_price) B5_CNTD
      from store_sales
      where ss_quantity between 21 and 25
        and (ss_list_price between 138 and 138+10
          or ss_coupon_amt between 17021 and 17021+1000
          or ss_wholesale_cost between 34 and 34+20)) B5,
     (select avg(ss_list_price) B6_LP
            ,count(ss_list_price) B6_CNT
            ,count(distinct ss_list_price) B6_CNTD
      from store_sales
      where ss_quantity between 26 and 30
        and (ss_list_price between 95 and 95+10
          or ss_coupon_amt between 11709 and 11709+1000
          or ss_wholesale_cost between 16 and 16+20)) B6
limit 100