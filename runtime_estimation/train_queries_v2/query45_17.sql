



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 891 and 891+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'orchid' or i_color = 'peru') and 
        (i_units = 'Gram' or i_units = 'Dozen') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'papaya' or i_color = 'chiffon') and
        (i_units = 'Pound' or i_units = 'Carton') and
        (i_size = 'petite' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'mint' or i_color = 'lemon') and
        (i_units = 'Cup' or i_units = 'Ounce') and
        (i_size = 'medium' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'plum' or i_color = 'powder') and
        (i_units = 'Bundle' or i_units = 'Ton') and
        (i_size = 'small' or i_size = 'N/A')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'grey' or i_color = 'cornsilk') and 
        (i_units = 'N/A' or i_units = 'Bunch') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'sandy' or i_color = 'yellow') and
        (i_units = 'Gross' or i_units = 'Lb') and
        (i_size = 'petite' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'khaki' or i_color = 'chocolate') and
        (i_units = 'Case' or i_units = 'Dram') and
        (i_size = 'medium' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'medium' or i_color = 'maroon') and
        (i_units = 'Unknown' or i_units = 'Tsp') and
        (i_size = 'small' or i_size = 'N/A')
        )))) > 0
 order by i_product_name
 limit 100