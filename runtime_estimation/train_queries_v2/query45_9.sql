



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 863 and 863+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'light' or i_color = 'orange') and 
        (i_units = 'Each' or i_units = 'Dram') and
        (i_size = 'small' or i_size = 'large')
        ) or
        (i_category = 'Women' and
        (i_color = 'white' or i_color = 'magenta') and
        (i_units = 'Lb' or i_units = 'Bunch') and
        (i_size = 'extra large' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'forest' or i_color = 'peach') and
        (i_units = 'Bundle' or i_units = 'Box') and
        (i_size = 'petite' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'thistle' or i_color = 'purple') and
        (i_units = 'Tsp' or i_units = 'N/A') and
        (i_size = 'small' or i_size = 'large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'pale' or i_color = 'spring') and 
        (i_units = 'Dozen' or i_units = 'Ton') and
        (i_size = 'small' or i_size = 'large')
        ) or
        (i_category = 'Women' and
        (i_color = 'burlywood' or i_color = 'dodger') and
        (i_units = 'Gross' or i_units = 'Pound') and
        (i_size = 'extra large' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'turquoise' or i_color = 'slate') and
        (i_units = 'Unknown' or i_units = 'Tbl') and
        (i_size = 'petite' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'green' or i_color = 'lawn') and
        (i_units = 'Cup' or i_units = 'Case') and
        (i_size = 'small' or i_size = 'large')
        )))) > 0
 order by i_product_name
 limit 100