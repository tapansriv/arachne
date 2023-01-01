create table inventory(
	inv_date_sk integer not null,
	inv_item_sk integer not null,
	inv_warehouse_sk integer not null,
	inv_quantity_on_hand integer,
    dummy int,
    PRIMARY KEY (inv_date_sk, inv_item_sk, inv_warehouse_sk)
);
