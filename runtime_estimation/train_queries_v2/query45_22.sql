



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 700 and 700+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'hot' or i_color = 'steel') and 
        (i_units = 'Box' or i_units = 'Dozen') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'chocolate' or i_color = 'lemon') and
        (i_units = 'Cup' or i_units = 'Lb') and
        (i_size = 'economy' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'dark' or i_color = 'deep') and
        (i_units = 'Ton' or i_units = 'Bundle') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'beige' or i_color = 'peach') and
        (i_units = 'Gram' or i_units = 'Bunch') and
        (i_size = 'medium' or i_size = 'extra large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'salmon' or i_color = 'sienna') and 
        (i_units = 'Gross' or i_units = 'Case') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'khaki' or i_color = 'forest') and
        (i_units = 'Oz' or i_units = 'Ounce') and
        (i_size = 'economy' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'midnight' or i_color = 'orchid') and
        (i_units = 'Pound' or i_units = 'Carton') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'burnished' or i_color = 'dodger') and
        (i_units = 'Tbl' or i_units = 'Unknown') and
        (i_size = 'medium' or i_size = 'extra large')
        )))) > 0
 order by i_product_name
 limit 100