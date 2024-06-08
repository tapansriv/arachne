



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 763 and 763+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'burlywood' or i_color = 'wheat') and 
        (i_units = 'Dram' or i_units = 'Tbl') and
        (i_size = 'extra large' or i_size = 'small')
        ) or
        (i_category = 'Women' and
        (i_color = 'honeydew' or i_color = 'forest') and
        (i_units = 'Pallet' or i_units = 'Lb') and
        (i_size = 'medium' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'chiffon' or i_color = 'beige') and
        (i_units = 'Bundle' or i_units = 'Box') and
        (i_size = 'petite' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'brown' or i_color = 'linen') and
        (i_units = 'Each' or i_units = 'Unknown') and
        (i_size = 'extra large' or i_size = 'small')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'rose' or i_color = 'yellow') and 
        (i_units = 'Gram' or i_units = 'Case') and
        (i_size = 'extra large' or i_size = 'small')
        ) or
        (i_category = 'Women' and
        (i_color = 'frosted' or i_color = 'cream') and
        (i_units = 'Dozen' or i_units = 'Oz') and
        (i_size = 'medium' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'rosy' or i_color = 'dark') and
        (i_units = 'Cup' or i_units = 'Gross') and
        (i_size = 'petite' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'sienna' or i_color = 'gainsboro') and
        (i_units = 'Carton' or i_units = 'Tsp') and
        (i_size = 'extra large' or i_size = 'small')
        )))) > 0
 order by i_product_name
 limit 100