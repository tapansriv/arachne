CREATE TABLE results AS
  (SELECT i_product_name ,
          i_brand ,
          i_class ,
          i_category ,
          inv_quantity_on_hand qoh
   FROM 'inventory.parquet' AS inventory ,
        'date_dim.parquet' AS date_dim ,
        'item.parquet' AS item ,
        'warehouse.parquet' AS warehouse
   WHERE inv_date_sk=d_date_sk
     AND inv_item_sk=i_item_sk
     AND inv_warehouse_sk = w_warehouse_sk
     AND d_month_seq BETWEEN 1200 AND 1200 + 11 );

