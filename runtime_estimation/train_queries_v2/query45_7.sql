



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 943 and 943+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'gainsboro' or i_color = 'puff') and 
        (i_units = 'Pallet' or i_units = 'Tsp') and
        (i_size = 'N/A' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'saddle' or i_color = 'spring') and
        (i_units = 'Gram' or i_units = 'Dram') and
        (i_size = 'medium' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'blush' or i_color = 'azure') and
        (i_units = 'Each' or i_units = 'Dozen') and
        (i_size = 'large' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'light' or i_color = 'mint') and
        (i_units = 'Oz' or i_units = 'Bunch') and
        (i_size = 'N/A' or i_size = 'petite')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'rosy' or i_color = 'coral') and 
        (i_units = 'N/A' or i_units = 'Ton') and
        (i_size = 'N/A' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'bisque' or i_color = 'ghost') and
        (i_units = 'Case' or i_units = 'Ounce') and
        (i_size = 'medium' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'firebrick' or i_color = 'cyan') and
        (i_units = 'Tbl' or i_units = 'Carton') and
        (i_size = 'large' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'antique' or i_color = 'honeydew') and
        (i_units = 'Gross' or i_units = 'Cup') and
        (i_size = 'N/A' or i_size = 'petite')
        )))) > 0
 order by i_product_name
 limit 100