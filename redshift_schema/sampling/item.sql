create table item(
	i_item_sk integer not null,
	i_item_id varchar(16) not null,
	i_rec_start_date date,
    i_rec_end_date date, 
    i_item_desc varchar(200),
	i_current_price decimal(7,2),
	i_wholesale_cost decimal(7,2),
	i_brand_id integer,
	i_brand varchar(50),
	i_class_id integer,
	i_class varchar(50),
	i_category_id integer,
	i_category varchar(50),
	i_manufact_id integer,
	i_manufact varchar(50),
	i_size varchar(20),
	i_formulation varchar(20),
	i_color varchar(20),
	i_units varchar(10),
	i_container varchar(10),
	i_manager_id integer,
	i_product_name varchar(50)
);
