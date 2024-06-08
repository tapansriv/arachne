



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 671 and 671+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'misty' or i_color = 'mint') and 
        (i_units = 'Dram' or i_units = 'Cup') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'gainsboro' or i_color = 'cornsilk') and
        (i_units = 'Unknown' or i_units = 'Ounce') and
        (i_size = 'large' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'olive' or i_color = 'khaki') and
        (i_units = 'Bunch' or i_units = 'Each') and
        (i_size = 'medium' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'orange' or i_color = 'thistle') and
        (i_units = 'Gram' or i_units = 'Oz') and
        (i_size = 'small' or i_size = 'N/A')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'puff' or i_color = 'lemon') and 
        (i_units = 'Ton' or i_units = 'Bundle') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'red' or i_color = 'wheat') and
        (i_units = 'Pound' or i_units = 'Pallet') and
        (i_size = 'large' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'dark' or i_color = 'sky') and
        (i_units = 'Case' or i_units = 'Lb') and
        (i_size = 'medium' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'moccasin' or i_color = 'midnight') and
        (i_units = 'Gross' or i_units = 'Tbl') and
        (i_size = 'small' or i_size = 'N/A')
        )))) > 0
 order by i_product_name
 limit 100