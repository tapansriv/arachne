



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 950 and 950+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'yellow' or i_color = 'moccasin') and 
        (i_units = 'Cup' or i_units = 'Oz') and
        (i_size = 'small' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'beige' or i_color = 'forest') and
        (i_units = 'Box' or i_units = 'Unknown') and
        (i_size = 'extra large' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'aquamarine' or i_color = 'peach') and
        (i_units = 'Bundle' or i_units = 'Bunch') and
        (i_size = 'economy' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'dark' or i_color = 'mint') and
        (i_units = 'Tbl' or i_units = 'Dozen') and
        (i_size = 'small' or i_size = 'petite')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'royal' or i_color = 'cornsilk') and 
        (i_units = 'Pallet' or i_units = 'Dram') and
        (i_size = 'small' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'blush' or i_color = 'pink') and
        (i_units = 'Ton' or i_units = 'Lb') and
        (i_size = 'extra large' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'seashell' or i_color = 'dim') and
        (i_units = 'Pound' or i_units = 'Tsp') and
        (i_size = 'economy' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'burnished' or i_color = 'tomato') and
        (i_units = 'Carton' or i_units = 'Ounce') and
        (i_size = 'small' or i_size = 'petite')
        )))) > 0
 order by i_product_name
 limit 100