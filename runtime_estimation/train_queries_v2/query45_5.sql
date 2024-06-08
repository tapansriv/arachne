



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 954 and 954+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'pink' or i_color = 'medium') and 
        (i_units = 'N/A' or i_units = 'Cup') and
        (i_size = 'N/A' or i_size = 'medium')
        ) or
        (i_category = 'Women' and
        (i_color = 'burnished' or i_color = 'tan') and
        (i_units = 'Lb' or i_units = 'Case') and
        (i_size = 'petite' or i_size = 'small')
        ) or
        (i_category = 'Men' and
        (i_color = 'navajo' or i_color = 'saddle') and
        (i_units = 'Dram' or i_units = 'Gram') and
        (i_size = 'extra large' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'beige' or i_color = 'powder') and
        (i_units = 'Dozen' or i_units = 'Gross') and
        (i_size = 'N/A' or i_size = 'medium')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'ivory' or i_color = 'orange') and 
        (i_units = 'Tbl' or i_units = 'Ton') and
        (i_size = 'N/A' or i_size = 'medium')
        ) or
        (i_category = 'Women' and
        (i_color = 'sienna' or i_color = 'rose') and
        (i_units = 'Bunch' or i_units = 'Pound') and
        (i_size = 'petite' or i_size = 'small')
        ) or
        (i_category = 'Men' and
        (i_color = 'green' or i_color = 'pale') and
        (i_units = 'Box' or i_units = 'Ounce') and
        (i_size = 'extra large' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'indian' or i_color = 'puff') and
        (i_units = 'Each' or i_units = 'Carton') and
        (i_size = 'N/A' or i_size = 'medium')
        )))) > 0
 order by i_product_name
 limit 100