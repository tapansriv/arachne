create table store_sales(
	ss_sold_date_sk integer,
	ss_sold_time_sk integer,
	ss_item_sk integer not null,
	ss_customer_sk integer,
	ss_cdemo_sk integer,
	ss_hdemo_sk integer,
	ss_addr_sk integer,
	ss_store_sk integer,
	ss_promo_sk integer,
	ss_ticket_number integer not null,
	ss_quantity integer,
	ss_wholesale_cost double precision,
	ss_list_price double precision,
	ss_sales_price double precision,
	ss_ext_discount_amt double precision,
	ss_ext_sales_price double precision,
	ss_ext_wholesale_cost double precision,
	ss_ext_list_price double precision,
	ss_ext_tax double precision,
	ss_coupon_amt double precision,
	ss_net_paid double precision,
	ss_net_paid_inc_tax double precision,
	ss_net_profit double precision
);
