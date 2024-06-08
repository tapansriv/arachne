



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 751 and 751+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'blue' or i_color = 'misty') and 
        (i_units = 'Box' or i_units = 'Pallet') and
        (i_size = 'economy' or i_size = 'large')
        ) or
        (i_category = 'Women' and
        (i_color = 'orange' or i_color = 'turquoise') and
        (i_units = 'Gross' or i_units = 'Bundle') and
        (i_size = 'extra large' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'seashell' or i_color = 'purple') and
        (i_units = 'Case' or i_units = 'Lb') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'mint' or i_color = 'frosted') and
        (i_units = 'Carton' or i_units = 'Ton') and
        (i_size = 'economy' or i_size = 'large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'white' or i_color = 'sienna') and 
        (i_units = 'Unknown' or i_units = 'Dram') and
        (i_size = 'economy' or i_size = 'large')
        ) or
        (i_category = 'Women' and
        (i_color = 'lime' or i_color = 'lace') and
        (i_units = 'Cup' or i_units = 'Ounce') and
        (i_size = 'extra large' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'aquamarine' or i_color = 'navy') and
        (i_units = 'Gram' or i_units = 'Pound') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'plum' or i_color = 'orchid') and
        (i_units = 'Bunch' or i_units = 'Oz') and
        (i_size = 'economy' or i_size = 'large')
        )))) > 0
 order by i_product_name
 limit 100