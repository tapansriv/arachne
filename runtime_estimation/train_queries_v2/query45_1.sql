



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 853 and 853+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'magenta' or i_color = 'cyan') and 
        (i_units = 'Pallet' or i_units = 'Gram') and
        (i_size = 'large' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'violet' or i_color = 'lime') and
        (i_units = 'Gross' or i_units = 'Ounce') and
        (i_size = 'small' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'light' or i_color = 'lawn') and
        (i_units = 'Each' or i_units = 'Tsp') and
        (i_size = 'economy' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'peach' or i_color = 'olive') and
        (i_units = 'Bundle' or i_units = 'Oz') and
        (i_size = 'large' or i_size = 'petite')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'coral' or i_color = 'tomato') and 
        (i_units = 'Lb' or i_units = 'Box') and
        (i_size = 'large' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'wheat' or i_color = 'royal') and
        (i_units = 'Unknown' or i_units = 'Dram') and
        (i_size = 'small' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'pink' or i_color = 'sky') and
        (i_units = 'Pound' or i_units = 'Carton') and
        (i_size = 'economy' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'orchid' or i_color = 'midnight') and
        (i_units = 'Ton' or i_units = 'Tbl') and
        (i_size = 'large' or i_size = 'petite')
        )))) > 0
 order by i_product_name
 limit 100