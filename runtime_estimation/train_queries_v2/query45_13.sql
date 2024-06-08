



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 946 and 946+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'lavender' or i_color = 'rosy') and 
        (i_units = 'Gross' or i_units = 'Cup') and
        (i_size = 'small' or i_size = 'medium')
        ) or
        (i_category = 'Women' and
        (i_color = 'chiffon' or i_color = 'beige') and
        (i_units = 'Pound' or i_units = 'Tbl') and
        (i_size = 'petite' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'pink' or i_color = 'forest') and
        (i_units = 'Carton' or i_units = 'Ounce') and
        (i_size = 'extra large' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'blanched' or i_color = 'metallic') and
        (i_units = 'Each' or i_units = 'Oz') and
        (i_size = 'small' or i_size = 'medium')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'sky' or i_color = 'green') and 
        (i_units = 'Lb' or i_units = 'Bundle') and
        (i_size = 'small' or i_size = 'medium')
        ) or
        (i_category = 'Women' and
        (i_color = 'snow' or i_color = 'plum') and
        (i_units = 'Case' or i_units = 'Pallet') and
        (i_size = 'petite' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'dim' or i_color = 'honeydew') and
        (i_units = 'Box' or i_units = 'Unknown') and
        (i_size = 'extra large' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'peach' or i_color = 'spring') and
        (i_units = 'Bunch' or i_units = 'Dram') and
        (i_size = 'small' or i_size = 'medium')
        )))) > 0
 order by i_product_name
 limit 100