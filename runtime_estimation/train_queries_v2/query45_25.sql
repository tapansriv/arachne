



select  distinct(i_product_name)
 from item i1
 where i_manufact_id between 937 and 937+40 
   and (select count(*) as item_cnt
        from item
        where (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'orange' or i_color = 'snow') and 
        (i_units = 'Pound' or i_units = 'Tsp') and
        (i_size = 'petite' or i_size = 'small')
        ) or
        (i_category = 'Women' and
        (i_color = 'cyan' or i_color = 'maroon') and
        (i_units = 'Box' or i_units = 'Each') and
        (i_size = 'economy' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'mint' or i_color = 'thistle') and
        (i_units = 'Case' or i_units = 'Gram') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'peach' or i_color = 'navy') and
        (i_units = 'Ounce' or i_units = 'Tbl') and
        (i_size = 'petite' or i_size = 'small')
        ))) or
       (i_manufact = i1.i_manufact and
        ((i_category = 'Women' and 
        (i_color = 'ghost' or i_color = 'blue') and 
        (i_units = 'Bunch' or i_units = 'Dram') and
        (i_size = 'petite' or i_size = 'small')
        ) or
        (i_category = 'Women' and
        (i_color = 'moccasin' or i_color = 'gainsboro') and
        (i_units = 'Gross' or i_units = 'Carton') and
        (i_size = 'economy' or i_size = 'N/A')
        ) or
        (i_category = 'Men' and
        (i_color = 'navajo' or i_color = 'honeydew') and
        (i_units = 'Bundle' or i_units = 'Pallet') and
        (i_size = 'medium' or i_size = 'extra large')
        ) or
        (i_category = 'Men' and
        (i_color = 'almond' or i_color = 'white') and
        (i_units = 'Ton' or i_units = 'Oz') and
        (i_size = 'petite' or i_size = 'small')
        )))) > 0
 order by i_product_name
 limit 100