



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 817 and 817+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'cyan' or i_color = 'metallic') and 
        (i_units = 'Pallet' or i_units = 'Carton') and
        (i_size = 'N/A' or i_size = 'economy')
        ) or
        (i_category = 'Women' and
        (i_color = 'goldenrod' or i_color = 'wheat') and
        (i_units = 'Each' or i_units = 'Dozen') and
        (i_size = 'large' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'puff' or i_color = 'pink') and
        (i_units = 'N/A' or i_units = 'Ounce') and
        (i_size = 'petite' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'chocolate' or i_color = 'burnished') and
        (i_units = 'Bundle' or i_units = 'Dram') and
        (i_size = 'N/A' or i_size = 'economy')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'tan' or i_color = 'sky') and 
        (i_units = 'Gross' or i_units = 'Oz') and
        (i_size = 'N/A' or i_size = 'economy')
        ) or
        (i_category = 'Women' and
        (i_color = 'blue' or i_color = 'thistle') and
        (i_units = 'Tsp' or i_units = 'Tbl') and
        (i_size = 'large' or i_size = 'medium')
        ) or
        (i_category = 'Men' and
        (i_color = 'blanched' or i_color = 'tomato') and
        (i_units = 'Bunch' or i_units = 'Unknown') and
        (i_size = 'petite' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'purple' or i_color = 'forest') and
        (i_units = 'Case' or i_units = 'Pound') and
        (i_size = 'N/A' or i_size = 'economy')
        )))) > 0
 order by i_product_name
 limit 100