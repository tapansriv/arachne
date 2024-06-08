



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 966 and 966+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'lace' or i_color = 'brown') and 
        (i_units = 'Bundle' or i_units = 'Box') and
        (i_size = 'medium' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'lime' or i_color = 'cornflower') and
        (i_units = 'Cup' or i_units = 'Gross') and
        (i_size = 'small' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'sandy' or i_color = 'tomato') and
        (i_units = 'Ounce' or i_units = 'Dozen') and
        (i_size = 'economy' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'burnished' or i_color = 'cyan') and
        (i_units = 'Each' or i_units = 'Case') and
        (i_size = 'medium' or i_size = 'petite')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'dim' or i_color = 'metallic') and 
        (i_units = 'Gram' or i_units = 'Tsp') and
        (i_size = 'medium' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'cream' or i_color = 'spring') and
        (i_units = 'Pallet' or i_units = 'Unknown') and
        (i_size = 'small' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'smoke' or i_color = 'firebrick') and
        (i_units = 'Pound' or i_units = 'Ton') and
        (i_size = 'economy' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'chiffon' or i_color = 'salmon') and
        (i_units = 'Carton' or i_units = 'Tbl') and
        (i_size = 'medium' or i_size = 'petite')
        )))) > 0
 order by i_product_name
 limit 100