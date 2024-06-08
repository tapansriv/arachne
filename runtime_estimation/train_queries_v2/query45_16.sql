



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 744 and 744+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'smoke' or i_color = 'navajo') and 
        (i_units = 'Oz' or i_units = 'Carton') and
        (i_size = 'extra large' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'seashell' or i_color = 'mint') and
        (i_units = 'Dram' or i_units = 'Gram') and
        (i_size = 'economy' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'metallic' or i_color = 'lace') and
        (i_units = 'Bunch' or i_units = 'Each') and
        (i_size = 'small' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'sienna' or i_color = 'lawn') and
        (i_units = 'N/A' or i_units = 'Dozen') and
        (i_size = 'extra large' or i_size = 'N/A')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'ivory' or i_color = 'cornsilk') and 
        (i_units = 'Pallet' or i_units = 'Bundle') and
        (i_size = 'extra large' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'indian' or i_color = 'lavender') and
        (i_units = 'Lb' or i_units = 'Ounce') and
        (i_size = 'economy' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'yellow' or i_color = 'puff') and
        (i_units = 'Cup' or i_units = 'Box') and
        (i_size = 'small' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'grey' or i_color = 'ghost') and
        (i_units = 'Ton' or i_units = 'Gross') and
        (i_size = 'extra large' or i_size = 'N/A')
        )))) > 0
 order by i_product_name
 limit 100