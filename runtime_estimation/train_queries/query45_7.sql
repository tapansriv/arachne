



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 776 and 776+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'pale' or i_color = 'goldenrod') and 
        (i_units = 'Pallet' or i_units = 'Ounce') and
        (i_size = 'N/A' or i_size = 'small')
        ) or
        (i_category = 'Women' and
        (i_color = 'moccasin' or i_color = 'lemon') and
        (i_units = 'Bundle' or i_units = 'Lb') and
        (i_size = 'large' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'chocolate' or i_color = 'azure') and
        (i_units = 'Cup' or i_units = 'Dram') and
        (i_size = 'petite' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'orange' or i_color = 'metallic') and
        (i_units = 'Pound' or i_units = 'Each') and
        (i_size = 'N/A' or i_size = 'small')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'tomato' or i_color = 'steel') and 
        (i_units = 'Dozen' or i_units = 'Box') and
        (i_size = 'N/A' or i_size = 'small')
        ) or
        (i_category = 'Women' and
        (i_color = 'powder' or i_color = 'chiffon') and
        (i_units = 'Ton' or i_units = 'Tsp') and
        (i_size = 'large' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'floral' or i_color = 'burnished') and
        (i_units = 'Gross' or i_units = 'Gram') and
        (i_size = 'petite' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'almond' or i_color = 'gainsboro') and
        (i_units = 'N/A' or i_units = 'Oz') and
        (i_size = 'N/A' or i_size = 'small')
        )))) > 0
 order by i_product_name
 limit 100