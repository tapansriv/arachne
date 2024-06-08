



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 752 and 752+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'pink' or i_color = 'light') and 
        (i_units = 'Gross' or i_units = 'Bunch') and
        (i_size = 'N/A' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'antique' or i_color = 'rosy') and
        (i_units = 'Unknown' or i_units = 'Lb') and
        (i_size = 'small' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'forest' or i_color = 'cornflower') and
        (i_units = 'Bundle' or i_units = 'Ounce') and
        (i_size = 'extra large' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'royal' or i_color = 'drab') and
        (i_units = 'Ton' or i_units = 'Gram') and
        (i_size = 'N/A' or i_size = 'petite')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'magenta' or i_color = 'dodger') and 
        (i_units = 'Carton' or i_units = 'Dram') and
        (i_size = 'N/A' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'lace' or i_color = 'frosted') and
        (i_units = 'Pound' or i_units = 'Each') and
        (i_size = 'small' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'red' or i_color = 'plum') and
        (i_units = 'Dozen' or i_units = 'Box') and
        (i_size = 'extra large' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'thistle' or i_color = 'floral') and
        (i_units = 'Pallet' or i_units = 'Oz') and
        (i_size = 'N/A' or i_size = 'petite')
        )))) > 0
 order by i_product_name
 limit 100