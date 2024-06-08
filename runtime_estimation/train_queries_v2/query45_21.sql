



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 981 and 981+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'honeydew' or i_color = 'royal') and 
        (i_units = 'Unknown' or i_units = 'Cup') and
        (i_size = 'medium' or i_size = 'small')
        ) or
        (i_category = 'Women' and
        (i_color = 'salmon' or i_color = 'saddle') and
        (i_units = 'Gram' or i_units = 'Bunch') and
        (i_size = 'economy' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'dark' or i_color = 'blanched') and
        (i_units = 'Each' or i_units = 'Lb') and
        (i_size = 'N/A' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'hot' or i_color = 'floral') and
        (i_units = 'Pallet' or i_units = 'Dram') and
        (i_size = 'medium' or i_size = 'small')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'cream' or i_color = 'snow') and 
        (i_units = 'Pound' or i_units = 'Carton') and
        (i_size = 'medium' or i_size = 'small')
        ) or
        (i_category = 'Women' and
        (i_color = 'navy' or i_color = 'burlywood') and
        (i_units = 'Box' or i_units = 'Dozen') and
        (i_size = 'economy' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'rosy' or i_color = 'puff') and
        (i_units = 'Oz' or i_units = 'Case') and
        (i_size = 'N/A' or i_size = 'petite')
        ) or
        (i_category = 'Men' and
        (i_color = 'tomato' or i_color = 'lavender') and
        (i_units = 'N/A' or i_units = 'Bundle') and
        (i_size = 'medium' or i_size = 'small')
        )))) > 0
 order by i_product_name
 limit 100