



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 672 and 672+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'peach' or i_color = 'chiffon') and 
        (i_units = 'Dozen' or i_units = 'Pallet') and
        (i_size = 'N/A' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'black' or i_color = 'lemon') and
        (i_units = 'Carton' or i_units = 'Lb') and
        (i_size = 'small' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'salmon' or i_color = 'violet') and
        (i_units = 'N/A' or i_units = 'Ounce') and
        (i_size = 'economy' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'cream' or i_color = 'red') and
        (i_units = 'Each' or i_units = 'Box') and
        (i_size = 'N/A' or i_size = 'extra large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'pink' or i_color = 'gainsboro') and 
        (i_units = 'Bundle' or i_units = 'Cup') and
        (i_size = 'N/A' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'burlywood' or i_color = 'sienna') and
        (i_units = 'Gram' or i_units = 'Gross') and
        (i_size = 'small' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'azure' or i_color = 'dodger') and
        (i_units = 'Ton' or i_units = 'Bunch') and
        (i_size = 'economy' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'lavender' or i_color = 'blanched') and
        (i_units = 'Dram' or i_units = 'Pound') and
        (i_size = 'N/A' or i_size = 'extra large')
        )))) > 0
 order by i_product_name
 limit 100