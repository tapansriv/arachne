



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 916 and 916+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'metallic' or i_color = 'black') and 
        (i_units = 'Box' or i_units = 'Dozen') and
        (i_size = 'petite' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'firebrick' or i_color = 'spring') and
        (i_units = 'Bunch' or i_units = 'Oz') and
        (i_size = 'large' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'puff' or i_color = 'blue') and
        (i_units = 'Dram' or i_units = 'Tbl') and
        (i_size = 'N/A' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'ivory' or i_color = 'lavender') and
        (i_units = 'Tsp' or i_units = 'Pallet') and
        (i_size = 'petite' or i_size = 'extra large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'hot' or i_color = 'slate') and 
        (i_units = 'Case' or i_units = 'Unknown') and
        (i_size = 'petite' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'khaki' or i_color = 'maroon') and
        (i_units = 'N/A' or i_units = 'Bundle') and
        (i_size = 'large' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'navajo' or i_color = 'dodger') and
        (i_units = 'Ton' or i_units = 'Carton') and
        (i_size = 'N/A' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'dark' or i_color = 'linen') and
        (i_units = 'Cup' or i_units = 'Each') and
        (i_size = 'petite' or i_size = 'extra large')
        )))) > 0
 order by i_product_name
 limit 100