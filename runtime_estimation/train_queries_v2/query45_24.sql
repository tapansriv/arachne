



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 944 and 944+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'orchid' or i_color = 'beige') and 
        (i_units = 'Cup' or i_units = 'Each') and
        (i_size = 'N/A' or i_size = 'medium')
        ) or
        (i_category = 'Women' and
        (i_color = 'dim' or i_color = 'dodger') and
        (i_units = 'Box' or i_units = 'Tsp') and
        (i_size = 'small' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'ghost' or i_color = 'light') and
        (i_units = 'Ton' or i_units = 'Gross') and
        (i_size = 'large' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'brown' or i_color = 'yellow') and
        (i_units = 'Pound' or i_units = 'Dram') and
        (i_size = 'N/A' or i_size = 'medium')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'chocolate' or i_color = 'salmon') and 
        (i_units = 'Gram' or i_units = 'Unknown') and
        (i_size = 'N/A' or i_size = 'medium')
        ) or
        (i_category = 'Women' and
        (i_color = 'steel' or i_color = 'rose') and
        (i_units = 'Pallet' or i_units = 'Ounce') and
        (i_size = 'small' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'magenta' or i_color = 'plum') and
        (i_units = 'Case' or i_units = 'Dozen') and
        (i_size = 'large' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'green' or i_color = 'goldenrod') and
        (i_units = 'Bundle' or i_units = 'Bunch') and
        (i_size = 'N/A' or i_size = 'medium')
        )))) > 0
 order by i_product_name
 limit 100