



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 900 and 900+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'midnight' or i_color = 'chartreuse') and 
        (i_units = 'Lb' or i_units = 'Pound') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'rose' or i_color = 'lavender') and
        (i_units = 'Oz' or i_units = 'Pallet') and
        (i_size = 'petite' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'slate' or i_color = 'medium') and
        (i_units = 'Ounce' or i_units = 'Tsp') and
        (i_size = 'economy' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'dodger' or i_color = 'wheat') and
        (i_units = 'Dram' or i_units = 'Unknown') and
        (i_size = 'medium' or i_size = 'extra large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'spring' or i_color = 'aquamarine') and 
        (i_units = 'Cup' or i_units = 'Dozen') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'violet' or i_color = 'lace') and
        (i_units = 'Ton' or i_units = 'Bunch') and
        (i_size = 'petite' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'moccasin' or i_color = 'dim') and
        (i_units = 'Gross' or i_units = 'Box') and
        (i_size = 'economy' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'khaki' or i_color = 'black') and
        (i_units = 'Bundle' or i_units = 'Each') and
        (i_size = 'medium' or i_size = 'extra large')
        )))) > 0
 order by i_product_name
 limit 100