



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 909 and 909+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'burlywood' or i_color = 'linen') and 
        (i_units = 'Pallet' or i_units = 'Each') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'beige' or i_color = 'red') and
        (i_units = 'Pound' or i_units = 'Bunch') and
        (i_size = 'petite' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'midnight' or i_color = 'bisque') and
        (i_units = 'Ounce' or i_units = 'Oz') and
        (i_size = 'large' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'seashell' or i_color = 'papaya') and
        (i_units = 'Lb' or i_units = 'Carton') and
        (i_size = 'medium' or i_size = 'extra large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'medium' or i_color = 'plum') and 
        (i_units = 'Bundle' or i_units = 'Tsp') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'powder' or i_color = 'tomato') and
        (i_units = 'N/A' or i_units = 'Dram') and
        (i_size = 'petite' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'aquamarine' or i_color = 'mint') and
        (i_units = 'Ton' or i_units = 'Cup') and
        (i_size = 'large' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'olive' or i_color = 'orchid') and
        (i_units = 'Gram' or i_units = 'Gross') and
        (i_size = 'medium' or i_size = 'extra large')
        )))) > 0
 order by i_product_name
 limit 100