



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 829 and 829+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'cornsilk' or i_color = 'green') and 
        (i_units = 'Oz' or i_units = 'Bunch') and
        (i_size = 'economy' or i_size = 'small')
        ) or
        (i_category = 'Women' and
        (i_color = 'mint' or i_color = 'forest') and
        (i_units = 'Tsp' or i_units = 'Lb') and
        (i_size = 'N/A' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'thistle' or i_color = 'pink') and
        (i_units = 'Gram' or i_units = 'Pallet') and
        (i_size = 'medium' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'rose' or i_color = 'blue') and
        (i_units = 'Bundle' or i_units = 'Tbl') and
        (i_size = 'economy' or i_size = 'small')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'sandy' or i_color = 'drab') and 
        (i_units = 'Gross' or i_units = 'Pound') and
        (i_size = 'economy' or i_size = 'small')
        ) or
        (i_category = 'Women' and
        (i_color = 'honeydew' or i_color = 'ivory') and
        (i_units = 'Each' or i_units = 'Carton') and
        (i_size = 'N/A' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'lemon' or i_color = 'bisque') and
        (i_units = 'Dozen' or i_units = 'Ton') and
        (i_size = 'medium' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'chiffon' or i_color = 'rosy') and
        (i_units = 'Box' or i_units = 'Cup') and
        (i_size = 'economy' or i_size = 'small')
        )))) > 0
 order by i_product_name
 limit 100