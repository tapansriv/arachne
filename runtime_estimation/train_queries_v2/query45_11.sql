



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 744 and 744+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'chartreuse' or i_color = 'purple') and 
        (i_units = 'Gram' or i_units = 'Oz') and
        (i_size = 'large' or i_size = 'economy')
        ) or
        (i_category = 'Women' and
        (i_color = 'olive' or i_color = 'cream') and
        (i_units = 'Gross' or i_units = 'Pound') and
        (i_size = 'small' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'lime' or i_color = 'antique') and
        (i_units = 'Tsp' or i_units = 'Bunch') and
        (i_size = 'N/A' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'cornflower' or i_color = 'white') and
        (i_units = 'Lb' or i_units = 'Ton') and
        (i_size = 'large' or i_size = 'economy')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'navajo' or i_color = 'turquoise') and 
        (i_units = 'Box' or i_units = 'Ounce') and
        (i_size = 'large' or i_size = 'economy')
        ) or
        (i_category = 'Women' and
        (i_color = 'medium' or i_color = 'blanched') and
        (i_units = 'Bundle' or i_units = 'Pallet') and
        (i_size = 'small' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'papaya' or i_color = 'metallic') and
        (i_units = 'Dozen' or i_units = 'Tbl') and
        (i_size = 'N/A' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'royal' or i_color = 'cornsilk') and
        (i_units = 'N/A' or i_units = 'Carton') and
        (i_size = 'large' or i_size = 'economy')
        )))) > 0
 order by i_product_name
 limit 100