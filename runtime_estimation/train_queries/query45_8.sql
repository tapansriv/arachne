



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 929 and 929+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'light' or i_color = 'deep') and 
        (i_units = 'Tbl' or i_units = 'Gross') and
        (i_size = 'small' or i_size = 'economy')
        ) or
        (i_category = 'Women' and
        (i_color = 'seashell' or i_color = 'pink') and
        (i_units = 'Lb' or i_units = 'Tsp') and
        (i_size = 'medium' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'cornsilk' or i_color = 'burnished') and
        (i_units = 'Cup' or i_units = 'Box') and
        (i_size = 'large' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'salmon' or i_color = 'blush') and
        (i_units = 'Gram' or i_units = 'N/A') and
        (i_size = 'small' or i_size = 'economy')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'slate' or i_color = 'yellow') and 
        (i_units = 'Bundle' or i_units = 'Ton') and
        (i_size = 'small' or i_size = 'economy')
        ) or
        (i_category = 'Women' and
        (i_color = 'spring' or i_color = 'rose') and
        (i_units = 'Dram' or i_units = 'Dozen') and
        (i_size = 'medium' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'peach' or i_color = 'dodger') and
        (i_units = 'Bunch' or i_units = 'Carton') and
        (i_size = 'large' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'indian' or i_color = 'almond') and
        (i_units = 'Pallet' or i_units = 'Unknown') and
        (i_size = 'small' or i_size = 'economy')
        )))) > 0
 order by i_product_name
 limit 100