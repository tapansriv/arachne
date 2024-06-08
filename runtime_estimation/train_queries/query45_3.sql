



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 887 and 887+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'sienna' or i_color = 'frosted') and 
        (i_units = 'Gram' or i_units = 'Case') and
        (i_size = 'economy' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'snow' or i_color = 'almond') and
        (i_units = 'Bunch' or i_units = 'Carton') and
        (i_size = 'large' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'metallic' or i_color = 'purple') and
        (i_units = 'Gross' or i_units = 'Each') and
        (i_size = 'petite' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'drab' or i_color = 'indian') and
        (i_units = 'Unknown' or i_units = 'N/A') and
        (i_size = 'economy' or i_size = 'N/A')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'yellow' or i_color = 'beige') and 
        (i_units = 'Cup' or i_units = 'Bundle') and
        (i_size = 'economy' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'grey' or i_color = 'orange') and
        (i_units = 'Tsp' or i_units = 'Ton') and
        (i_size = 'large' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'dodger' or i_color = 'medium') and
        (i_units = 'Lb' or i_units = 'Pallet') and
        (i_size = 'petite' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'magenta' or i_color = 'lemon') and
        (i_units = 'Oz' or i_units = 'Tbl') and
        (i_size = 'economy' or i_size = 'N/A')
        )))) > 0
 order by i_product_name
 limit 100