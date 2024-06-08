



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 789 and 789+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'thistle' or i_color = 'purple') and 
        (i_units = 'Tbl' or i_units = 'Ounce') and
        (i_size = 'N/A' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'black' or i_color = 'blanched') and
        (i_units = 'Bunch' or i_units = 'Each') and
        (i_size = 'medium' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'smoke' or i_color = 'dodger') and
        (i_units = 'Ton' or i_units = 'Bundle') and
        (i_size = 'small' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'seashell' or i_color = 'misty') and
        (i_units = 'Oz' or i_units = 'Case') and
        (i_size = 'N/A' or i_size = 'extra large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'snow' or i_color = 'hot') and 
        (i_units = 'Gross' or i_units = 'Dram') and
        (i_size = 'N/A' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'ghost' or i_color = 'turquoise') and
        (i_units = 'Lb' or i_units = 'Pound') and
        (i_size = 'medium' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'dim' or i_color = 'wheat') and
        (i_units = 'Box' or i_units = 'Carton') and
        (i_size = 'small' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'navy' or i_color = 'slate') and
        (i_units = 'Tsp' or i_units = 'Gram') and
        (i_size = 'N/A' or i_size = 'extra large')
        )))) > 0
 order by i_product_name
 limit 100