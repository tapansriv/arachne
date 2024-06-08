



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 833 and 833+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'blush' or i_color = 'green') and 
        (i_units = 'Each' or i_units = 'Pallet') and
        (i_size = 'small' or i_size = 'medium')
        ) or
        (i_category = 'Women' and
        (i_color = 'khaki' or i_color = 'chiffon') and
        (i_units = 'Unknown' or i_units = 'Dozen') and
        (i_size = 'N/A' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'blanched' or i_color = 'almond') and
        (i_units = 'Gram' or i_units = 'Ounce') and
        (i_size = 'extra large' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'sienna' or i_color = 'linen') and
        (i_units = 'Bunch' or i_units = 'Lb') and
        (i_size = 'small' or i_size = 'medium')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'dim' or i_color = 'seashell') and 
        (i_units = 'Bundle' or i_units = 'Tbl') and
        (i_size = 'small' or i_size = 'medium')
        ) or
        (i_category = 'Women' and
        (i_color = 'steel' or i_color = 'turquoise') and
        (i_units = 'N/A' or i_units = 'Cup') and
        (i_size = 'N/A' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'hot' or i_color = 'thistle') and
        (i_units = 'Box' or i_units = 'Pound') and
        (i_size = 'extra large' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'chocolate' or i_color = 'metallic') and
        (i_units = 'Tsp' or i_units = 'Oz') and
        (i_size = 'small' or i_size = 'medium')
        )))) > 0
 order by i_product_name
 limit 100