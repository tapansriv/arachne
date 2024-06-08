



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 904 and 904+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'burnished' or i_color = 'rose') and 
        (i_units = 'Dozen' or i_units = 'Tsp') and
        (i_size = 'small' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'lawn' or i_color = 'drab') and
        (i_units = 'Carton' or i_units = 'Dram') and
        (i_size = 'petite' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'seashell' or i_color = 'cream') and
        (i_units = 'Tbl' or i_units = 'Cup') and
        (i_size = 'large' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'indian' or i_color = 'honeydew') and
        (i_units = 'N/A' or i_units = 'Gross') and
        (i_size = 'small' or i_size = 'extra large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'olive' or i_color = 'chocolate') and 
        (i_units = 'Bundle' or i_units = 'Ounce') and
        (i_size = 'small' or i_size = 'extra large')
        ) or
        (i_category = 'Women' and
        (i_color = 'forest' or i_color = 'navajo') and
        (i_units = 'Pallet' or i_units = 'Case') and
        (i_size = 'petite' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'white' or i_color = 'goldenrod') and
        (i_units = 'Ton' or i_units = 'Gram') and
        (i_size = 'large' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'metallic' or i_color = 'pale') and
        (i_units = 'Each' or i_units = 'Pound') and
        (i_size = 'small' or i_size = 'extra large')
        )))) > 0
 order by i_product_name
 limit 100