



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 994 and 994+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'snow' or i_color = 'medium') and 
        (i_units = 'Gram' or i_units = 'Unknown') and
        (i_size = 'petite' or i_size = 'medium')
        ) or
        (i_category = 'Women' and
        (i_color = 'frosted' or i_color = 'plum') and
        (i_units = 'Bundle' or i_units = 'Tsp') and
        (i_size = 'economy' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'pink' or i_color = 'cyan') and
        (i_units = 'Cup' or i_units = 'Dozen') and
        (i_size = 'small' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'blanched' or i_color = 'navajo') and
        (i_units = 'Each' or i_units = 'Oz') and
        (i_size = 'petite' or i_size = 'medium')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'midnight' or i_color = 'sienna') and 
        (i_units = 'Gross' or i_units = 'Case') and
        (i_size = 'petite' or i_size = 'medium')
        ) or
        (i_category = 'Women' and
        (i_color = 'blue' or i_color = 'chiffon') and
        (i_units = 'Dram' or i_units = 'Ounce') and
        (i_size = 'economy' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'royal' or i_color = 'mint') and
        (i_units = 'Tbl' or i_units = 'Carton') and
        (i_size = 'small' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'forest' or i_color = 'navy') and
        (i_units = 'N/A' or i_units = 'Pallet') and
        (i_size = 'petite' or i_size = 'medium')
        )))) > 0
 order by i_product_name
 limit 100