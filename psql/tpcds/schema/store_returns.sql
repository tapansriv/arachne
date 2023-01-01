create table store_returns(
	sr_returned_date_sk integer,
	sr_return_time_sk integer,
	sr_item_sk integer not null,
	sr_customer_sk integer,
	sr_cdemo_sk integer,
	sr_hdemo_sk integer,
	sr_addr_sk integer,
	sr_store_sk integer,
	sr_reason_sk integer,
	sr_ticket_number integer not null,
	sr_return_quantity integer,
	sr_return_amt double precision,
	sr_return_tax double precision,
	sr_return_amt_inc_tax double precision,
	sr_fee double precision,
	sr_return_ship_cost double precision,
	sr_refunded_cash double precision,
	sr_reversed_charge double precision,
	sr_store_credit double precision,
	sr_net_loss double precision,
    dummy int,
    PRIMARY KEY (sr_item_sk, sr_ticket_number)
);
