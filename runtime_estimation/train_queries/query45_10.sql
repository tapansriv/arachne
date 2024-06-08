



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 945 and 945+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'ivory' or i_color = 'pink') and 
        (i_units = 'N/A' or i_units = 'Pound') and
        (i_size = 'petite' or i_size = 'large')
        ) or
        (i_category = 'Women' and
        (i_color = 'dodger' or i_color = 'salmon') and
        (i_units = 'Dozen' or i_units = 'Box') and
        (i_size = 'small' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'forest' or i_color = 'beige') and
        (i_units = 'Pallet' or i_units = 'Each') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'black' or i_color = 'coral') and
        (i_units = 'Case' or i_units = 'Lb') and
        (i_size = 'petite' or i_size = 'large')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'puff' or i_color = 'steel') and 
        (i_units = 'Cup' or i_units = 'Tsp') and
        (i_size = 'petite' or i_size = 'large')
        ) or
        (i_category = 'Women' and
        (i_color = 'smoke' or i_color = 'saddle') and
        (i_units = 'Dram' or i_units = 'Tbl') and
        (i_size = 'small' or i_size = 'economy')
        ) or
        (i_category = 'Men' and
        (i_color = 'rose' or i_color = 'snow') and
        (i_units = 'Ounce' or i_units = 'Gross') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'grey' or i_color = 'floral') and
        (i_units = 'Bunch' or i_units = 'Unknown') and
        (i_size = 'petite' or i_size = 'large')
        )))) > 0
 order by i_product_name
 limit 100