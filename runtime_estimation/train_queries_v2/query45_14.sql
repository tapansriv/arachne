



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 822 and 822+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'sky' or i_color = 'moccasin') and 
        (i_units = 'Gross' or i_units = 'Each') and
        (i_size = 'economy' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'blush' or i_color = 'lace') and
        (i_units = 'Pallet' or i_units = 'Bunch') and
        (i_size = 'extra large' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'magenta' or i_color = 'orchid') and
        (i_units = 'Cup' or i_units = 'Bundle') and
        (i_size = 'large' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'indian' or i_color = 'frosted') and
        (i_units = 'Ounce' or i_units = 'Carton') and
        (i_size = 'economy' or i_size = 'N/A')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'thistle' or i_color = 'beige') and 
        (i_units = 'Box' or i_units = 'Case') and
        (i_size = 'economy' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'dark' or i_color = 'burlywood') and
        (i_units = 'Ton' or i_units = 'Lb') and
        (i_size = 'extra large' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'burnished' or i_color = 'tomato') and
        (i_units = 'Tbl' or i_units = 'Dozen') and
        (i_size = 'large' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'chocolate' or i_color = 'blanched') and
        (i_units = 'Gram' or i_units = 'Oz') and
        (i_size = 'economy' or i_size = 'N/A')
        )))) > 0
 order by i_product_name
 limit 100