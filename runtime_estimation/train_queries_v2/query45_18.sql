



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 841 and 841+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'dark' or i_color = 'coral') and 
        (i_units = 'Oz' or i_units = 'Gram') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'misty' or i_color = 'violet') and
        (i_units = 'Dram' or i_units = 'Tbl') and
        (i_size = 'petite' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'almond' or i_color = 'powder') and
        (i_units = 'Lb' or i_units = 'Dozen') and
        (i_size = 'extra large' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'sienna' or i_color = 'seashell') and
        (i_units = 'Ounce' or i_units = 'Bunch') and
        (i_size = 'small' or i_size = 'N/A')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'chartreuse' or i_color = 'lime') and 
        (i_units = 'Tsp' or i_units = 'Box') and
        (i_size = 'small' or i_size = 'N/A')
        ) or
        (i_category = 'Women' and
        (i_color = 'azure' or i_color = 'cream') and
        (i_units = 'Gross' or i_units = 'Pallet') and
        (i_size = 'petite' or i_size = 'large')
        ) or
        (i_category = 'Men' and
        (i_color = 'sky' or i_color = 'indian') and
        (i_units = 'Cup' or i_units = 'Case') and
        (i_size = 'extra large' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'frosted' or i_color = 'yellow') and
        (i_units = 'Carton' or i_units = 'Ton') and
        (i_size = 'small' or i_size = 'N/A')
        )))) > 0
 order by i_product_name
 limit 100