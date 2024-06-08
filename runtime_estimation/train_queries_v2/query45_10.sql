



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 760 and 760+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'lace' or i_color = 'steel') and 
        (i_units = 'Carton' or i_units = 'Ton') and
        (i_size = 'N/A' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'azure' or i_color = 'forest') and
        (i_units = 'Pound' or i_units = 'Each') and
        (i_size = 'large' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'beige' or i_color = 'thistle') and
        (i_units = 'Pallet' or i_units = 'Unknown') and
        (i_size = 'medium' or i_size = 'small')
        ) or
        (i_category = 'Men' and
        (i_color = 'turquoise' or i_color = 'slate') and
        (i_units = 'Ounce' or i_units = 'N/A') and
        (i_size = 'N/A' or i_size = 'petite')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'dim' or i_color = 'saddle') and 
        (i_units = 'Tsp' or i_units = 'Gross') and
        (i_size = 'N/A' or i_size = 'petite')
        ) or
        (i_category = 'Women' and
        (i_color = 'mint' or i_color = 'gainsboro') and
        (i_units = 'Dram' or i_units = 'Cup') and
        (i_size = 'large' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'navajo' or i_color = 'burnished') and
        (i_units = 'Case' or i_units = 'Oz') and
        (i_size = 'medium' or i_size = 'small')
        ) or
        (i_category = 'Men' and
        (i_color = 'tomato' or i_color = 'puff') and
        (i_units = 'Box' or i_units = 'Tbl') and
        (i_size = 'N/A' or i_size = 'petite')
        )))) > 0
 order by i_product_name
 limit 100