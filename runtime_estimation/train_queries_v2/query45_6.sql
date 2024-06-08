



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 984 and 984+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'pale' or i_color = 'magenta') and 
        (i_units = 'Lb' or i_units = 'Pound') and
        (i_size = 'petite' or i_size = 'large')
        ) or
        (i_category = 'Women' and
        (i_color = 'aquamarine' or i_color = 'sienna') and
        (i_units = 'Each' or i_units = 'Box') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'dodger' or i_color = 'green') and
        (i_units = 'Pallet' or i_units = 'Ton') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'deep' or i_color = 'khaki') and
        (i_units = 'Tbl' or i_units = 'Ounce') and
        (i_size = 'petite' or i_size = 'large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'gainsboro' or i_color = 'almond') and 
        (i_units = 'Unknown' or i_units = 'Bundle') and
        (i_size = 'petite' or i_size = 'large')
        ) or
        (i_category = 'Women' and
        (i_color = 'rose' or i_color = 'coral') and
        (i_units = 'Cup' or i_units = 'Case') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'cyan' or i_color = 'firebrick') and
        (i_units = 'Carton' or i_units = 'Gram') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'peru' or i_color = 'metallic') and
        (i_units = 'N/A' or i_units = 'Dozen') and
        (i_size = 'petite' or i_size = 'large')
        )))) > 0
 order by i_product_name
 limit 100