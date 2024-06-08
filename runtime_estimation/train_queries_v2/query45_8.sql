



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 734 and 734+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'sienna' or i_color = 'beige') and 
        (i_units = 'Bundle' or i_units = 'Gram') and
        (i_size = 'economy' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'plum' or i_color = 'thistle') and
        (i_units = 'Dozen' or i_units = 'Bunch') and
        (i_size = 'large' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'sandy' or i_color = 'aquamarine') and
        (i_units = 'Oz' or i_units = 'Ounce') and
        (i_size = 'N/A' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'steel' or i_color = 'royal') and
        (i_units = 'Gross' or i_units = 'Lb') and
        (i_size = 'economy' or i_size = 'petite')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'ghost' or i_color = 'firebrick') and 
        (i_units = 'Dram' or i_units = 'Pound') and
        (i_size = 'economy' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'lace' or i_color = 'lawn') and
        (i_units = 'Tsp' or i_units = 'N/A') and
        (i_size = 'large' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'honeydew' or i_color = 'cream') and
        (i_units = 'Cup' or i_units = 'Box') and
        (i_size = 'N/A' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'tomato' or i_color = 'dodger') and
        (i_units = 'Ton' or i_units = 'Each') and
        (i_size = 'economy' or i_size = 'petite')
        )))) > 0
 order by i_product_name
 limit 100