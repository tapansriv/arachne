



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 937 and 937+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'coral' or i_color = 'mint') and 
        (i_units = 'N/A' or i_units = 'Oz') and
        (i_size = 'N/A' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'chocolate' or i_color = 'slate') and
        (i_units = 'Ounce' or i_units = 'Each') and
        (i_size = 'large' or i_size = 'small')
        ) or
        (i_category = 'Men' and
        (i_color = 'orchid' or i_color = 'tomato') and
        (i_units = 'Lb' or i_units = 'Bundle') and
        (i_size = 'medium' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'lawn' or i_color = 'floral') and
        (i_units = 'Ton' or i_units = 'Unknown') and
        (i_size = 'N/A' or i_size = 'extra large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'antique' or i_color = 'thistle') and 
        (i_units = 'Tsp' or i_units = 'Bunch') and
        (i_size = 'N/A' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'lavender' or i_color = 'turquoise') and
        (i_units = 'Case' or i_units = 'Cup') and
        (i_size = 'large' or i_size = 'small')
        ) or
        (i_category = 'Men' and
        (i_color = 'lemon' or i_color = 'linen') and
        (i_units = 'Box' or i_units = 'Dozen') and
        (i_size = 'medium' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'lime' or i_color = 'dark') and
        (i_units = 'Pound' or i_units = 'Carton') and
        (i_size = 'N/A' or i_size = 'extra large')
        )))) > 0
 order by i_product_name
 limit 100