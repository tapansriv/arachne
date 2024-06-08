



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 993 and 993+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'smoke' or i_color = 'cyan') and 
        (i_units = 'Lb' or i_units = 'N/A') and
        (i_size = 'petite' or i_size = 'economy')
        ) or
        (i_category = 'Women' and
        (i_color = 'thistle' or i_color = 'chartreuse') and
        (i_units = 'Carton' or i_units = 'Pallet') and
        (i_size = 'N/A' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'lavender' or i_color = 'black') and
        (i_units = 'Bundle' or i_units = 'Tbl') and
        (i_size = 'small' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'beige' or i_color = 'dodger') and
        (i_units = 'Oz' or i_units = 'Pound') and
        (i_size = 'petite' or i_size = 'economy')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'brown' or i_color = 'plum') and 
        (i_units = 'Ton' or i_units = 'Case') and
        (i_size = 'petite' or i_size = 'economy')
        ) or
        (i_category = 'Women' and
        (i_color = 'forest' or i_color = 'aquamarine') and
        (i_units = 'Gram' or i_units = 'Unknown') and
        (i_size = 'N/A' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'antique' or i_color = 'steel') and
        (i_units = 'Dram' or i_units = 'Ounce') and
        (i_size = 'small' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'burnished' or i_color = 'cornsilk') and
        (i_units = 'Gross' or i_units = 'Box') and
        (i_size = 'petite' or i_size = 'economy')
        )))) > 0
 order by i_product_name
 limit 100